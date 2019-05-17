package edu.pitt.isg.dc.entry.util;

import com.google.gson.*;
import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.classes.datatree.LocationDataTreeWithBins;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import edu.pitt.isg.dc.utils.MapUtil;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigInteger;
import java.util.*;

@Component
public class CategoryHelper {

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private CategoryOrderRepository categoryOrderRepository;

    @Autowired
    private EntryApprovalInterface entryApprovalInterface;

    @Autowired
    private EntryRule entryRule;

    @Autowired
    private LocationRule locationRule;

    @Autowired
    private EntryService entryService;

//    private Map<String, String> subcategoriesToCategories;

    Map<Long, List<EntryView>> categoryEntryMap = new HashMap<>();

/*
    public CategoryHelper() {
        this.subcategoriesToCategories = new HashMap<>();
    }
*/

    public CategoryHelper(CategoryOrderRepository categoryOrderRepository, EntryApprovalInterface entryApprovalInterface) {
        this.categoryOrderRepository = categoryOrderRepository;
        this.entryApprovalInterface = entryApprovalInterface;
//        this.subcategoriesToCategories = new HashMap<>();
    }

    private Map<String, Object> getCategoryOrderMap() {
        List<CategoryOrder> categoryOrders = categoryOrderRepository.findAll();

        Category rootCategory = new Category();
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = new HashMap<>();

/*
        boolean populateSubcategoriesToCategories = false;
        if(subcategoriesToCategories.size() == 0) {
            populateSubcategoriesToCategories = true;
        }
*/

        for(CategoryOrder co : categoryOrders) {
/*
            if(populateSubcategoriesToCategories) {
                String subcategory = co.getSubcategory().getCategory() + " " + co.getSubcategory().getId();
                String category = co.getCategory().getCategory() + " " + co.getCategory().getId();

                subcategoriesToCategories.put(subcategory, category);
            }
*/

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

    private Map<Long, List<EntryView>> getCategoryEntryMap(Boolean resetTree, Long subCategoryId) throws MdcEntryDatastoreException {
        if (categoryEntryMap.size() == 0 || resetTree) {
            List<Category> categories = categoryRepository.findAll();
            for (Category category : categories) {
                categoryEntryMap.put(category.getId(), new ArrayList<>());
            }

            List<EntryView> entries = new ArrayList<>();
            if (subCategoryId != 1L) { // 1L = Root
                for (Entry entrySubCategory : entryService.getAllEntriesPertainingToCategory(subCategoryId)){
                    entries.add(new EntryView(entrySubCategory));
                }
            } else entries = entryApprovalInterface.getPublicEntries();

            Map<Long, Long> subsetEntryMap = new HashMap<Long, Long>();

            for (EntryView entry : entries) {
                Category category = entry.getCategory();
                if (category != null) {
                    Long categoryId = category.getId();

                    if (categoryEntryMap.containsKey(categoryId)) {
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

            for (Long id : categoryEntryMap.keySet()) {
                List<EntryView> items = categoryEntryMap.get(id);
                items.sort(Comparator.comparing(EntryView::getTitle, String.CASE_INSENSITIVE_ORDER));
            }
        }
        return categoryEntryMap;
    }

    public String getTopCategory(Category categoryObject) {
        return categoryRepository.getTopCategory(categoryObject.getId());
    }

    private Map<String, String> getInfoByCountry() {
        LocationDataTreeWithBins locationDataTree = new LocationDataTreeWithBins(locationRule, entryRule, this);
        locationDataTree.populateTree();

        Map<String, String> countryTreeInfo = new HashMap<>();
        countryTreeInfo.put("category", "Country");
        countryTreeInfo.put("json", StringEscapeUtils.escapeJavaScript(locationDataTree.getTreeNodes().toString()));

        return countryTreeInfo;
    }

    public List<Map<String,String>> getEntryTrees(Long subCategoryId) throws MdcEntryDatastoreException {
        Map<String, Object> map = this.getCategoryOrderMap();
        Category rootCategory = (Category) map.get("root");
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = (HashMap<Category, List<CategoryWithOrder>>) map.get("categoryOrderMap");

        Boolean resetTree = true;
        Map<Long, List<EntryView>> categoryEntryMap = this.getCategoryEntryMap(resetTree, subCategoryId);
        this.getTreePaths(subCategoryId);

        List<Map<String,String>> treeInfoArr = new ArrayList<>();
        if(categoryOrderMap.size() > 0) {
            for (CategoryWithOrder node : categoryOrderMap.get(rootCategory)) {
                JsonArray tree = new JsonArray();
                tree = this.recurseCategories(node.getCategory(), categoryOrderMap, categoryEntryMap, tree);
                JsonArray treeNodes = (JsonArray) tree.get(0).getAsJsonObject().get("nodes");

                //Remove nodes with Zero count
                cleanTreeNodes(treeNodes);

                Map<String, String> treeInfo = new HashMap<>();
                treeInfo.put("category", node.getCategoryName());
                treeInfo.put("json", StringEscapeUtils.escapeJavaScript(treeNodes.toString()));
                treeInfoArr.add(treeInfo);
            }
        }

        if(subCategoryId == 1L){ // 1L = Root
            treeInfoArr.add(this.getInfoByCountry());
        }
        return treeInfoArr;
    }

    private void cleanTreeNodes(JsonArray treeNodes) {
        for (Iterator<JsonElement> iterator = treeNodes.iterator(); iterator.hasNext(); ) {
            JsonElement treeNode = iterator.next();
            if(treeNode.getAsJsonObject().has("count")) {
                int count = treeNode.getAsJsonObject().get("count").getAsInt();
                if (count == 0) {
                    iterator.remove();
                } else if(treeNode.getAsJsonObject().has("nodes")) {
                        cleanTreeNodes(treeNode.getAsJsonObject().get("nodes").getAsJsonArray());
                }
            }
        }
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

    public Map<Long, String> getTreePaths(Long subCategoryId) throws MdcEntryDatastoreException {
        Map<Long, String> treePathMap = new HashMap<Long, String>();
        List<Object[]> treePathObject;
        if(subCategoryId != 1L){
            treePathObject = categoryRepository.getTreePathsSubset(subCategoryId);
        } else treePathObject = categoryRepository.getTreePaths();

        for(Object[] obj : treePathObject){
            if(obj.length == 2){
                Long key = ((BigInteger) obj[0]).longValue();
                String value = (String) obj[1];
                //Root (1) and Standard Identifiers (5) do not need to be in the map
                if(!treePathMap.containsKey(key) && !(key == 1 || key == 5)){
                    treePathMap.put(key, value);
                }
            }
        }

        return MapUtil.sortByValue(treePathMap);
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
