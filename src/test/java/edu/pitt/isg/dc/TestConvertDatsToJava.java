package edu.pitt.isg.dc;

import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.DatasetWithOrganization;
import edu.pitt.isg.mdc.v1_0.*;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.lang.reflect.Type;
import java.util.*;

import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class TestConvertDatsToJava {

    private static Map<EntryId, String> idsNeedOlympus = new HashMap<EntryId, String>();

    @Autowired
    private EntryRepository repo;

    Converter converter = new Converter();

    Gson gson = new Gson();


    @AfterClass
    public static void last() {
        Iterator<EntryId> it = idsNeedOlympus.keySet().iterator();
        while (it.hasNext()) {
            EntryId entryId = it.next();

        System.out.println("UPDATE entry SET content = '"+idsNeedOlympus.get(entryId)+"' where entry_id = "+entryId.getEntryId() + " and revision_id = " + entryId.getRevisionId());
        }
    }

    private void test(Class clazz) {
        Set<String> types = new HashSet<>();
        types.add(clazz.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypes(types);
        for (Entry entry : entriesList) {
            String jsonFromDatabase = gson.toJson(entry.getContent().get("entry"));
            Object object = converter.convertFromJsonToClass(jsonFromDatabase, clazz);

            JsonObject jsonObjectFromDatabase = new JsonParser().parse(jsonFromDatabase).getAsJsonObject();
            JsonObject jsonObjectFromClass = converter.toJsonObject(clazz, object);
            jsonObjectFromClass.remove("class");
            jsonObjectFromClass.remove("subtype");

            Type mapType = new TypeToken<Map<String, Object>>() {
            }.getType();
            Map<String, Object> databaseMap = gson.fromJson(jsonFromDatabase, mapType);
            Map<String, Object> convertedObjectMap = gson.fromJson(jsonObjectFromClass, mapType);
            MapDifference<String, Object> d = Maps.difference(databaseMap, convertedObjectMap);
            if (!d.toString().equalsIgnoreCase("equal")) {
                System.out.print("Entry " + jsonObjectFromClass.get("title") + " (" + entry.getId().getEntryId() + ") needs \n");

                Iterator<String> it = d.entriesOnlyOnRight().keySet().iterator();
                while (it.hasNext()) {
                    String field = it.next();
                    if (field.contains("Olympus")) {
                        jsonObjectFromDatabase.addProperty("availableOnOlympus", "false");
                        idsNeedOlympus.put(entry.getId(), gson.toJson(jsonObjectFromDatabase));
                    }
                    jsonObjectFromDatabase.addProperty("availableOnOlympus", "false");
                    System.out.println("\t" + field + ": ");

                }
                System.out.println();
            }
            //assertEquals(d.toString(), "equal");

        }
    }




    @Test
    public void testDataStandard() {
        test(DataStandard.class);
    }

    @Test
    public void testDataFormatConverters() {
        test(DataFormatConverters.class);
    }

    @Test
    public void testDataService() {
        test(DataService.class);
    }

    @Test
    public void testDataVisualizers() {
        test(DataVisualizers.class);
    }

   /* @Test
    public void testDataset() {
        test(Dataset.class);
    }*/

    @Test
    public void testDatasetWithOrganization() {
        test(DatasetWithOrganization.class);
    }

    @Test
    public void testDiseaseForecasters() {
        test(DiseaseForecasters.class);
    }

    @Test
    public void testDiseaseTransmissionModel() {
        test(DiseaseTransmissionModel.class);
    }

    @Test
    public void testDiseaseTransmissionTreeEstimators() {
        test(DiseaseTransmissionTreeEstimators.class);
    }

    @Test
    public void testMetagenomicAnalysis() {
        test(MetagenomicAnalysis.class);
    }

    @Test
    public void testModelingPlatforms() {
        test(ModelingPlatforms.class);
    }

    @Test
    public void testPathogenEvolutionModels() {
        test(PathogenEvolutionModels.class);
    }

    @Test
    public void testPhylogeneticTreeConstructors() {
        test(PhylogeneticTreeConstructors.class);
    }

    @Test
    public void testPopulationDynamicsModel() {
        test(PopulationDynamicsModel.class);
    }

    @Test
    public void testSyntheticEcosystemConstructors() {
        test(SyntheticEcosystemConstructors.class);
    }
}
