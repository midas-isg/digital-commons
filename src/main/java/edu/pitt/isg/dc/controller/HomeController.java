package edu.pitt.isg.dc.controller;

import com.google.gson.*;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.digital.spew.SpewLocation;
import edu.pitt.isg.dc.digital.spew.SpewRule;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.CategoryOrder;
import edu.pitt.isg.dc.entry.CategoryOrderRepository;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.EntryApproval;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.utils.DigitalCommonsHelper;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.WordUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.QueryParam;
import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@ApiIgnore
@Controller
public class HomeController {
    private static String VIEWER_URL = "";
    private static String VIEWER_TOKEN = "";
    private static String SPEW_CACHE_FILE = "";
    private static String LIBRARY_COLLECTIONS_CACHE_FILE = "";
    private String libraryCollectionsJson = "";

    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        VIEWER_URL = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_VIEWER_URL);
        VIEWER_TOKEN = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_VIEWER_TOKEN);
        SPEW_CACHE_FILE = configurationProperties.getProperty(DigitalCommonsProperties.SPEW_CACHE_FILE_LOCATION);
        LIBRARY_COLLECTIONS_CACHE_FILE = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_COLLECTIONS_CACHE_FILE_LOCATION);
    }

    @Autowired
    private SpewRule spewRule;

    @Autowired
    private EntryApprovalInterface entryApprovalInterface;

    @Autowired
    private CategoryOrderRepository categoryOrderRepository;

    private Integer spewCount;
    private Integer spewAmericaCount;

    private void recurseSpewTree(SpewLocation location, boolean usa) {
        for (Map.Entry<String,SpewLocation> entry : location.getChildren().entrySet()) {
            SpewLocation subLocation = entry.getValue();
            if(subLocation.getName().equals("united states of america")) {
                recurseSpewTree(subLocation, true);
            }
            if(subLocation.getChildren() != null && !usa) {
                recurseSpewTree(subLocation, false);
            } else {
                spewCount++;
            }
        }
    }

    private void recureAmericaTree(SpewLocation location, boolean usa) {
        for (Map.Entry<String,SpewLocation> entry : location.getChildren().entrySet()) {
            SpewLocation subLocation = entry.getValue();
            if(subLocation.getName().equals("united states of america")) {
                recureAmericaTree(subLocation, true);
            }
            if(subLocation.getChildren() != null && !usa) {
                recureAmericaTree(subLocation, false);
            } else {
                spewAmericaCount++;
            }
        }
    }

    public void populateCommonsMainModel(Model model) throws MdcEntryDatastoreException {
        try {
            model.addAttribute("spewRegions", spewRule.treeRegions());
            spewCount=0;
            spewAmericaCount = 0;
            for(SpewLocation location : spewRule.treeRegions()) {
                if (location.getName().toLowerCase().contains("america")) {
                    recureAmericaTree(location, false);
                }
                recurseSpewTree(location, false);
            }
            //we do not show burkina faso
            spewCount--;
            model.addAttribute("spewRegionCount", spewCount);
            model.addAttribute("spewAmericaCount", spewAmericaCount);

        } catch (Exception e) {
            try {
                Path path = Paths.get(SPEW_CACHE_FILE);

                FileInputStream fis = new FileInputStream(path.toFile());
                ObjectInputStream ois = new ObjectInputStream(fis);
                Iterable<SpewLocation> spewLocationIterable = (Iterable<SpewLocation>) ois.readObject();

                model.addAttribute("spewRegions", spewLocationIterable);
            } catch (Exception ee) {
                SpewLocation emptySpew = new SpewLocation();
                emptySpew.setName("Error loading data from SPEW");
                List<SpewLocation> tree = new ArrayList<>();
                tree.add(emptySpew);
                model.addAttribute("spewRegions", tree);
            }
        }

        List<Map<String,String>> treeInfoArr = getEntryTrees();
        model.addAttribute("treeInfoArr", treeInfoArr);
        model.addAttribute("libraryViewerUrl", VIEWER_URL);
        model.addAttribute("libraryViewerToken", VIEWER_TOKEN);
        model.addAttribute("preview", true);
    }

    public List<Map<String,String>> getEntryTrees() throws MdcEntryDatastoreException {
        List<CategoryOrder> categoryOrders = categoryOrderRepository.findAll();
        Category rootCategory = new Category();
        Map<Category, List<Category>> categoryOrderMap = new HashMap<>();
        for(CategoryOrder co : categoryOrders) {
            Category category = co.getCategory();
            Category subcategory = co.getSubcategory();

            if(category.getCategory().equals("Root")) {
                rootCategory = category;
            }

            if(categoryOrderMap.containsKey(category)) {
                List<Category> subcategories = categoryOrderMap.get(category);
                subcategories.add(subcategory);
                categoryOrderMap.put(category, subcategories);
            } else {
                List<Category> subcategories = new ArrayList<>();
                subcategories.add(subcategory);
                categoryOrderMap.put(category, subcategories);
            }
        }

        List<EntryView> entries = entryApprovalInterface.getApprovedEntries();
        Map<Long, List<EntryView>> categoryEntryMap = new HashMap<>();
        for(EntryView entry : entries) {
            Long categoryId = entry.getCategory().getId();

            if(categoryEntryMap.containsKey(categoryId)) {
                List<EntryView> categoryEntries = categoryEntryMap.get(categoryId);
                categoryEntries.add(entry);
                categoryEntryMap.put(categoryId, categoryEntries);
            } else {
                List<EntryView> categoryEntries = new ArrayList<>();
                categoryEntries.add(entry);
                categoryEntryMap.put(categoryId, categoryEntries);
            }
        }

        List<Map<String,String>> treeInfoArr = new ArrayList<>();
        for(Category node : categoryOrderMap.get(rootCategory)) {
            JsonArray tree = new JsonArray();
            tree = recurseCategories(node, categoryOrderMap, categoryEntryMap, tree);
            JsonArray treeNodes = (JsonArray) tree.get(0).getAsJsonObject().get("nodes");
            Map<String, String> treeInfo = new HashMap<>();
            treeInfo.put("category" , node.getCategory());
            treeInfo.put("json", StringEscapeUtils.escapeJavaScript(treeNodes.toString()));
            treeInfoArr.add(treeInfo);
        }


        return treeInfoArr;
    }

    private JsonArray recurseCategories(Category category, Map<Category, List<Category>> categoryOrderMap, Map<Long, List<EntryView>> categoryEntryMap, JsonArray tree) {
        JsonObject treeNode = new JsonObject();
        treeNode.addProperty("categoryId", category.getId());
        treeNode.addProperty("text", category.getCategory());
        treeNode.addProperty("count", 0);
        treeNode.add("nodes", new JsonArray());

       if(categoryEntryMap.containsKey(category.getId())) {
            List<EntryView> entries = categoryEntryMap.get(category.getId());
            for(EntryView entry : entries) {
                String title = "";
                LinkedHashMap entryData = (LinkedHashMap) entry.getEntry();
                if(entryData.containsKey("title")) {
                    title = String.valueOf(entryData.get("title"));
                } else if(entryData.containsKey("name")) {
                    title = String.valueOf(entryData.get("name"));
                }

                JsonObject leafNode = new JsonObject();
                leafNode.addProperty("entryId", entry.getId());
                leafNode.addProperty("json", entry.getUnescapedEntryJsonString());
                leafNode.addProperty("text", title);
                treeNode.getAsJsonArray("nodes").add(leafNode);

                int count = treeNode.getAsJsonObject().getP
            }
        }

        if(categoryOrderMap.containsKey(category)) {
            List<Category> childNodes = categoryOrderMap.get(category);
            for(Category node : childNodes) {
                recurseCategories(node, categoryOrderMap, categoryEntryMap, treeNode.getAsJsonArray("nodes"));
            }
        }

        tree.add(treeNode);
        return tree;
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String redirectHome() {
        return "redirect:/main";
    }

    @RequestMapping(value = "/main", method = RequestMethod.GET)
    public String hello(Model model) throws Exception {
        populateCommonsMainModel(model);
        return "commons";
    }

//    @RequestMapping(value = "/add", method = RequestMethod.GET)
//    public String addEntry(Model model) throws Exception {
//        model.addAttribute("xsdForms", DataEntryController.readXSDFiles());
//        return "addEntry";
//    }

    @RequestMapping(value = "/add/{category}", method = RequestMethod.GET)
    public String addNewDataFormatConverters(@PathVariable(value = "category") String category, @RequestParam(value = "datasetType", required = false) String datasetType,
                                             @RequestParam(value = "customValue", required = false) String customValue, Model model) throws Exception {
        model.addAttribute("category", category);
        if(category.toLowerCase().equals("dataset")) {
            model.addAttribute("datasetType", datasetType);
            model.addAttribute("customValue", customValue);
            return "Dataset";
        } else {
            return WordUtils.capitalize(category);

        }
    }

    @RequestMapping(value = "/getCollectionsJson", method = RequestMethod.GET, headers = "Accept=application/json; charset=utf-8")
    public
    @ResponseBody
    String getCollectionsJson() throws Exception {

        if(!libraryCollectionsJson.equals("") && !libraryCollectionsJson.equals("{}")) {

            return libraryCollectionsJson;
        } else {
            try {
                Path path = Paths.get(LIBRARY_COLLECTIONS_CACHE_FILE);
                FileInputStream fis = new FileInputStream(path.toFile());
                ObjectInputStream ois = new ObjectInputStream(fis);
                libraryCollectionsJson = (String) ois.readObject();
                return libraryCollectionsJson;
            } catch (Exception e) {
                queryCollectionsJson(VIEWER_URL, VIEWER_TOKEN);
                return libraryCollectionsJson;
            }
        }
    }

    private void queryCollectionsJson(String viewerUrl, String viewerToken) throws Exception {
        String libraryUrl = viewerUrl.replace("\"", "") + "collectionsJson/";
        String token = viewerToken.replace("\"", "");

        HttpClient client = new DefaultHttpClient();
        HttpGet request = new HttpGet(libraryUrl);

        request.addHeader("Authorization", token);
        request.addHeader("Accept-Charset", "UTF-8");
        request.addHeader("Accept", "application/json");

        HttpResponse response = client.execute(request);

        BufferedReader rd = new BufferedReader(
                new InputStreamReader(response.getEntity().getContent()));

        StringBuffer result = new StringBuffer();
        String line = "";
        while ((line = rd.readLine()) != null) {
            result.append(line);
        }

//
//        URL url = new URL(libraryUrl);
//        HttpURLConnection con = (HttpURLConnection) url.openConnection();
//
//        con.setRequestMethod("GET");
//        con.setRequestProperty("Authorization", token);
//        con.setRequestProperty("Accept-Charset", "UTF-8");
//        con.setRequestProperty("Accept", "application/json");
//
//        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
//        String inputLine;
//        StringBuffer response = new StringBuffer();
//
//        while ((inputLine = in.readLine()) != null) {
//            response.append(inputLine);
//        }
//        in.close();

        libraryCollectionsJson = result.toString();
        writeCollectionsJson();
    }

    private void writeCollectionsJson() {
        try {
            Path path = Paths.get(LIBRARY_COLLECTIONS_CACHE_FILE);
            FileOutputStream fos = new FileOutputStream(path.toFile());
            ObjectOutputStream oos = new ObjectOutputStream(fos);

            oos.writeObject(libraryCollectionsJson);
        }catch (FileNotFoundException e) {
            System.out.println(e.getMessage());
        }catch (IOException ex) {
            System.out.println(ex.getMessage());
        }
    }

    @RequestMapping(value = "/getSoftwareJson", method = RequestMethod.GET, headers = "Accept=application/json; charset=utf-8")
    public
    @ResponseBody
    String getSoftwareJson() throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        File jsonFile = new File(classLoader.getResource("json/hardcoded-software.json").getFile());
        String json = FileUtils.readFileToString(jsonFile);

        return json;
    }

    @RequestMapping(value = "/getSoftwareXml", method = RequestMethod.GET, headers = "Accept=application/xml; charset=utf-8")
    public
    @ResponseBody
    String getSoftwareXml(@RequestParam(value = "index") int index) throws Exception {
        ClassLoader classLoader = getClass().getClassLoader();
        File jsonFile = new File(classLoader.getResource("json/hardcoded-software.json").getFile());
        String json = FileUtils.readFileToString(jsonFile);
        List<String> softwareXmlList = DigitalCommonsHelper.jsonToXml(json);
        String xml = softwareXmlList.get(index);

        return xml;
    }

    @RequestMapping(value = "/api/cache-library", method = RequestMethod.GET, headers = "Accept=application/json; charset=utf-8")
    public
    @ResponseBody
    String getCachedLibraryCollections(Model model, @RequestHeader("LibraryURL") String viewerUrl, @RequestHeader("LibraryToken") String viewerToken) {
        try {
            queryCollectionsJson(viewerUrl, viewerToken);
            return libraryCollectionsJson;
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @RequestMapping(value = "/midas-sso/view", method = RequestMethod.GET, headers = "Accept=text/html")
    public String loadIframe(Model model, @RequestParam(value = "url") String url) {
        model.addAttribute("url", url);
        return "iframeView";
    }

    @RequestMapping(value = "/main/api/cache-spew", method = RequestMethod.GET)
    public String cacheSpew(Model model) {
        try {
            Path path = Paths.get(SPEW_CACHE_FILE);
            FileOutputStream fos = new FileOutputStream(path.toFile());
            ObjectOutputStream oos = new ObjectOutputStream(fos);

            Iterable<SpewLocation> spewRegions = spewRule.treeRegions();

            oos.writeObject(spewRegions);

            model.addAttribute("status", "success");
        } catch (Exception e) {
            model.addAttribute("status", "fail");
        }

        return "cacheStatus";
    }

    @RequestMapping(value = "/main/about", method = RequestMethod.GET)
    public String about(Model model) {
        return "about";
    }

    @RequestMapping(value = "/preview", method = RequestMethod.GET)
    public String preview(Model model) throws Exception {
        populateCommonsMainModel(model);
        return "commons";
    }
}
