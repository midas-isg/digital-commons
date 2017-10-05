package edu.pitt.isg.dc.entry.classes.datatree;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * Created by amd176 on 10/3/17.
 */
public class DataTreeWithBins extends DataTree {
    private BinHelper binHelper;

    public DataTreeWithBins() {
        binHelper = new BinHelper();
        binHelper.addBinsToJsonArray(this.getTreeNodes());
    }

    public DataTreeWithBins(String[] bins) {
        binHelper = new BinHelper(bins);
        binHelper.addBinsToJsonArray(this.getTreeNodes());
    }

    public void adjustBinSizes(String name, int size) {
        binHelper.adjustBinSizes(name, size);
    }

    public void sortBinNodes() {
        binHelper.sortBinNodes(this.getTreeNodes());
    }

    public int[] getBinSizes() {
        return binHelper.getBinSizes();
    }

    public void addNodeToBin(String name, JsonObject node) {
        binHelper.addNodeToBin(name, node, this.getTreeNodes());
    }

    public void addBinSizesToJson() {
        this.addBinSizesToJson(this.getTreeNodes());
    }

    public void addBinSizesToJson(JsonArray jsonArray) {
        binHelper.addBinSizesToJson(jsonArray);
    }

    public int getBinIndex(String name) {
        return binHelper.getBinIndex(name);
    }
}
