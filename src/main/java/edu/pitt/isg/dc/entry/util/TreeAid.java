package edu.pitt.isg.dc.entry.util;

import edu.pitt.isg.dc.vm.QueryTree;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.Comparator.comparing;
import static java.util.stream.Collectors.toList;

public class TreeAid {
    private TreeAid() {
    }

    public static <T extends Treeable> List<QueryTree<T>> toForest(List<T> list) {
        if (list == null)
            return Collections.emptyList();
        final List<QueryTree> trees = list.stream()
                .sorted(comparing(T::getPath)
                        .thenComparing(comparing(T::getName, String::compareToIgnoreCase)))
                .map(QueryTree::of)
                .collect(toList());
        final Map<String, QueryTree<T>> path2tree = new HashMap<>();
        final List<QueryTree<T>> roots = new ArrayList<>();
        for (QueryTree<T> tree : trees){
            final QueryTree<T> parent = path2tree.getOrDefault(toParentNcbiPath(tree), null);
            path2tree.put(tree.getSelf().getPath(), tree);
            if (parent == null)
                roots.add(tree);
            else
                parent.addChild(tree);
        }

        return roots.stream()
                .sorted(comparing(t -> t.getSelf().getName()))
                .collect(toList());
    }

    private static <T extends Treeable> String toParentNcbiPath(QueryTree<T> tree) {
        final T self = tree.getSelf();
        return self.getPath().replace("/" + self.getId(), "");
    }
}
