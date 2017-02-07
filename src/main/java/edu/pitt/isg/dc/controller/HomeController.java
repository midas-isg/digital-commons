package edu.pitt.isg.dc.controller;

import edu.pitt.isg.dc.digital.dap.DapFolder;
import edu.pitt.isg.dc.digital.dap.DapRule;
import edu.pitt.isg.dc.digital.dap.DataAugmentedPublication;
import edu.pitt.isg.dc.digital.software.Software;
import edu.pitt.isg.dc.digital.software.SoftwareFolder;
import edu.pitt.isg.dc.digital.software.SoftwareRule;
import edu.pitt.isg.dc.digital.spew.SpewLocation;
import edu.pitt.isg.dc.digital.spew.SpewRule;
import org.springframework.beans.factory.annotation.Autowired;
import edu.pitt.isg.dc.utils.DigitalCommonsProperties;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

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
    private DapRule dapRule;
    @Autowired
    private SoftwareRule softwareRule;
    @Autowired
    private SpewRule spewRule;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String redirectHome() {
        return "redirect:/main";
    }

    @RequestMapping(value = "/main", method = RequestMethod.GET)
    public String hello(Model model) {
        model.addAttribute("dataAugmentedPublications", dapRule.tree());
        model.addAttribute("software", softwareRule.tree());
        try {
            model.addAttribute("spewRegions", spewRule.treeRegions());
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
        return "commons";
    }


    @RequestMapping(value = "/getCollectionsJson", method = RequestMethod.GET, headers = "Accept=application/json; charset=utf-8")
    public
    @ResponseBody
    String getCollectionsJson() throws Exception {

        if(!libraryCollectionsJson.equals("")) {

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
        URL url = new URL(libraryUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();

        con.setRequestMethod("GET");
        con.setRequestProperty("Authorization", viewerToken);
        con.setRequestProperty("Accept-Charset", "UTF-8");
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        libraryCollectionsJson = response.toString();
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

    @RequestMapping(value = "/main/view", method = RequestMethod.GET, headers = "Accept=text/html")
    public String loadIframe(Model model, @RequestParam(value = "url") String url) {
        model.addAttribute("url", url);
        return "iframeView";
    }

    @RequestMapping(value = "/main/software/{id}", method = RequestMethod.GET)
    public String softwareInfo(Model model, @PathVariable("id") long id) {
        Iterable<SoftwareFolder> tree = softwareRule.tree();

        Software softwareToReturn = new Software();
        for(SoftwareFolder folder : tree) {
            for(Software software : folder.getList()) {
                if(software.getId() == id) {
                    softwareToReturn = software;
                    break;
                }
            }
        }

        model.addAttribute("software", softwareToReturn);    // placeholder for iterable to be returned from DB
        return "softwareInfo";
    }

    @RequestMapping(value = "/main/publication/{paperId}/{dataId}", method = RequestMethod.GET)
    public String publicationInfo(Model model, @PathVariable("paperId") long paperId, @PathVariable("dataId") long dataId) {
        Iterable<DapFolder> tree = dapRule.tree();

        DataAugmentedPublication dataAugmentedPublicationPaper = new DataAugmentedPublication();
        DataAugmentedPublication dataAugmentedPublicationData = new DataAugmentedPublication();

        for(DapFolder folder : tree) {
            DataAugmentedPublication publicationPaper = folder.getPaper();
            DataAugmentedPublication publicationData = folder.getData();
            if(publicationPaper.getId() == paperId && publicationData.getId() == dataId) {
                dataAugmentedPublicationPaper = publicationPaper;
                dataAugmentedPublicationData = publicationData;
                break;
            }
        }

        model.addAttribute("publicationPaper", dataAugmentedPublicationPaper);
        model.addAttribute("publicationData", dataAugmentedPublicationData);
        return "publicationInfo";
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
    public String preview(Model model) {
        model.addAttribute("dataAugmentedPublications", dapRule.tree());
        model.addAttribute("software", softwareRule.tree());
        try {
            model.addAttribute("spewRegions", spewRule.treeRegions());
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
        return "commons";
    }
}
