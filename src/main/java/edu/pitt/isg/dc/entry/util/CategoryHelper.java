package edu.pitt.isg.dc.entry.util;

import com.google.gson.*;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.classes.datatree.LocationDataTreeWithBins;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class CategoryHelper {

    @Autowired
    private CategoryOrderRepository categoryOrderRepository;

    @Autowired
    private EntryApprovalInterface entryApprovalInterface;

    @Autowired
    private EntryRule entryRule;

    @Autowired
    private LocationRule locationRule;

    private Map<String, String> subcategoriesToCategories;

    public CategoryHelper() {
        this.subcategoriesToCategories = new HashMap<>();
    }

    public CategoryHelper(CategoryOrderRepository categoryOrderRepository, EntryApprovalInterface entryApprovalInterface) {
        this.categoryOrderRepository = categoryOrderRepository;
        this.entryApprovalInterface = entryApprovalInterface;
        this.subcategoriesToCategories = new HashMap<>();
    }

    private Map<String, Object> getCategoryOrderMap() {
        List<CategoryOrder> categoryOrders = categoryOrderRepository.findAll();

        Category rootCategory = new Category();
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = new HashMap<>();

        boolean populateSubcategoriesToCategories = false;
        if(subcategoriesToCategories.size() == 0) {
            populateSubcategoriesToCategories = true;
        }

        for(CategoryOrder co : categoryOrders) {
            if(populateSubcategoriesToCategories)
                subcategoriesToCategories.put(co.getSubcategory().getCategory(), co.getCategory().getCategory());

            Category category = co.getCategory();
            CategoryWithOrder subcategory = new CategoryWithOrder(co.getSubcategory(), co.getOrdering());

            if(category.getCategory().equals("Root")) {
                rootCategory = category;
            }

            List<CategoryWithOrder> subcategories = new ArrayList<>();
            if(categoryOrderMap.containsKey(category)) {
                subcategories = categoryOrderMap.get(category);
            }

            subcategories.add(subcategory);
            categoryOrderMap.put(category, subcategories);
        }

        for(Category category : categoryOrderMap.keySet()) {
            List<CategoryWithOrder> subcategories = categoryOrderMap.get(category);

            if(subcategories.size() > 0 && subcategories.get(0).getOrder() != null) {
                subcategories.sort(Comparator.comparing(CategoryWithOrder::getOrder));
            } else {
                subcategories.sort(Comparator.comparing(CategoryWithOrder::getCategoryName, String.CASE_INSENSITIVE_ORDER));
            }
        }

        Map<String, Object> map = new HashMap<>();
        map.put("root", rootCategory);
        map.put("categoryOrderMap", categoryOrderMap);
        return map;
    }

    private class CategoryWithOrder {
        private Category category;
        private Integer order;

        public CategoryWithOrder(Category category, Integer order) {
            this.category = category;
            this.order = order;
        }

        public Category getCategory() {
            return category;
        }

        public void setCategory(Category category) {
            this.category = category;
        }

        public String getCategoryName() {
            return category.getCategory();
        }

        public Integer getOrder() {
            return order;
        }

        public void setOrder(Integer order) {
            this.order = order;
        }
    }

    private Map<Long, List<EntryView>> getCategoryEntryMap() throws MdcEntryDatastoreException {
        List<EntryView> entries = entryApprovalInterface.getPublicEntries();
        Map<Long, List<EntryView>> categoryEntryMap = new HashMap<>();
        for(EntryView entry : entries) {
            Category category = entry.getCategory();
            if(category != null) {
                Long categoryId = category.getId();

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
        }

        for(Long id : categoryEntryMap.keySet()) {
            List<EntryView> items = categoryEntryMap.get(id);
            items.sort(Comparator.comparing(EntryView::getTitle, String.CASE_INSENSITIVE_ORDER));
        }

        return categoryEntryMap;
    }

    public String getTopCategory(Category categoryObject) {
        if(subcategoriesToCategories.size() == 0) {
            this.getCategoryOrderMap();
        }
        String category = categoryObject.getCategory();
        List<String> list = Arrays.asList("Root", "Software", "Data", "Data Formats", "Standard Identifiers");
        while(!list.contains(subcategoriesToCategories.get(category))) {
            category = subcategoriesToCategories.get(category);
        }
        return category;
    }

    private List<Map<String, String>> getInfoByCountry() {
        LocationDataTreeWithBins locationDataTree = new LocationDataTreeWithBins(locationRule, entryRule, this);
        locationDataTree.populateTree();

        /*LocationDataTreeWithBins categoryDataTree = new LocationDataTreeWithBins(locationRule, entryRule);
        JsonArray treeNodesByCategory = categoryDataTree.getTreeNodes();

        Gson gson = new Gson();
        for(Location location : locations) {
            String locationType = location.getLocationTypeName();
            boolean isCountry = locationType.equalsIgnoreCase("country");
            boolean isState = locationType.equalsIgnoreCase("state") && location.getPath().contains("544694/544695/542917/1216");

            // countries or states that are not the US
            if((isCountry || isState) && location.getId() != 1216) {
                JsonObject node = dataTree.getEmptyNodeWithInnerNodes();
                node.addProperty("isState", isState);
                node.add("state", dataTree.getStateNode(false));

                JsonObject nodeByCategory = categoryDataTree.getEmptyNodeWithInnerNodes();
                nodeByCategory.addProperty("isState", isState);
                nodeByCategory.add("state", categoryDataTree.getStateNode(false));

                dataTree.addNodeToBin(location.getName(), node);
                treeNodes = dataTree.getTreeNodes();

                categoryDataTree.addNodeToBin(location.getName(), node);
                treeNodesByCategory = categoryDataTree.getTreeNodes();

                Set<EntryId> ids = dataTree.getEntryIdsForLocation(location);
                for(EntryId id : ids) {
                    Entry entry = entryRule.read(id);
                    EntryView entryView = new EntryView(entry);

                    String topCategory = this.getTopCategory(entryView.getCategory());
                    String typeAndTitle = "[<span class=\"data-label\">" + topCategory + "</span>] " + entryView.getTitle();

                    JsonObject leafNode = new JsonObject();
                    leafNode.addProperty("entryId", entryView.getId().toString());
                    leafNode.addProperty("json", entryView.getUnescapedEntryJsonString());
                    leafNode.addProperty("xml", entryView.getXmlString());
                    leafNode.addProperty("text", typeAndTitle);
                    leafNode.addProperty("type", entryView.getEntryType());

                    JsonObject leafNodeByCategory = gson.fromJson(leafNode.getAsJsonObject(), JsonObject.class);
                    leafNodeByCategory.addProperty("text", entryView.getTitle());

                    JsonObject categoryJsonObject = null;
                    for(JsonElement nodeElement : nodeByCategory.getAsJsonArray("nodes")) {
                        JsonObject nodeObject = nodeElement.getAsJsonObject();
                        String nodeText = nodeObject.get("text").getAsString().replaceAll(" \\[.*?\\]", "");
                        if(nodeText.equals(topCategory)) {
                            categoryJsonObject = nodeObject;
                            categoryJsonObject.getAsJsonArray("nodes").add(leafNodeByCategory);

                            int count = categoryJsonObject.get("count").getAsInt() + 1;
                            categoryJsonObject.addProperty("count", count);
                            categoryJsonObject.addProperty("text", nodeText + " [" + count + "]");

                            break;
                        }
                    }

                    if(categoryJsonObject == null) {
                        JsonArray categoryObjectNodes = new JsonArray();
                        categoryObjectNodes.add(leafNodeByCategory);

                        categoryJsonObject = new JsonObject();
                        categoryJsonObject.addProperty("text", topCategory + " [1]");
                        categoryJsonObject.addProperty("count", 1);
                        categoryJsonObject.add("nodes", categoryObjectNodes);

                        JsonObject categoryState = new JsonObject();
                        categoryState.addProperty("expanded", true);
                        categoryJsonObject.add("state", categoryState);

                        nodeByCategory.getAsJsonArray("nodes").add(categoryJsonObject);
                    }

                    node.getAsJsonArray("nodes").add(leafNode);
                }

                int size = node.getAsJsonArray("nodes").size();
                dataTree.adjustBinSizes(location.getName(), size);

                node.addProperty("text", location.getName() + " [" + size + "]");
                node.add("nodes", EntryHelper.sortedJsonArray(node.getAsJsonArray("nodes")));

                nodeByCategory.addProperty("text", location.getName() + " [" + size + "]");
                nodeByCategory.add("nodes", EntryHelper.sortedJsonArray(nodeByCategory.getAsJsonArray("nodes")));
            }
        }


        JsonObject unitedStates = new JsonObject();
        unitedStates.add("nodes", new JsonArray());

        JsonObject categoryUnitedStates = new JsonObject();
        categoryUnitedStates.add("nodes", new JsonArray());

        for(int i = 0; i < treeNodes.size(); i++) {
            JsonObject jsonObject = treeNodes.get(i).getAsJsonObject();

            JsonArray innerNodes = jsonObject.getAsJsonArray("nodes");
            for(Iterator<JsonElement> iterator = innerNodes.iterator(); iterator.hasNext();) {
                JsonElement element = iterator.next();
                JsonObject innerObject = element.getAsJsonObject();
                boolean isState = innerObject.get("isState").getAsBoolean();
                if(isState) {
                    unitedStates.getAsJsonArray("nodes").add(innerObject);
                    iterator.remove();
                }
            }

            jsonObject.addProperty("text", jsonObject.get("text").getAsString() + " [" + dataTree.getBinSizes()[i] + "]");

            JsonObject categoryJsonObject = treeNodesByCategory.get(i).getAsJsonObject();

            JsonArray innerCategoryNodes = categoryJsonObject.getAsJsonArray("nodes");
            for(Iterator<JsonElement> iterator = innerCategoryNodes.iterator(); iterator.hasNext();) {
                JsonElement element = iterator.next();
                JsonObject innerObject = element.getAsJsonObject();
                boolean isState = innerObject.get("isState").getAsBoolean();
                if(isState) {
                    categoryUnitedStates.getAsJsonArray("nodes").add(innerObject);
                    iterator.remove();
                }
            }

            categoryJsonObject.addProperty("text", categoryJsonObject.get("text").getAsString() + " [" + dataTree.getBinSizes()[i] + "]");

            jsonObject.add("nodes", EntryHelper.sortedJsonArray(jsonObject.getAsJsonArray("nodes")));
            categoryJsonObject.add("nodes", EntryHelper.sortedJsonArray(categoryJsonObject.getAsJsonArray("nodes")));

            if(i > 0) {
                JsonObject state = new JsonObject();
                state.addProperty("expanded", false);
                jsonObject.add("state", state);
                categoryJsonObject.add("state", state);
            }
        }

        unitedStates.addProperty("text", "United States of America (the)");
        categoryUnitedStates.addProperty("text", "United States of America (the)");

        treeNodes.get(dataTree.getBins().length - 1).getAsJsonObject().getAsJsonArray("nodes").add(unitedStates);
        treeNodesByCategory.get(dataTree.getBins().length - 1).getAsJsonObject().getAsJsonArray("nodes").add(categoryUnitedStates);

        Map<String, String> countryTreeInfo = new HashMap<>();
        countryTreeInfo.put("category", "Country");
        countryTreeInfo.put("json", StringEscapeUtils.escapeJavaScript(EntryHelper.sortedJsonArray(treeNodes).toString()));

        Map<String, String> countryTreeInfoByCategory = new HashMap<>();
        countryTreeInfoByCategory.put("category", "Country by Category");
        countryTreeInfoByCategory.put("json", StringEscapeUtils.escapeJavaScript(EntryHelper.sortedJsonArray(treeNodesByCategory).toString()));
        */
        Map<String, String> countryTreeInfo = new HashMap<>();
        countryTreeInfo.put("category", "Country");
        countryTreeInfo.put("json", StringEscapeUtils.escapeJavaScript(locationDataTree.getTreeNodes().toString()));

        List<Map<String, String>> infoList = new ArrayList<>();
        infoList.add(countryTreeInfo);
        /*infoList.add(countryTreeInfo);
        infoList.add(countryTreeInfoByCategory);*/

        return infoList;
    }

    public List<Map<String,String>> getEntryTrees() throws MdcEntryDatastoreException {
        Map<String, Object> map = this.getCategoryOrderMap();
        Category rootCategory = (Category) map.get("root");
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = (HashMap<Category, List<CategoryWithOrder>>) map.get("categoryOrderMap");

        Map<Long, List<EntryView>> categoryEntryMap = this.getCategoryEntryMap();
        this.getTreePaths();

        List<Map<String,String>> treeInfoArr = new ArrayList<>();
        if(categoryOrderMap.size() > 0) {
            for (CategoryWithOrder node : categoryOrderMap.get(rootCategory)) {
                JsonArray tree = new JsonArray();
                tree = this.recurseCategories(node.getCategory(), categoryOrderMap, categoryEntryMap, tree);
                JsonArray treeNodes = (JsonArray) tree.get(0).getAsJsonObject().get("nodes");

                Map<String, String> treeInfo = new HashMap<>();
                treeInfo.put("category", node.getCategoryName());
                treeInfo.put("json", StringEscapeUtils.escapeJavaScript(treeNodes.toString()));
                treeInfoArr.add(treeInfo);
            }
        }

        List<Map<String, String>> infoList = this.getInfoByCountry();
        treeInfoArr.add(infoList.get(0));
        //treeInfoArr.add(infoList.get(1));

        return treeInfoArr;
    }

    private JsonArray recurseCategories(Category category, Map<Category, List<CategoryWithOrder>> categoryOrderMap, Map<Long, List<EntryView>> categoryEntryMap, JsonArray tree) {
        JsonObject treeNode = new JsonObject();
        treeNode.addProperty("categoryId", category.getId());
        treeNode.addProperty("text",  EntryHelper.addBadges(category.getCategory(), category.getTags()));
        treeNode.addProperty("count", 0);
        treeNode.add("nodes", new JsonArray());

        if(category.isExpanded() != null && category.isExpanded()) {
            JsonObject state = new JsonObject();
            state.addProperty("expanded", true);
            treeNode.add("state", state);
        }

        if(categoryEntryMap.containsKey(category.getId())) {
            List<EntryView> entries = categoryEntryMap.get(category.getId());
            for(EntryView entry : entries) {
                String title = entry.getTitle();

                JsonObject leafNode = new JsonObject();
                leafNode.addProperty("entryId", entry.getId().toString());
//                leafNode.addProperty("json", entry.getUnescapedEntryJsonString());
//                leafNode.addProperty("xml", entry.getXmlString());
                leafNode.addProperty("text", title);
                leafNode.addProperty("type", entry.getEntryType());
                treeNode.getAsJsonArray("nodes").add(leafNode);

                int count = treeNode.getAsJsonPrimitive("count").getAsInt() + 1;
                treeNode.addProperty("count", count);
            }
        }

        if(categoryOrderMap.containsKey(category)) {
            List<CategoryWithOrder> childNodes = categoryOrderMap.get(category);
            for(CategoryWithOrder node : childNodes) {
                recurseCategories(node.getCategory(), categoryOrderMap, categoryEntryMap, treeNode.getAsJsonArray("nodes"));
            }
        }

        //treeNode.add("nodes", sortedJsonArray(treeNode.getAsJsonArray("nodes")));

        String text = treeNode.getAsJsonPrimitive("text").getAsString();
        int count = treeNode.getAsJsonPrimitive("count").getAsInt();
        JsonArray nodes = treeNode.getAsJsonArray("nodes");
        for(JsonElement node : nodes) {
            JsonObject nodeObj = node.getAsJsonObject();
            if(nodeObj.has("count")) {
                count += nodeObj.get("count").getAsInt();
            }

            if(nodeObj.has("nodes")) {
                nodeObj.add("nodes", EntryHelper.sortedJsonArray(nodeObj.getAsJsonArray("nodes")));
            }
        }
        text += " [" + count + "]";
        treeNode.addProperty("count", count);
        treeNode.addProperty("text", text);

        tree.add(treeNode);
        return tree;
    }

    public Map<Long, String> getTreePaths() throws MdcEntryDatastoreException {
        Map<String, Object> map = this.getCategoryOrderMap();
        Category rootCategory = (Category) map.get("root");
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = (HashMap<Category, List<CategoryWithOrder>>) map.get("categoryOrderMap");

        Map<Long, List<EntryView>> categoryEntryMap = this.getCategoryEntryMap();

        return this.recurseTreePaths(rootCategory, categoryOrderMap, categoryEntryMap, new HashMap<Long, String>(), "");
    }

    private Map<Long,String> recurseTreePaths(Category category, Map<Category, List<CategoryWithOrder>> categoryOrderMap, Map<Long, List<EntryView>> categoryEntryMap, Map<Long, String> paths, String path) {
        String categoryName = category.getCategory();
        if(categoryName != null && !categoryName.equals("Root")) {
            path += categoryName + " -> ";
            if(categoryEntryMap.containsKey(category.getId())) {
                paths.put(category.getId(), path.substring(0, path.lastIndexOf(" -> ")));
            }
        }

        if(categoryOrderMap.containsKey(category)) {
            List<CategoryWithOrder> childNodes = categoryOrderMap.get(category);
            for(CategoryWithOrder node : childNodes) {
                recurseTreePaths(node.getCategory(), categoryOrderMap, categoryEntryMap, paths, path);
            }
        }

        return paths;
    }

    public Collection<Category> getBottomLevelCategories() throws MdcEntryDatastoreException {
        Map<Long, Category> categories = new HashMap<>();
        List<EntryView> entries = entryApprovalInterface.getPublicEntries();
        for(EntryView entry : entries) {
            Category category = entry.getCategory();
            if(category != null)
                categories.put(category.getId(), category);
        }
        return categories.values();
    }
}
