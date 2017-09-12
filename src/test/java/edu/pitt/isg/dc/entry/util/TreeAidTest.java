package edu.pitt.isg.dc.entry.util;

import edu.pitt.isg.dc.entry.Location;
import edu.pitt.isg.dc.vm.QueryTree;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static edu.pitt.isg.dc.entry.util.TreeAid.toForest;
import static edu.pitt.isg.dc.entry.util.TreeAid.toParentPath;
import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;
import static java.util.Collections.singletonList;
import static org.assertj.core.api.Assertions.assertThat;

public class TreeAidTest {
    private static int defaultLimit = 0;

    @BeforeClass
    public static void dumpDefaultParameters() throws Exception {
        defaultLimit = TreeAid.LIMIT_PARENT_LEVEL_SEARCH;
    }

    @Before
    public void restoreDefaultParameters() throws Exception {
        TreeAid.LIMIT_PARENT_LEVEL_SEARCH = defaultLimit;
    }

    @Test
    public void toParentPathSimple() throws Exception {
        final String parentPath = toParentPath("1/2/3");
        assertThat(parentPath).isEqualTo("1/2");
    }

    @Test
    public void toForestOfNull() throws Exception {
        final List<QueryTree<Treeable>> forest = toForest(null);
        assertThat(forest).isEmpty();
    }

    @Test
    public void toForestOfEmpty() throws Exception {
        final List<QueryTree<Treeable>> forest = toForest(emptyList());
        assertThat(forest).isEmpty();
    }

    @Test
    public void toForestOfALocation() throws Exception {
        final Location l = toLocation("", "");
        final List<QueryTree<Treeable>> forest = toForest(singletonList(l));
        assertThat(forest.get(0).getSelf()).isEqualTo(l);
    }

    @Test
    public void toForestOf2SiblingLocations() throws Exception {
        final Location a = toLocation("a", "1/2");
        final Location b = toLocation("b", "1/3");

        final List<QueryTree<Treeable>> forest = toForest(asList(b, a));

        assertThat(forest.get(0).getSelf()).isEqualTo(a);
        assertThat(forest.get(1).getSelf()).isEqualTo(b);
    }

    @Test
    public void toForestOfParentAndChildLocations() throws Exception {
        final Location a = toLocation("a", "1/2");
        final Location b = toLocation("b", "1/2/3");

        final List<QueryTree<Location>> forest = toForest(asList(b, a));

        final QueryTree<Location> parentTree = forest.get(0);
        assertThat(parentTree.getSelf()).isEqualTo(a);
        final List<QueryTree<Location>> children = toChildren(parentTree);
        assertThat(children.get(0).getSelf()).isEqualTo(b);
    }

    @Test
    public void toForestOfParentAnd2ChildrenLocations() throws Exception {
        final Location a = toLocation("a", "1/2");
        final Location b = toLocation("b", "1/2/3");
        final Location c = toLocation("c", "1/2/4");

        final List<QueryTree<Location>> forest = toForest(asList(c, b, a));

        final QueryTree<Location> parentTree = forest.get(0);
        assertThat(parentTree.getSelf()).isEqualTo(a);
        final List<QueryTree<Location>> children = toChildren(parentTree);
        assertThat(children.get(0).getSelf()).isEqualTo(b);
        assertThat(children.get(1).getSelf()).isEqualTo(c);
    }

    @Test
    public void toForestWithLimitParentLevelIs0() throws Exception {
        final Location a = toLocation("a", "1");
        final Location b = toLocation("b", "1/2");
        final Location c = toLocation("c", "1/2/3");
        final Location d = toLocation("d", "1/2/3/4");
        TreeAid.LIMIT_PARENT_LEVEL_SEARCH = 0;

        final List<QueryTree<Location>> forest = toForest(asList(d, c, b, a));

        final QueryTree<Location> aTree = forest.get(0);
        assertThat(aTree.getSelf()).isEqualTo(a);
        final QueryTree<Location> bTree = firstChild(aTree);
        assertThat(bTree.getSelf()).isEqualTo(b);
        final QueryTree<Location> cTree = firstChild(bTree);
        assertThat(cTree.getSelf()).isEqualTo(c);
        assertThat(firstChild(cTree).getSelf()).isEqualTo(d);
    }

    @Test
    public void toForestWithLimitParentLevelIs2() throws Exception {
        final Location a = toLocation("a", "1");
        final Location b = toLocation("b", "1/2/3/4");
        final Location c = toLocation("c", "1/2/3/4/7");
        final Location x = toLocation("x", "1/2/3/5/6");
        TreeAid.LIMIT_PARENT_LEVEL_SEARCH = 2;

        final List<QueryTree<Location>> forest = toForest(asList(x, c, b, a));

        final QueryTree<Location> aTree = forest.get(0);
        assertThat(aTree.getSelf()).isEqualTo(a);
        final QueryTree<Location> bTree = firstChild(aTree);
        assertThat(bTree.getSelf()).isEqualTo(b);
        assertThat(firstChild(bTree).getSelf()).isEqualTo(c);

        assertThat(forest.get(1).getSelf()).isEqualTo(x);
    }

    @Test
    public void toForestOfParentAndGrandchildLocations() throws Exception {
        final Location a = toLocation("a", "1/2");
        final Location b = toLocation("b", "1/2/3/4");

        final List<QueryTree<Location>> forest = toForest(asList(b, a));

        final QueryTree<Location> parentTree = forest.get(0);
        assertThat(parentTree.getSelf()).isEqualTo(a);
        final List<QueryTree<Location>> children = toChildren(parentTree);
        assertThat(children.get(0).getSelf()).isEqualTo(b);
    }

    @Test
    public void toForestOfMvadiEpidemicZoneLocations() throws Exception {
        final String gabPath = "544694/542919/558309/558292/157";
        final Location gab = toLocation("Gabon", gabPath);
        final Location mvadi = toLocation("Mvadi", gabPath + "/161/189/85140");

        final List<QueryTree<Location>> forest = toForest(asList(mvadi, gab));

        final QueryTree<Location> parentTree = forest.get(0);
        assertThat(parentTree.getSelf()).isEqualTo(gab);
        final List<QueryTree<Location>> children = toChildren(parentTree);
        assertThat(children.get(0).getSelf()).isEqualTo(mvadi);
    }

    private static QueryTree<Location> firstChild(QueryTree<Location> t) {
        return toChildren(t).get(0);
    }

    private static List<QueryTree<Location>> toChildren(QueryTree<Location> t) {
        return new ArrayList(t.getChildren());
    }

    private static Location toLocation(String name, String path) {
        final Location l = new Location();
        l.setName(name);
        l.setPath(path);
        return l;
    }
}
