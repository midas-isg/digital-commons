package edu.pitt.isg.dc.controller;

import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.dc.digital.spew.SpewLocation;
import edu.pitt.isg.dc.digital.spew.SpewRule;
import edu.pitt.isg.dc.utils.DigitalCommonsHelper;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.apache.commons.io.FileUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.*;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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

    public void populateCommonsMainModel(Model model) {
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
        model.addAttribute("libraryViewerUrl", VIEWER_URL);
        model.addAttribute("libraryViewerToken", VIEWER_TOKEN);
        model.addAttribute("preview", true);
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

    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String addEntry(Model model) throws Exception {
        model.addAttribute("xsdForms", DataEntryController.readXSDFiles());

        return "addEntry";
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
