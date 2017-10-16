package edu.pitt.isg.dc.utils;

import java.util.HashMap;

/**
 * Created by amd176 on 10/16/17.
 */
public class SystemProperties extends HashMap<String, String> {

    @Override
    public String get(Object name) {
        return System.getenv(name != null ? name.toString() : null);
    }

}
