package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.vm.QueryTree;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static edu.pitt.isg.dc.entry.util.TreeAid.toForest;
import static java.util.Arrays.asList;
import static org.assertj.core.api.Assertions.assertThat;


public class NcbiTreeTest {
    private Ncbi a5;
    private Ncbi b3;
    private Ncbi ac;
    private Ncbi ad;
    private Ncbi acf;
    private Ncbi acg;

    @Before
    public void setUp() throws Exception {
        a5 = fill(5, "a", null);
        b3 = fill(3, "b", null);
        ac = fill(55, "c", a5);
        ad = fill(51, "d", a5);
        acf = fill(557, "f", ac);
        acg = fill(559, "g", ac);
    }

    private Ncbi fill(long id, String name, Ncbi parent) {
        final Ncbi ncbi = new Ncbi();
        ncbi.setId(id);
        String parentPath = toParentPath(parent);
        ncbi.setPath(parentPath + "/" + id);
        ncbi.setName(name);
        return ncbi;
    }

    private String toParentPath(Ncbi parent) {
        if (parent == null)
            return "1";
        return parent.getPath();
    }

    @Test
    public void nullInput() throws Exception {
        final List<QueryTree<Ncbi>> tree = toForest(null);
        assertThat(tree).isEmpty();
    }

    @Test
    public void emptyInput() throws Exception {
        final List<QueryTree<Ncbi>> tree = toForest(Collections.emptyList());
        assertThat(tree).isEmpty();
    }

    @Test
    public void oneInput() throws Exception {
        final List<QueryTree<Ncbi>> tree = toForest(Collections.singletonList(a5));
        assertThat(tree).isNotEmpty();
        assertThat(tree.get(0).getSelf()).isEqualTo(a5);
    }

    @Test
    public void twoInputs() throws Exception {
        final List<QueryTree<Ncbi>> tree = toForest(asList(a5, b3));
        assertThat(tree).isNotEmpty();
        assertThat(tree.get(0).getSelf()).isEqualTo(a5);
        assertThat(tree.get(1).getSelf()).isEqualTo(b3);
    }

    @Test
    public void treeA() throws Exception {
        final List<QueryTree<Ncbi>> tree = toForest(asList(a5, ad, ac, acf, acg));
        assertThat(tree).isNotEmpty();
        final QueryTree treeA = tree.get(0);
        assertThat(treeA.getSelf()).isEqualTo(a5);
        final QueryTree treeAc = toChildList(treeA).get(0);
        assertThat(treeAc.getSelf()).isEqualTo(ac);
        final List<QueryTree> aChildren = toChildList(treeA);
        assertThat(aChildren.get(1).getSelf()).isEqualTo(ad);
        final List<QueryTree> acChildren = toChildList(treeAc);
        assertThat(acChildren.get(0).getSelf()).isEqualTo(acf);
        assertThat(acChildren.get(1).getSelf()).isEqualTo(acg);
    }

    private List<QueryTree> toChildList(QueryTree tree) {
        return new ArrayList<>(tree.getChildren());
    }

}
