package edu.pitt.isg.dc.entry.classes.datatree;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.util.CategoryHelper;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import edu.pitt.isg.dc.vm.OntologyQuery;

import java.util.*;

/**
 * Created by amd176 on 10/3/17.
 */
public class LocationDataTreeWithBins extends DataTreeWithBins {
    private final String US_PATH = "544694/544695/542917/1216";
    private final int US_ALC = 1216;

    private LocationRule locationRule;
    private EntryRule entryRule;
    private CategoryHelper categoryHelper;

    private JsonObject statesObj;
    private JsonObject unitedStatesObj;

    private BinHelper statesBinHelper = new BinHelper(new String[]{"A-C", "D-I", "J-M", "N-O", "P-U", "V-Z"});
    private BinHelper dsdBinHelper = null;

    public LocationDataTreeWithBins(LocationRule locationRule, EntryRule entryRule, CategoryHelper categoryHelper) {
        super(1);
        this.locationRule = locationRule;
        this.entryRule = entryRule;
        this.categoryHelper = categoryHelper;
    }

    public LocationDataTreeWithBins(LocationRule locationRule, EntryRule entryRule, CategoryHelper categoryHelper, String[] bins) {
        super(bins);
        this.locationRule = locationRule;
        this.entryRule = entryRule;
        this.categoryHelper = categoryHelper;
    }

    public Set<EntryId> getEntryIdsForLocation(Location location) {
        List<OntologyQuery<Long>> queries = new ArrayList<>();
        OntologyQuery<Long> ontologyQuery = new OntologyQuery<>(location.getId());
        ontologyQuery.setIncludeAncestors(false);

        if(location.getId() == US_ALC)
            ontologyQuery.setIncludeDescendants(false);

        queries.add(ontologyQuery);

        return locationRule.searchEntryIdsByAlc(queries);
    }

    public void populateTree() {
        List<Location> locations = locationRule.findLocationsInEntries();
        locations.sort(Comparator.comparing(Location::getPath));

        for(Location location : locations) {
            this.populateLocationInTree(location);
        }

        this.addBinSizesToJson();

        statesBinHelper.sortBinNodes(statesObj.getAsJsonArray("nodes"));
        statesBinHelper.addBinSizesToJson(statesObj.getAsJsonArray("nodes"));

        JsonObject countryObj = unitedStatesObj.getAsJsonArray("nodes").get(0).getAsJsonObject();
        JsonArray countryArray = unitedStatesObj.getAsJsonArray("nodes").get(0).getAsJsonObject().getAsJsonArray("nodes");

        for(int i = 0; i < countryArray.size(); i++) {
            JsonObject jsonObject = countryArray.get(i).getAsJsonObject();
            JsonArray jsonArray = jsonObject.getAsJsonArray("nodes");
            if(jsonObject.get("text").getAsString().contains("Disease surveillance data")) {
                jsonArray = dsdBinHelper.sortBinNodes(jsonArray);
            }
            jsonObject.add("nodes", EntryHelper.sortedJsonArray(jsonArray));
        }

        countryObj.add("nodes", EntryHelper.sortedJsonArray(countryArray));

        this.appendCountToNodeText(countryObj);
        this.appendCountToNodeText(statesObj);
        this.appendCountToNodeText(unitedStatesObj);

        unitedStatesObj.getAsJsonArray("nodes").add(statesObj);

        this.sortBinNodes();
        this.setBinsToFirstAndLastElements();
    }

    private void appendCountToNodeText(JsonObject jsonObject) {
        int count = jsonObject.get("count").getAsInt();
        String text = jsonObject.get("text").getAsString().replaceAll(" \\[(.*?)\\]", "");
        jsonObject.addProperty("text", text + " [" + count + "]");
    }

    private void appendCountToNodeText(JsonObject jsonObject, int count) {
        String text = jsonObject.get("text").getAsString().replaceAll(" \\[(.*?)\\]", "");
        jsonObject.addProperty("text", text + " [" + count + "]");
    }

    private EntryView getEntry(EntryId id) {
        Entry entry = entryRule.read(id);
        return new EntryView(entry);
    }

    private String getLeafLabel(String category, String title) {
        Map<String, String> abbreviations = new HashMap<>();
        abbreviations.put("Synthetic population and ecosystem", "Synthpop");
        abbreviations.put("Disease surveillance data", "Disease surveillance");

        String[] tokens = category.split(" ");
        for(int i = 0; i < tokens.length; i++) {
            if(tokens[i].endsWith("s")) tokens[i] = tokens[i].substring(0, tokens[i].length() - 1);
        }
        category = String.join(" ", tokens);

        if(abbreviations.containsKey(category)) category = abbreviations.get(category);
        return "[<span class=\"data-label\">" + category + "</span>] " + title;
    }

    private JsonObject getLeafNode(EntryView entryView, String title) {
        Category category = entryView.getCategory();
        if(entryView.getEntryName().contains("Virginia")) {
            System.out.println("here");
        }
        String topCategory = categoryHelper.getTopCategory(category);

        String entryName = entryView.getEntryName();
        if(entryName.contains("Synthetic Ecosystem")) {
            title = "[<span class=\"data-label\">SPEW</span>] " + entryName;
        } else if(entryName.contains("Synthetic Population")) {
            title = "[<span class=\"data-label\">Synthia™</span>] " + entryName;
        } else if(title == null) {
            title = getLeafLabel(topCategory, entryName);
        }

        JsonObject leafNode = new JsonObject();
        leafNode.addProperty("entryId", entryView.getId().toString());
        leafNode.addProperty("text", title);
        leafNode.addProperty("type", entryView.getEntryType());

        return leafNode;
    }

    private int incrementCount(JsonObject jsonObject, int size) {
        int count = size;
        if(jsonObject.has("count")) {
            count += jsonObject.get("count").getAsInt();
        }
        jsonObject.addProperty("count", count);
        return count;
    }

    private void addUnitedStatesNode(EntryView entryView, JsonObject node) {
        JsonObject leafNode = this.getLeafNode(entryView, entryView.getEntryName());

        String entryType = categoryHelper.getTopCategory(entryView.getCategory());
        JsonArray innerNodes = node.getAsJsonArray("nodes");

        JsonObject countryObj = innerNodes.get(0).getAsJsonObject();
        JsonArray countryNodes = countryObj.getAsJsonArray("nodes");

        boolean isDsd = false;
        if(entryType.equals("Disease surveillance data")) {
            isDsd = true;
        }

        boolean hasMatch = false;
        for(int i = 0; i < countryNodes.size(); i++) {
            JsonObject innerObj = countryNodes.get(i).getAsJsonObject();
            String text = "";
            try {
                text = innerObj.get("name").getAsString();
            } catch (Exception e) {
                continue;
            }
            if(text.equals(entryType)) {
                hasMatch = true;

                int count = this.incrementCount(innerObj, 1);
                innerObj.addProperty("text", "<span class=\"data-label\">" + text + "</span> [" + count + "]");

                this.incrementCount(countryObj, 1);
                this.incrementCount(unitedStatesObj, 1);
                this.adjustBinSizes("United States", 1);

                if(isDsd) {
                    dsdBinHelper.addNodeToBin(entryView.getTitle(), leafNode, innerObj.getAsJsonArray("nodes"));
                    dsdBinHelper.adjustBinSizes(entryView.getTitle(), 1);

                    int binIndex = dsdBinHelper.getBinIndex(entryView.getTitle());
                    this.appendCountToNodeText(
                            innerObj.getAsJsonArray("nodes").get(binIndex).getAsJsonObject(),
                            dsdBinHelper.getBinSizes()[binIndex]);
                }
                else {
                    innerObj.getAsJsonArray("nodes").add(leafNode);
                }
                break;
            }
        }

        if(!hasMatch) {
            JsonObject innerObj = this.getEmptyNodeWithInnerNodes();

            innerObj.addProperty("text", "<span class=\"data-label\">" + entryType + "</span> [1]");
            innerObj.addProperty("name",  entryType);
            this.incrementCount(innerObj, 1);

            if(isDsd) {
                if(dsdBinHelper == null) {
                    dsdBinHelper = new BinHelper(new String[]{"A-A", "B-C", "D-E", "F-H", "I-I", "J-L", "M-O", "P-R", "S-S", "T-T", "U-Z"});
                    dsdBinHelper.addBinsToJsonArray(innerObj.getAsJsonArray("nodes"));
                }
                dsdBinHelper.addNodeToBin(entryView.getTitle(), leafNode, innerObj.getAsJsonArray("nodes"));
                dsdBinHelper.adjustBinSizes(entryView.getTitle(), 1);
            } else {
                innerObj.getAsJsonArray("nodes").add(leafNode);
            }

            this.incrementCount(countryObj, 1);
            this.incrementCount(unitedStatesObj, 1);
            this.adjustBinSizes("United States", 1);

            countryNodes.add(innerObj);
        }
    }

    private void populateLocationInTree(Location location) {
        String locationType = location.getLocationTypeName();
        boolean isCountry = locationType.equalsIgnoreCase("country");
        boolean isState = locationType.equalsIgnoreCase("state")
                && location.getPath().contains(US_PATH);

        if(isCountry || isState) {
            JsonObject node = this.getEmptyNodeWithInnerNodes();
            node.add("state", this.getStateNode(false));

            if(isCountry) {
                this.addNodeToBin(location.getName(), node);

                if(location.getId() == US_ALC && unitedStatesObj == null) {
                    unitedStatesObj = node;

                    JsonObject countryNode = this.getEmptyNodeWithInnerNodes();
                    countryNode.addProperty("text", "National data");

                    unitedStatesObj.getAsJsonArray("nodes").add(countryNode);

                    if(statesObj == null) {
                        statesObj = this.getEmptyNodeWithInnerNodes();
                        statesObj.addProperty("text", "State level data");
                        statesBinHelper.addBinsToJsonArray(statesObj.getAsJsonArray("nodes"));
                    }
                }
            } else {
                statesBinHelper.addNodeToBin(location.getName(), node, statesObj.getAsJsonArray("nodes"));
            }

            Set<EntryId> ids = this.getEntryIdsForLocation(location);
            for(EntryId id : ids) {
                EntryView entryView = this.getEntry(id);
                if (entryView.getEntryTypeBaseName().equals("Dataset")) {
                    if (location.getId() == US_ALC) {
                        addUnitedStatesNode(entryView, node);
                    } else {
                        JsonObject leafNode = this.getLeafNode(entryView, null);
                        node.getAsJsonArray("nodes").add(leafNode);
                    }
                }
            }

            int size = node.getAsJsonArray("nodes").size();
            if(!isState && location.getId() != US_ALC) {
                this.adjustBinSizes(location.getName(), size);
            } else if(location.getId() != US_ALC) {
                this.incrementCount(statesObj, size);
                this.incrementCount(unitedStatesObj, size);
                this.adjustBinSizes("United States", size);
                statesBinHelper.adjustBinSizes(location.getName(), size);
            }

            if(location.getId() == US_ALC) {
                node.addProperty("text", location.getName());
            } else {
                node.addProperty("text", location.getName() + " [" + size + "]");
            }

            node.add("nodes", EntryHelper.sortedJsonArray(node.getAsJsonArray("nodes")));
        }
    }
}
