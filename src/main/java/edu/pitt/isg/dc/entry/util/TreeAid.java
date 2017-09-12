package edu.pitt.isg.dc.entry.util;

import com.google.common.annotations.VisibleForTesting;
import edu.pitt.isg.dc.entry.Asv;
import edu.pitt.isg.dc.vm.QueryTree;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import static java.util.Comparator.comparing;
import static java.util.stream.Collectors.toList;

public class TreeAid {
    @VisibleForTesting
    static int LIMIT_PARENT_LEVEL_SEARCH = 3;
    static final String regex_path = "/[0-9]*$";

    private TreeAid() {
    }

    public static <T extends Treeable> List<QueryTree<T>> toForest(List<T> list) {
        if (list == null)
            return Collections.emptyList();
        final Stream<QueryTree<T>> sortedTrees = sortByPath(list);
        return makeForest(sortedTrees).stream()
                .sorted(nameIgnoreCase())
                .collect(toList());
    }

    private static <T extends Treeable>
    Stream<QueryTree<T>> sortByPath(List<T> list) {
        return list.stream()
                .sorted(comparing(T::getPath))
                .map(QueryTree::of);
    }

    private static <T extends Treeable>
    List<QueryTree<T>> makeForest(Stream<QueryTree<T>> sortedTrees) {
        final List<QueryTree<T>> forest = new ArrayList<>();
        final Map<String, QueryTree<T>> path2tree = new HashMap<>();
        sortedTrees.forEach(tree -> {
            final String parentPath = toParentPath(tree);
            final QueryTree<T> parent = toBestParent(path2tree, parentPath);
            path2tree.put(tree.getSelf().getPath(), tree);
            if (parent == null)
                forest.add(tree);
            else
                parent.addChild(tree);
        });
        return forest;
    }

    private static <T extends Treeable> QueryTree<T> toBestParent(
            Map<String, QueryTree<T>> path2tree,
            String parentPath) {
        QueryTree<T> parent = path2tree.getOrDefault(parentPath, null);
        String path = parentPath;
        String regex = toRegex(parent);
        for (int i = 0; parent == null && i < LIMIT_PARENT_LEVEL_SEARCH; i++) {
            path = toParentPath(path, regex);
            parent = path2tree.getOrDefault(path, null);
        }
        return parent;
    }

    private static <T extends Treeable> String toRegex(QueryTree<T> parent) {
        if (parent == null)
            return regex_path;
        if (parent.getSelf() instanceof Asv){
            return ",[^,]*$";
        }
        return regex_path;
    }

    @VisibleForTesting
    static String toParentPath(String path) {
        return toParentPath(path, regex_path);
    }

    private static String toParentPath(String path, String regex) {
        return path.replaceAll(regex, "");
    }

    private static <T extends Treeable> Comparator<QueryTree<T>> nameIgnoreCase() {
        return comparing(t -> t.getSelf().getName(), String::compareToIgnoreCase);
    }

    private static <T extends Treeable> String toParentPath(QueryTree<T> tree) {
        final String regex = toRegex(tree);
        return toParentPath(tree.getSelf().getPath(), regex);
    }
}
