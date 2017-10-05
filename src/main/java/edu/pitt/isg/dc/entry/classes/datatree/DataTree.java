package edu.pitt.isg.dc.entry.classes.datatree;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * Created by amd176 on 10/4/17.
 */
public class DataTree {
    private JsonArray treeNodes = new JsonArray();

    public JsonArray getTreeNodes() {
        return this.treeNodes;
    }

    public void setTreeNodes(JsonArray treeNodes) {
        this.treeNodes = treeNodes;
    }

    public JsonObject getStateNode(boolean state) {
        JsonObject stateObj = new JsonObject();
        stateObj.addProperty("expanded", state);
        return stateObj;
    }

    public JsonObject getEmptyNodeWithInnerNodes() {
        JsonObject node = new JsonObject();
        node.add("nodes", new JsonArray());
        return node;
    }
}
