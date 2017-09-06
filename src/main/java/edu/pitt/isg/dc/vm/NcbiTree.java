package edu.pitt.isg.dc.vm;

import edu.pitt.isg.dc.entry.Ncbi;
import lombok.Data;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import static java.util.Comparator.comparing;
import static java.util.stream.Collectors.toList;

@Data
public class NcbiTree {
    private Ncbi self;
    private Set<NcbiTree> children;

    private static final Comparator<NcbiTree> comparator = comparing(
            t -> t.getSelf().getName(),
            String::compareToIgnoreCase);

    private NcbiTree(){
    }

    public static NcbiTree of(Ncbi ncbi){
        final NcbiTree tree = new NcbiTree();
        tree.self = ncbi;
        tree.children = new TreeSet<>(comparator);
        return tree;
    }

    public void addChild(NcbiTree child){
        children.add(child);
    }
}
