package edu.pitt.isg.dc.digital.software;

import com.github.davidmoten.xsdforms.Generator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

@Service
public class SoftwareRule {
    private static final String DISEASE_TRANSMISSION_MODELS = "Disease transmission models";
    private static final String VIRAL_BACTERIAL_EVOLUTION_SIMULATORS = "Viral and bacterial evolution models";
    private static final String DATA_VISUALIZERS = "Data visualizers";
    private static final String INFERRING_OUTBREAK_TRANSMISSION_TREES = "Inferring outbreak transmission trees";
    private static final String DISEASE_SURVEILLANCE_ALGORITHMS_SYSTEMS = "Disease surveillance algorithms and systems";
    private static final String OTHER_SOFTWARE = "Other software";

    private static boolean GENERATE_XSD_FORMS = false;
    private static final String [] XSD_FILES = {
        "software.xsd",
        "dats.xsd"
        };
    private static final String XSD_FORM_RESOURCES = "/resources/xsd-forms/";
    private static final String OUTPUT_DIRECTORY = "C:\\Users\\tps23\\Desktop\\test\\";

    @Autowired
    private SoftwareRepository repository;
    private Iterable<SoftwareFolder> cachedSoftwareRule;

    public Iterable<SoftwareFolder> tree() {
        if(cachedSoftwareRule != null) {
            return cachedSoftwareRule;
        } else {
            LinkedHashMap<String, SoftwareFolder> root = new LinkedHashMap<>();
            Iterable<Software> all = repository.findAllByOrderByName();
            createSortedFolder(root);
            for (Software item : all) {
                final String type = item.getTypeText();
                final SoftwareFolder folder = toFolder(root, type);
                final List<Software> list = toList(folder);
                list.add(item);
            }

            cachedSoftwareRule = root.values();
            return root.values();
        }
    }

    private List<Software> toList(SoftwareFolder folder) {
        final List<Software> list = folder.getList();
        if (list != null)
            return list;

        return  addNewList(folder);
    }

    private List<Software> addNewList(SoftwareFolder folder) {
        List<Software> list = new ArrayList<>();
        folder.setList(list);
        return list;
    }

    private SoftwareFolder toFolder(Map<String, SoftwareFolder> root, String type) {
        final SoftwareFolder folder = root.get(type);
        if (folder != null)
            return folder;

        final SoftwareFolder newFolder = newFolder(type);
        root.put(type, newFolder);
        return newFolder;

    }

    private void createSortedFolder(Map<String, SoftwareFolder> root) {
        toFolder(root, DISEASE_TRANSMISSION_MODELS);
        toFolder(root, VIRAL_BACTERIAL_EVOLUTION_SIMULATORS);
        toFolder(root, DATA_VISUALIZERS);
        toFolder(root, INFERRING_OUTBREAK_TRANSMISSION_TREES);
        toFolder(root, DISEASE_SURVEILLANCE_ALGORITHMS_SYSTEMS);
        toFolder(root, OTHER_SOFTWARE);
    }

    private SoftwareFolder newFolder(String name) {
        final SoftwareFolder folder = new SoftwareFolder();
        folder.setName(name);
        return folder;
    }

    //TODO: relocate XSD form-related stuff to more appropriate class
    private void generateForm(String xsdFile, String rootElementName, ApplicationContext appContext) throws IOException {
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

    public String generateXSDForms() throws Exception {
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
