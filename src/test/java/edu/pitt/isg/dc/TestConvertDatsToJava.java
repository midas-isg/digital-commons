package edu.pitt.isg.dc;

import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.google.common.reflect.TypeToken;
import com.google.gson.*;
import com.google.gson.stream.MalformedJsonException;
import edu.pitt.isg.Converter;
import edu.pitt.isg.dc.entry.Entry;
import edu.pitt.isg.dc.entry.EntryId;
import edu.pitt.isg.dc.entry.EntryRepository;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.DatasetWithOrganization;
import edu.pitt.isg.mdc.v1_0.*;
import org.apache.commons.lang.ArrayUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.lang.reflect.Type;
import java.util.*;
import java.util.stream.IntStream;

import static org.apache.commons.lang.ArrayUtils.INDEX_NOT_FOUND;
import static org.junit.Assert.assertEquals;

enum CharacterIndexBehavior {
    GET_CHARACTER_INDEX_FROM_INDEX_COUNTING_WHITESPACE,
    SEEK_TO_CHARACTER_INDEX

}

@RunWith(SpringRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes = {WebApplication.class})
@TestPropertySource("/application.properties")
public class TestConvertDatsToJava {

    public static final String ANSI_CYAN = "\u001B[36m";
    public static final String ANSI_RESET = "\u001B[0m";
    public static final Type mapType = new TypeToken<TreeMap<String, Object>>() {
    }.getType();
    private static Map<EntryId, String> idsNeedOlympus = new HashMap<EntryId, String>();
    Converter converter = new Converter();
    Gson gson = new GsonBuilder().serializeNulls().enableComplexMapKeySerialization().create();
    @Autowired
    private EntryRepository repo;

    public static int indexOfDifference(CharSequence cs1, CharSequence cs2) {
        if (cs1 == cs2) {
            return INDEX_NOT_FOUND;
        }
        if (cs1 == null || cs2 == null) {
            return 0;
        }
        int i;
        for (i = 0; i < cs1.length() && i < cs2.length(); ++i) {
            if (cs1.charAt(i) != cs2.charAt(i)) {
                break;
            }
        }
        if (i < cs2.length() || i < cs1.length()) {
            return i;
        }
        return INDEX_NOT_FOUND;
    }

    private String sortJsonObject(JsonObject jsonObject) {
        List<String> jsonElements = new ArrayList<>();

        Set<Map.Entry<String, JsonElement>> entries = jsonObject.entrySet();
        for (Map.Entry<String, JsonElement> entry : entries)
            jsonElements.add(entry.getKey());

        Collections.sort(jsonElements);

        JsonArray jsonArray = new JsonArray();
        for (String elementName : jsonElements) {
            JsonObject newJsonObject = new JsonObject();
            JsonElement jsonElement = jsonObject.get(elementName);
            if (jsonElement.isJsonObject())
                newJsonObject.add(elementName, new JsonPrimitive(sortJsonObject(jsonObject.get(elementName).getAsJsonObject())));
            else if (jsonElement.isJsonArray()) {
                newJsonObject.add(elementName, sortJsonArray(jsonElement));
            } else
                newJsonObject.add(elementName, jsonElement);
            jsonArray.add(newJsonObject);
        }

        return jsonArray.toString();
    }

    private JsonArray sortJsonArray(JsonElement jsonElement) {
        JsonArray sortedArray = new JsonArray();

        JsonArray jsonElementAsArray = jsonElement.getAsJsonArray();
        for (JsonElement arrayMember : jsonElementAsArray)
            if (arrayMember.isJsonObject()) {
                sortedArray.add(new JsonPrimitive(sortJsonObject(arrayMember.getAsJsonObject())));
            } else if (arrayMember.isJsonArray()) {
                sortedArray.add(sortJsonArray(arrayMember));
            } else {
                sortedArray.add(arrayMember.toString());
            }
        return sortedArray;
    }

    private int getOrFindCharactersGivenIndex(String string, int index, CharacterIndexBehavior characterIndexBehavior) {
        IntStream stream = string.chars();
        PrimitiveIterator.OfInt it = stream.iterator();
        int nonWhitespaceCharacterCount = 0;
        int characterCount = 0;
        while (it.hasNext()) {
            Integer cur = it.next();
            if (!Character.isWhitespace(cur)) nonWhitespaceCharacterCount++;
            characterCount++;

            if (characterIndexBehavior.equals(CharacterIndexBehavior.GET_CHARACTER_INDEX_FROM_INDEX_COUNTING_WHITESPACE) && characterCount == index)
                return nonWhitespaceCharacterCount;
            else if (characterIndexBehavior.equals(CharacterIndexBehavior.SEEK_TO_CHARACTER_INDEX) && nonWhitespaceCharacterCount == index)
                return characterCount;
        }
        return -1;

    }

    private void printHelpfulJsonError(String json, JsonSyntaxException syntaxException, MalformedJsonException malformedException) {
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String prettyJson = gson.toJson(new JsonParser().parse(json));

        Exception e = syntaxException != null ? syntaxException : malformedException;
        String errStr = e.getMessage();
        Integer begin = errStr.indexOf("1 column ") + 9;
        Integer end = errStr.indexOf(" path $");
        Integer errorPos = Integer.valueOf(errStr.substring(begin, end));

        int characterIndexOfError = getOrFindCharactersGivenIndex(json, errorPos, CharacterIndexBehavior.GET_CHARACTER_INDEX_FROM_INDEX_COUNTING_WHITESPACE);
        int indexOfErrorInPretty = getOrFindCharactersGivenIndex(prettyJson, characterIndexOfError, CharacterIndexBehavior.SEEK_TO_CHARACTER_INDEX);

        System.out.println(prettyJson.substring(1, indexOfErrorInPretty) + ANSI_CYAN + "(!!!-- " + e.getMessage() + "--!!!)\n" + prettyJson.substring(indexOfErrorInPretty, prettyJson.length()) + ANSI_RESET);
    }

    private void test(Class clazz) {
        Set<String> types = new HashSet<>();
        types.add(clazz.getTypeName());
        List<Entry> entriesList = repo.filterEntryIdsByTypes(types);
        if (clazz == DatasetWithOrganization.class) {
            clazz = Dataset.class;
        }
        for (Entry entry : entriesList) {
            //if (entry.getId().getEntryId() != 315L) {
            //    continue;
            //}
            int[] knownBad = {};//81, 63, 62, 82, 37, 73};
            if (ArrayUtils.contains(knownBad, entry.getId().getEntryId().intValue()))
                continue;

            String jsonFromDatabase = gson.toJson(entry.getContent().get("entry"));
            Object object;

            jsonFromDatabase = jsonFromDatabase.replaceAll("\"coordinates\":\\[ *\\[ *[ ,0-9\\-\\.]* *\\] *\\],", "");
            jsonFromDatabase = jsonFromDatabase.replaceAll("\"size\":0", "\"size\":0.0");

            JsonObject jsonObjectFromDatabase = null;
            try {
                jsonObjectFromDatabase = new JsonParser().parse(jsonFromDatabase).getAsJsonObject();
            } catch (JsonSyntaxException e) {
                printHelpfulJsonError(jsonFromDatabase, e, null);
            }

            jsonFromDatabase = jsonObjectFromDatabase.toString();

            try {
                //here!!!
                object = converter.fromJson(jsonFromDatabase, clazz);
                //object = gson.fromJson(jsonFromDatabase, clazz);
            } catch (JsonSyntaxException e) {
                printHelpfulJsonError(jsonFromDatabase, e, null);
                throw e;
            }


            /*//ignore empties
            jsonFromDatabase = jsonFromDatabase.replaceAll("\"[A-Za-z]+\":\\[\\],*", "");
            jsonFromDatabase = jsonFromDatabase.replaceAll(", *]", "]");
            jsonFromDatabase = jsonFromDatabase.replaceAll(", *\\}", "}");*/

            JsonObject jsonObjectFromClass = converter.toJsonObject(clazz, object);

            jsonObjectFromClass.remove("class");
            if (!jsonObjectFromDatabase.has("subtype"))
                jsonObjectFromClass.remove("subtype");


            Map<String, Object> databaseMap = gson.fromJson(jsonFromDatabase, mapType);
            Map<String, Object> convertedObjectMap = gson.fromJson(jsonObjectFromClass, mapType);
            MapDifference<String, Object> d = Maps.difference(databaseMap, convertedObjectMap);
            if (!d.toString().equalsIgnoreCase("equal")) {
                if (d.entriesOnlyOnLeft().size() > 0) {
                    System.out.print("Entry " + jsonObjectFromClass.get("title") + " (" + entry.getId().getEntryId() + "), database JSON contains");
                    Iterator<String> it = d.entriesOnlyOnLeft().keySet().iterator();
                    while (it.hasNext()) {

                        String field = it.next();
                        System.out.print(" " + field + ",");

                    }
                    System.out.print(" but unmarshalled object does not.\n");
                }

                if (d.entriesOnlyOnRight().size() > 0) {
                    System.out.print("Entry " + jsonObjectFromClass.get("title") + " (" + entry.getId().getEntryId() + "), unmarshalled object contains");
                    Iterator<String> it = d.entriesOnlyOnRight().keySet().iterator();
                    while (it.hasNext()) {
                        String field = it.next();
                        System.out.print(" " + field + ",");

                    }
                    System.out.print(" but database JSON does not.\n");
                }

                if (d.entriesDiffering().size() > 0) {
                    Iterator<String> it = d.entriesDiffering().keySet().iterator();
                    while (it.hasNext()) {
                        String value = it.next();

                        String left;
                        if (jsonObjectFromDatabase.get(value).isJsonArray()) {
                            left = sortJsonObject(jsonObjectFromDatabase.get(value).getAsJsonArray().get(0).getAsJsonObject());
                        } else {
                            left = sortJsonObject(jsonObjectFromDatabase.get(value).getAsJsonObject());
                        }

                        String right;
                        if (jsonObjectFromClass.get(value).isJsonArray()) {
                            right = sortJsonObject(jsonObjectFromClass.get(value).getAsJsonArray().get(0).getAsJsonObject());
                        } else {
                            right = sortJsonObject(jsonObjectFromClass.get(value).getAsJsonObject());
                        }

                        if (!left.equals(right)) {
                            int idxOfDifference = indexOfDifference(left, right);


                            try {
                                System.out.println("In " + value + " section from Database: ...\n" + left.substring(0, idxOfDifference) + ANSI_CYAN + left.substring(idxOfDifference, left.length()) + ANSI_RESET);
                                System.out.println("In " + value + " section in Java: ...\n" + right.substring(0, idxOfDifference) + ANSI_CYAN + right.substring(idxOfDifference, right.length()) + ANSI_RESET);
                            } catch (StringIndexOutOfBoundsException e) {
                                System.out.println("idxOfDifference:" + idxOfDifference);
                                // System.out.println("end:" + end);

                                throw e;
                            }
                        } else {
                            System.out.println(d);
                        }

                    }

                }
            }
            if (!d.toString().equals("equal"))
                System.out.println("\t Error message: " + d + "\n\n");
            assertEquals(d.toString(), "equal");
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

    @Test
    public void testDataset() {
        test(Dataset.class);
    }


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
