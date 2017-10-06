package edu.pitt.isg.dc.entry.classes.datatree;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import edu.pitt.isg.dc.entry.util.EntryHelper;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.IntStream;

/**
 * Created by amd176 on 10/4/17.
 */
public class BinHelper {
    private String[] bins = new String[]{"A-B", "C-F", "G-L", "M-P", "R-S", "T-Z"};
    private int[] binSizes = new int[]{0,0,0,0,0,0};
    private Map<Character, Integer> binMap = new HashMap<>();

    public BinHelper() {
        this.populateBins();
    }

    public BinHelper(String[] bins) {
        this.bins = bins;
        this.binSizes = IntStream.generate(() -> 0).limit(bins.length).toArray();
        this.populateBins();
    }

    public String[] getBins() {
        return bins;
    }

    public void setBins(String[] bins) {
        this.bins = bins;
    }

    public int[] getBinSizes() {
        return binSizes;
    }

    public void setBinSizes(int[] binSizes) {
        this.binSizes = binSizes;
    }

    public Map<Character, Integer> getBinMap() {
        return binMap;
    }

    public void sortBinNodes(JsonArray jsonArray) {
        for(int i = 0; i < this.getBins().length; i++) {
            JsonArray binNodes = jsonArray.get(i)
                    .getAsJsonObject().get("nodes").getAsJsonArray();
            JsonArray sortedNodes = EntryHelper.sortedJsonArray(binNodes);
            jsonArray.get(i).getAsJsonObject().add("nodes", sortedNodes);
        }
    }

    public void setBinMap(Map<Character, Integer> binMap) {
        this.binMap = binMap;
    }

    public void adjustBinSizes(String name, int size) {
        this.getBinSizes()[this.getBinIndex(name)] += size;
    }

    public void addBinsToJsonArray(JsonArray jsonArray) {
        for(String bin : this.bins) {
            String text = bin;
            if(bin.charAt(0) == bin.charAt(2)) {
                text = "" + bin.charAt(0);
            }
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("text", text);
            jsonObject.add("nodes", new JsonArray());
            jsonArray.add(jsonObject);
        }
    }

    public void addBinSizesToJson(JsonArray jsonArray) {
        int[] binSizes = this.getBinSizes();
        for(int i = 0; i < binSizes.length; i++) {
            JsonObject jsonObject = jsonArray.get(i).getAsJsonObject();
            String text = jsonObject.get("text").getAsString();
            jsonObject.addProperty("text", text + " [" + binSizes[i] + "]");
        }
    }

    public int getBinIndex(String name) {
        Character beginsWith = name.toLowerCase().charAt(0);
        return this.getBinMap().get(beginsWith);
    }

    public void addNodeToBin(String name, JsonObject node, JsonArray jsonArray) {
        int binIndex = this.getBinIndex(name);
        jsonArray.get(binIndex)
                .getAsJsonObject()
                .get("nodes")
                .getAsJsonArray()
                .add(node);
    }

    private void populateBins() {
        int index = 0;
        for(char alphabet = 'a'; alphabet <= 'z'; alphabet++) {
            int currentChar = (int) alphabet;
            int lowerBound = (int) this.bins[index].toLowerCase().charAt(0);
            int upperBound = (int) this.bins[index].toLowerCase().charAt(2);

            if (!(currentChar >= lowerBound && currentChar <= upperBound))
                index++;

            this.binMap.put(alphabet, index);
        }
    }
}
