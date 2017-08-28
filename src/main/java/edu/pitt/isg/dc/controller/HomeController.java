package edu.pitt.isg.dc.controller;

import com.google.gson.*;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.CategoryOrder;
import edu.pitt.isg.dc.entry.CategoryOrderRepository;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.impl.EntryApproval;
import edu.pitt.isg.dc.entry.impl.WorkflowsImpl;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.entry.Ncbi;
import edu.pitt.isg.dc.entry.NcbiRule;
import edu.pitt.isg.dc.entry.TypeRule;
import edu.pitt.isg.dc.spew.SpewLocation;
import edu.pitt.isg.dc.spew.SpewRule;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static java.util.Comparator.comparing;
import java.util.*;

import static edu.pitt.isg.dc.controller.Auth0Controller.ISG_ADMIN_TOKEN;
import static edu.pitt.isg.dc.controller.Auth0Controller.MDC_EDITOR_TOKEN;

@ApiIgnore
@Controller
public class HomeController {
    private static String VIEWER_URL = "";
    private static String VIEWER_TOKEN = "";
    private static String SPEW_CACHE_FILE = "";
    private static String LIBRARY_COLLECTIONS_CACHE_FILE = "";
    private String libraryCollectionsJson = "";
    public static final String LOGGED_IN_PROPERTY = "loggedIn";
    public static final String ADMIN_TYPE = "adminType";

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
    private NcbiRule ncbiRule;
    @Autowired
    private TypeRule typeRule;

    @Autowired
    private EntryApprovalInterface entryApprovalInterface;

    @Autowired
    private CategoryOrderRepository categoryOrderRepository;

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

        CategoryHelper categoryHelper = new CategoryHelper(categoryOrderRepository, entryApprovalInterface);
        List<Map<String,String>> treeInfoArr = categoryHelper.getEntryTrees();

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
    public String ncbis(Model model) throws Exception {
        final List<Ncbi> hosts = sort(ncbiRule.findHostsInEntries());
        final List<Ncbi> pathogens = sort(ncbiRule.findPathogensInEntries());
        final List<String[]> types = typeRule.findAll().stream()
                .map(this::formatType)
                .sorted(comparing(s -> s[1]))
                .collect(Collectors.toList());
        model.addAttribute("hosts", hosts);
        model.addAttribute("pathogens", pathogens);
        model.addAttribute("types", types);
        return "search";
    }

    private List<Ncbi> sort(List<Ncbi> list) {
        return list.stream()
                .sorted(comparing(Ncbi::getName, String::compareToIgnoreCase))
                .collect(Collectors.toList());
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
        CategoryHelper categoryHelper = new CategoryHelper(categoryOrderRepository, entryApprovalInterface);

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
}
