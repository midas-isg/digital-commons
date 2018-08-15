package edu.pitt.isg.dc.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.WorkflowsImpl;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.repository.utils.ApiUtil;
import edu.pitt.isg.dc.spew.SpewLocation;
import edu.pitt.isg.dc.spew.SpewRule;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import edu.pitt.isg.dc.vm.QueryTree;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.WordUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static edu.pitt.isg.dc.controller.Auth0Controller.ISG_ADMIN_TOKEN;
import static edu.pitt.isg.dc.controller.Auth0Controller.MDC_EDITOR_TOKEN;
import static edu.pitt.isg.dc.entry.util.TreeAid.toForest;
import static java.util.Comparator.comparing;

@ApiIgnore
@Controller
public class HomeController {
    private static String VIEWER_URL = "";
    private static String VIEWER_TOKEN = "";
    private static String SPEW_CACHE_FILE = "";
    private static String LIBRARY_COLLECTIONS_CACHE_FILE = "";
    private static String TREE_INFO_CACHE_FILE = "";
    private String libraryCollectionsJson = "";
    public static final String LOGGED_IN_PROPERTY = "loggedIn";
    public static final String ADMIN_TYPE = "adminType";
    private static List<Map<String,String>> treeInfoArr;
    static {
        Properties configurationProperties = DigitalCommonsProperties.getProperties();
        VIEWER_URL = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_VIEWER_URL);
        VIEWER_TOKEN = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_VIEWER_TOKEN);
        SPEW_CACHE_FILE = configurationProperties.getProperty(DigitalCommonsProperties.SPEW_CACHE_FILE_LOCATION);
        LIBRARY_COLLECTIONS_CACHE_FILE = configurationProperties.getProperty(DigitalCommonsProperties.LIBRARY_COLLECTIONS_CACHE_FILE_LOCATION);
        TREE_INFO_CACHE_FILE = configurationProperties.getProperty(DigitalCommonsProperties.TREE_INFO_CACHE_FILE_LOCATION);
    }
    @Autowired
    private EntryRule entryRule;
    @Autowired
    private SpewRule spewRule;
    @Autowired
    private NcbiRule ncbiRule;
    @Autowired
    private TypeRule typeRule;
    @Autowired
    private AsvRule asvRule;
    @Autowired
    private LocationRule locationRule;
    @Autowired
    private ApiUtil apiUtil;
    @Autowired
    private CategoryHelper categoryHelper;

    @Autowired
    private WorkflowsImpl workflows;

    private Integer spewCount;
    private Integer spewAmericaCount;

    public static Boolean ifLoggedIn(HttpSession session) {
        if(session.getAttribute(LOGGED_IN_PROPERTY) != null && session.getAttribute(LOGGED_IN_PROPERTY).equals(true)) {
            return true;
        }
        return false;
    }

    public static Boolean ifMDCEditor(HttpSession session) {
        if(session.getAttribute(ADMIN_TYPE) != null && session.getAttribute(ADMIN_TYPE).equals(MDC_EDITOR_TOKEN)) {
            return true;
        }
        return false;
    }

    public static Boolean ifISGAdmin(HttpSession session) {
        if(session.getAttribute(ADMIN_TYPE) != null && session.getAttribute(ADMIN_TYPE).equals(ISG_ADMIN_TOKEN)) {
            return true;
        }
        return false;
    }

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
//        try {
//            model.addAttribute("spewRegions", spewRule.treeRegions());
//            spewCount=0;
//            spewAmericaCount = 0;
//            for(SpewLocation location : spewRule.treeRegions()) {
//                if (location.getName().toLowerCase().contains("america")) {
//                    recureAmericaTree(location, false);
//                }
//                recurseSpewTree(location, false);
//            }
//            //we do not show burkina faso
//            spewCount--;
//            model.addAttribute("spewRegionCount", spewCount);
//            model.addAttribute("spewAmericaCount", spewAmericaCount);
//
//        } catch (Exception e) {
//            try {
//                Path path = Paths.get(SPEW_CACHE_FILE);
//
//                FileInputStream fis = new FileInputStream(path.toFile());
//                ObjectInputStream ois = new ObjectInputStream(fis);
//                Iterable<SpewLocation> spewLocationIterable = (Iterable<SpewLocation>) ois.readObject();
//
//                model.addAttribute("spewRegions", spewLocationIterable);
//            } catch (Exception ee) {
//                SpewLocation emptySpew = new SpewLocation();
//                emptySpew.setName("Error loading data from SPEW");
//                List<SpewLocation> tree = new ArrayList<>();
//                tree.add(emptySpew);
//                model.addAttribute("spewRegions", tree);
//            }
//        }

        List<Object[]> spewLocationsAndAccessUrls = workflows.getSpewLocationsAndAccessUrls();

        Pattern pattern = Pattern.compile(".*(\\d{2}).tar.gz");
        List<String[]> workflowLocationsAndIds = new ArrayList<>();
        for(Object[] spewLocationAndAccessUrl : spewLocationsAndAccessUrls) {
            Matcher matcher = pattern.matcher(spewLocationAndAccessUrl[1].toString());
            if(matcher.matches()) {
                String location = spewLocationAndAccessUrl[0].toString();
                String id = matcher.group(1);
                String[] locationAndId = {location, id};
                workflowLocationsAndIds.add(locationAndId);
            }
        }

        if(treeInfoArr == null) {
            treeInfoArr = categoryHelper.getEntryTrees();
            writeFile(treeInfoArr, TREE_INFO_CACHE_FILE);
        }

        model.addAttribute("workflowLocationsAndIds", workflowLocationsAndIds);
        model.addAttribute("treeInfoArr", treeInfoArr);
        model.addAttribute("libraryViewerUrl", VIEWER_URL);
        model.addAttribute("libraryViewerToken", VIEWER_TOKEN);
        model.addAttribute("preview", true);
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String redirectHome() {
        return "redirect:/main";
    }

    @RequestMapping(value = "/search", method = RequestMethod.GET)
    public String search(Model model, HttpSession session) throws Exception {
        final List<QueryTree<Ncbi>> hosts = toForest(ncbiRule.findHostsInEntries());
        final List<QueryTree<Ncbi>> pathogens = toForest(ncbiRule.findPathogensInEntries());
        final List<QueryTree<Asv>> controlMeasures = toForest(asvRule.findControlMeasuresInEntries());;
        final List<QueryTree<Location>> locations = toForest(locationRule.findLocationsInEntries());
        final List<String[]> types = typeRule.findAll().stream()
                .map(this::formatType)
                .sorted(comparing(s -> s[1]))
                .collect(Collectors.toList());
        final Gson gson = new Gson();
        model.addAttribute("hosts", gson.toJson(hosts));
        model.addAttribute("pathogens", gson.toJson(pathogens));
        model.addAttribute("types", types);
        model.addAttribute("controlMeasures", gson.toJson(controlMeasures));
        model.addAttribute("locations", gson.toJson(locations));

        if(ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if(ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if(ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);
        return "search";
    }

    private String[] formatType(String fullyQualifiedName) {
        final String[] tokens = fullyQualifiedName.split("\\.");
        final String token = tokens[tokens.length - 1];
        final String name = token.replaceAll("([A-Z])", " $1").trim();
        return new String[]{fullyQualifiedName, name};
    }

    @RequestMapping(value = "/main", method = RequestMethod.GET)
    public String hello(Model model, HttpSession session) throws Exception {
        populateCommonsMainModel(model);

        if(ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if(ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if(ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);
        return "commons";
    }

//    @RequestMapping(value = "/add", method = RequestMethod.GET)
//    public String addEntry(Model model) throws Exception {
//        model.addAttribute("xsdForms", DataEntryController.readXSDFiles());
//        return "addEntry";
//    }

    @RequestMapping(value = "/add/{category}", method = RequestMethod.GET)
    public String addNewDataFormatConverters(HttpSession session, @PathVariable(value = "category") String category, @RequestParam(value = "datasetType", required = false) String datasetType,
                                             @RequestParam(value = "customValue", required = false) String customValue, Model model) throws Exception {
        model.addAttribute("categoryPaths", categoryHelper.getTreePaths());
        model.addAttribute("category", category);
        if(ifLoggedIn(session))
            model.addAttribute("loggedIn", true);

        if(ifMDCEditor(session))
            model.addAttribute("adminType", MDC_EDITOR_TOKEN);

        if(ifISGAdmin(session))
            model.addAttribute("adminType", ISG_ADMIN_TOKEN);

        if(!model.containsAttribute("adminType")) {
            return "accessDenied";
        }
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
        writeFile(libraryCollectionsJson, LIBRARY_COLLECTIONS_CACHE_FILE);
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

//    @RequestMapping(value = "/midas-sso/view", method = RequestMethod.GET, headers = "Accept=text/html")
//    public String loadIframe(Model model, @RequestParam(value = "url") String url) {
//        model.addAttribute("url", url);
//        return "iframeView";
//    }

    @RequestMapping(value = "/api/cache-spew", method = RequestMethod.GET)
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

    @RequestMapping(value = "/getTreeInformation", method = RequestMethod.GET, headers = "Accept=application/json; charset=utf-8")
    public
    @ResponseBody
    List<Map<String,String>> getTreeInformation() throws Exception {

        if(!treeInfoArr.isEmpty() && treeInfoArr != null) {
            return treeInfoArr;
        } else {
            try {
                Path path = Paths.get(TREE_INFO_CACHE_FILE);
                FileInputStream fis = new FileInputStream(path.toFile());
                ObjectInputStream ois = new ObjectInputStream(fis);
                treeInfoArr = (List<Map<String,String>>) ois.readObject();
                return treeInfoArr;
            } catch (Exception e) {
                treeInfoArr = categoryHelper.getEntryTrees();
                writeFile(treeInfoArr, TREE_INFO_CACHE_FILE);
                return treeInfoArr;
            }
        }
    }

    private void writeFile(Object fileToWrite, String fileString) {
        try {
            Path path = Paths.get(fileString);
            FileOutputStream fos = new FileOutputStream(path.toFile());
            ObjectOutputStream oos = new ObjectOutputStream(fos);

            oos.writeObject(fileToWrite);
        }catch (FileNotFoundException e) {
            System.out.println(e.getMessage());
        }catch (IOException ex) {
            System.out.println(ex.getMessage());
        }
    }

    @RequestMapping(value = "api/cache-tree-info", method = RequestMethod.GET)
    public String cacheTreeInfo(Model model) {
        try {
            treeInfoArr = categoryHelper.getEntryTrees();
            Path path = Paths.get(TREE_INFO_CACHE_FILE);
            FileOutputStream fos = new FileOutputStream(path.toFile());
            ObjectOutputStream oos = new ObjectOutputStream(fos);

            oos.writeObject(treeInfoArr);

            model.addAttribute("status", "success");
        } catch (Exception e) {
            model.addAttribute("status", "fail");
        }

        return "cacheStatus";
    }


    @RequestMapping(value = "api/cache-tree-info-json", method = RequestMethod.GET)
    public @ResponseBody Map<String, String> cacheTreeInfoJSON() {

        Map<String,String> resultMap = new HashMap<>();
        try {
            treeInfoArr = categoryHelper.getEntryTrees();
            Path path = Paths.get(TREE_INFO_CACHE_FILE);
            FileOutputStream fos = new FileOutputStream(path.toFile());
            ObjectOutputStream oos = new ObjectOutputStream(fos);

            oos.writeObject(treeInfoArr);

            resultMap.put("result","success");

        } catch (Exception e) {
            resultMap.put("result","fail");
        }

        return resultMap;
    }

    @RequestMapping(value = "/main/about", method = RequestMethod.GET)
    public String about(Model model) {
        return "about";
    }


    @RequestMapping(value = "/detailed-view", method = RequestMethod.GET)
    public String detailedView(Model model, HttpSession session,@RequestParam(value = "id") long id) throws Exception {
        //public String detailedView(Model model, HttpSession session,@RequestParam(value = "id") long id, @RequestParam(value = "revId") long revId) throws Exception {
        model.addAttribute("id", id);
        //model.addAttribute("revId", revId);
        //Entry entry = entryRule.read(new EntryId(id, revId));
        Entry entry = apiUtil.getEntryById(id);
        EntryId entryId = entry.getId();
        model.addAttribute("revId", entryId.getRevisionId());
        EntryView entryView = new EntryView(entry);
        String jsonString = entryView.getUnescapedEntryJsonString();
        String type = entryView.getEntryTypeBaseName();
        model.addAttribute("entryView", entryView);

        List<String> lineage = new ArrayList<>();

        try {
            List<Category> categories = apiUtil.getCategoryLineage((String) ((LinkedHashMap) ((LinkedHashMap) entry.getContent().get("entry")).get("identifier")).get("identifier"));
            for (int i = categories.size() - 1; i >= 0; i--)
                lineage.add(categories.get(i).getCategory());
        } catch (NullPointerException e) {
            lineage.add("Root");
            lineage.add("Software");
            lineage.add(entry.getCategory().getCategory());
        }
        model.addAttribute("lineage", lineage);
        model.addAttribute("entryJson", jsonString);
        model.addAttribute("type", type);

        try {
            String description = (String) ((LinkedHashMap) entry.getContent().get("entry")).get("description");
            description = description.replaceAll("[�ʉ]", "").replaceAll(" (\\*+)", "<br>$1").replace("\n", "<br>").replaceAll("(Footnotes?:)", "<br>$1");
            model.addAttribute("description", description);
        } catch (NullPointerException e){}
        return "detailedView";
    }

    @RequestMapping(value = "/detailed-metadata-view", method = RequestMethod.GET)
    public HttpEntity<byte[]> detailedMetaDataView(@RequestParam(value = "id") long id) throws Exception {
        //public HttpEntity<byte[]> detailedMetaDataView(@RequestParam(value = "id") long id, @RequestParam(value = "revId") long revId) throws Exception {
        //Entry entry = entryRule.read(new EntryId(id, revId));
        Entry entry = apiUtil.getEntryById(id);
        EntryView entryView = new EntryView(entry);
        String documentText;

        HttpHeaders header = new HttpHeaders();
        if(entryView.getXmlString() != null) {
            documentText = entryView.getXmlString();
            header.setContentType(new org.springframework.http.MediaType("application", "xml"));

        } else {
            Gson gson = new GsonBuilder().setPrettyPrinting().create();
            documentText = gson.toJson(entry.getContent().get("entry"));
            header.setContentType(new org.springframework.http.MediaType("application", "json"));
        }
        byte[] documentBody = documentText.getBytes();
        header.setContentLength(documentBody.length);

        return new HttpEntity<byte[]>(documentBody, header);

    }
}
