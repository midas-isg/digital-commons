package edu.pitt.isg.dc.controller;

import com.github.davidmoten.xsdforms.Generator;
import com.mangofactory.swagger.annotations.ApiIgnore;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.component.DCEmailService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.Properties;

import static java.nio.file.StandardOpenOption.APPEND;
import static java.nio.file.StandardOpenOption.CREATE;

/**
 * Created by TPS23 on 5/10/2017.
 */

@ApiIgnore
@Controller
public class DataEntryController {
    private static boolean GENERATE_XSD_FORMS = false;
    private static final String [] XSD_FILES = {
            "software.xsd",
            "dats.xsd"
    };
    private static final String XSD_FORMS_PATH;
    private static final String OUTPUT_DIRECTORY;
    private static final String DC_ENTRY_REQUESTS_LOG;

    static {
        String outputDirectory = "";
        String xsdFormsPath = "";
        String dcEntryRequestsLog = "";
        Properties dataEntryConfig = new Properties();

        try {
            dataEntryConfig.load(DCEmailService.class.getClassLoader()
                    .getResourceAsStream("config.properties"));
            outputDirectory = dataEntryConfig.getProperty("outputDirectory");
            xsdFormsPath = dataEntryConfig.getProperty("xsdFormsPath");
            dcEntryRequestsLog = dataEntryConfig.getProperty("dcEntryRequestsLog");
        }
        catch(Exception exception) {
            System.err.print(exception);
        }

        OUTPUT_DIRECTORY = outputDirectory;
        XSD_FORMS_PATH = xsdFormsPath;
        DC_ENTRY_REQUESTS_LOG = dcEntryRequestsLog;
    }

    @RequestMapping(value = "/add-entry" , method = RequestMethod.POST)
    public @ResponseBody String addNewEntry(@RequestBody String rawInputString) throws Exception {
        Date date = new Date();
        Converter xml2JSONConverter = new Converter();
        String xmlString = java.net.URLDecoder.decode(rawInputString, "UTF-8");
        String jsonString = null;

System.out.println(xmlString);
        try {
            jsonString = xml2JSONConverter.xmlToJson(xmlString);
System.out.println("~~~~~~~~~~~~");
System.out.println(jsonString);
        }
        catch(Exception exception) {
            exception.printStackTrace();
        }

        if(jsonString.length() > 0) {
            // Append {timestamp: timestamp, entry: jsonString} to OUTPUT_DIRECTORY + DC_ENTRY_REQUESTS_LOG
            String fileOutput = "{\n" +
                "    'timestamp': '" + date + "',\n" +
                "    'entry': " + jsonString + "\n}\n\n";
            byte data[] = fileOutput.getBytes();
            Path logPath = Paths.get(OUTPUT_DIRECTORY + DC_ENTRY_REQUESTS_LOG);

            try (OutputStream out = new BufferedOutputStream(
                    Files.newOutputStream(logPath, CREATE, APPEND))) {
                out.write(data, 0, data.length);
            }
            catch (IOException exception) {
                exception.printStackTrace();
            }

            //E-mail to someone it concerns
            DCEmailService emailService = new DCEmailService();
            emailService.mailToAdmin("[Digital Commons New Entry Request] " + date, jsonString);
        }

        return jsonString;
    }

    private static void generateForm(String xsdFile, String rootElementName, ApplicationContext appContext) throws IOException {
        InputStream schema;
        String idPrefix = "";
        String htmlString;
        scala.Option<String> rootElement;

        if(rootElementName != null) {
            rootElement = scala.Option.apply(rootElementName);

            schema = appContext.getResource(xsdFile).getInputStream();
            htmlString = Generator.generateHtmlAsString(schema, idPrefix, rootElement);
            schema.close();

            htmlString = htmlString.replace("<head>", "<head><base href='.'>" +
                    "<link rel='stylesheet' type='text/css' href='../css/main.css'>" +
                    "<link rel='stylesheet' href='../css/bootstrap/3.3.6/bootstrap.min.css'>" +
                    "<link rel='stylesheet' href='../css/bootstrap-treeview/1.2.0/bootstrap-treeview.min.css'>" +
                    "<link rel='stylesheet' href='../css/font-awesome-4.7.0/css/font-awesome.min.css'>");

            Path file = FileSystems.getDefault().getPath(OUTPUT_DIRECTORY + rootElementName + ".html");
            Charset charset = Charset.forName("US-ASCII");
            try (BufferedWriter writer = Files.newBufferedWriter(file, charset)) {
                writer.write(htmlString, 0, htmlString.length());
            } catch (IOException x) {
                System.err.format("IOException: %s%n", x);
            }
        }

        return;
    }

    public static String readXSDFiles() throws Exception {
        ApplicationContext appContext = new ClassPathXmlApplicationContext(new String[] {});
        InputStream schema;
        DocumentBuilderFactory dbFactory;
        DocumentBuilder dBuilder;
        Document document;
        String rootElementName;
        String typeList = "";

        for(int i = 0; i < XSD_FILES.length; i++) {
            typeList += (XSD_FILES[i] + ":");
            schema = appContext.getResource(XSD_FILES[i]).getInputStream();
            dbFactory = DocumentBuilderFactory.newInstance();
            dBuilder = dbFactory.newDocumentBuilder();
            document = dBuilder.parse(schema);
            schema.close();

            NodeList nodes = document.getElementsByTagName("schema").item(0).getChildNodes();
            int nodesLength = nodes.getLength();

            for(int j = 0; j < nodesLength; j++) {
                if(nodes.item(j).getNodeName().equals("element")){
                    rootElementName = nodes.item(j).getAttributes().getNamedItem("name").getNodeValue();
                    typeList += (rootElementName + ";");

                    if(GENERATE_XSD_FORMS){
                        generateForm(XSD_FILES[i], rootElementName, appContext);
                    }
                }
            }
            typeList += "-";
        }

        GENERATE_XSD_FORMS = false;

        return typeList;
    }
}
