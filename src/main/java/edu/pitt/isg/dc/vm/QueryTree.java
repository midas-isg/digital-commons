package edu.pitt.isg.dc.vm;

import edu.pitt.isg.dc.entry.util.Treeable;
import lombok.Data;

import java.util.Comparator;
import java.util.Set;
import java.util.TreeSet;

import static java.util.Comparator.comparing;

@Data
public class QueryTree<T extends Treeable> {
    private T self;
    private Set<QueryTree<T>> children;

    private static final Comparator<QueryTree> comparator = comparing(
            t -> t.getSelf().getName(),
            String::compareToIgnoreCase);

    private QueryTree(){
    }

    public static <T extends Treeable> QueryTree of(T self){
        final QueryTree tree = new QueryTree();
        tree.self = self;
        tree.children = new TreeSet<>(comparator);
        return tree;
    }

    public void addChild(QueryTree<T> child){
        children.add(child);
    }
}
