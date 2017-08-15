package edu.pitt.isg.dc.entry.util;

import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import edu.pitt.isg.dc.entry.Category;
import edu.pitt.isg.dc.entry.CategoryOrder;
import edu.pitt.isg.dc.entry.CategoryOrderRepository;
import edu.pitt.isg.dc.entry.classes.EntryView;
import edu.pitt.isg.dc.entry.exceptions.MdcEntryDatastoreException;
import edu.pitt.isg.dc.entry.interfaces.EntryApprovalInterface;
import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.stereotype.Component;
import java.lang.reflect.Type;
import java.util.*;

@Component
public class CategoryHelper {

    private CategoryOrderRepository categoryOrderRepository;
    private EntryApprovalInterface entryApprovalInterface;

    public CategoryHelper(CategoryOrderRepository categoryOrderRepository, EntryApprovalInterface entryApprovalInterface) {
        this.categoryOrderRepository = categoryOrderRepository;
        this.entryApprovalInterface = entryApprovalInterface;
    }

    private Map<String, Object> getCategoryOrderMap() {
        List<CategoryOrder> categoryOrders = categoryOrderRepository.findAll();
        Category rootCategory = new Category();
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = new HashMap<>();
        for(CategoryOrder co : categoryOrders) {
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

    public List<Map<String,String>> getEntryTrees() throws MdcEntryDatastoreException {
        Map<String, Object> map = this.getCategoryOrderMap();
        Category rootCategory = (Category) map.get("root");
        Map<Category, List<CategoryWithOrder>> categoryOrderMap = (HashMap<Category, List<CategoryWithOrder>>) map.get("categoryOrderMap");

        Map<Long, List<EntryView>> categoryEntryMap = this.getCategoryEntryMap();
        this.getTreePaths();

        JsonParser jsonParser = new JsonParser();
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

        return treeInfoArr;
    }

    private JsonArray recurseCategories(Category category, Map<Category, List<CategoryWithOrder>> categoryOrderMap, Map<Long, List<EntryView>> categoryEntryMap, JsonArray tree) {
        JsonObject treeNode = new JsonObject();
        treeNode.addProperty("categoryId", category.getId());
        treeNode.addProperty("text", category.getCategory());
        treeNode.addProperty("count", 0);
        treeNode.add("nodes", new JsonArray());

        if(categoryEntryMap.containsKey(category.getId())) {
            List<EntryView> entries = categoryEntryMap.get(category.getId());
            for(EntryView entry : entries) {
                String title = entry.getTitle();

                JsonObject leafNode = new JsonObject();
                leafNode.addProperty("entryId", entry.getId().toString());
                leafNode.addProperty("json", entry.getUnescapedEntryJsonString());
                leafNode.addProperty("xml", entry.getXmlString());
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
                nodeObj.add("nodes", sortedJsonArray(nodeObj.getAsJsonArray("nodes")));
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

    private JsonArray sortedJsonArray(JsonArray jsonArray) {
        Type listType = new TypeToken<List<JsonObject>>() {}.getType();
        List<JsonObject> myList = new Gson().fromJson(jsonArray, listType);
        Collections.sort(myList, new JsonObjectTextComparator());

        JsonArray sortedJsonArray = new JsonArray();
        for(JsonObject listItem : myList)
            sortedJsonArray.add(listItem);

        return sortedJsonArray;
    }

    private class JsonObjectTextComparator implements Comparator<JsonObject> {
        @Override
        public int compare(JsonObject o1, JsonObject o2) {
            return o1.get("text").getAsString().toLowerCase().compareTo(o2.get("text").getAsString().toLowerCase());
        }
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