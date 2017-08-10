package edu.pitt.isg.dc.entry;


import edu.pitt.isg.dc.entry.impl.Datastore;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;

import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest // TODO should replace with @DataJpaTest to run faster.
@TestPropertySource(properties = {
        "app.identifierSource.ncbi=https://biosharing.org/bsg-s000154",
        "app.identifierSource.ls=https://biosharing.org/bsg-s000708",
        "app.ncbi.host.root.path=1/33208",

        "spring.datasource.url=jdbc:postgresql://localhost:54320/mdc?currentSchema=test",
        "spring.jpa.hibernate.ddl-auto=create"
})
public class DatabaseTest {
    private static final String KEY_ENTRY = "entry";
    private static final String KEY_IDENTIFIER = "identifier";
    private static final String KEY_PROPERTIES = "properties";
    private static final String KEY_TYPE = "type";
    private static final String VALUE_DATASET = "edu.pitt.isg.mdc.dats2_2.Dataset";
    private static final String VALUE_DTM = "edu.pitt.isg.mdc.v1_0.DiseaseTransmissionModel";
    private static final long humanId = 9606;
    private static final long hostRootId = 33208;
    private static final long ebolaId = 1570291;
    private static final long ebolaZaireId = 128951;
    public static final String KEY_IS_ABOUT = "isAbout";
    private static Long entryCount = null;
    private static Long ncbiCount = null;

    @Autowired
    private Datastore datastore;
    @Autowired
    private EntryRepository entryRepo;
    @Autowired
    private NcbiRepository ncbiRepo;
    @Autowired
    private EntryRule rule;

    @BeforeClass
    public static void changePath() {
        final String projectPath = projectPath();
        final String testResPath = projectPath + "/src/test/resources";
        final String entryPath = testResPath + "/entries";
        EntryHelper.setEntriesFilepath(entryPath);
    }

    private static String projectPath() {
        final URL url = DatabaseTest.class.getResource(".");
        return url.getPath().split("/target/")[0];
    }

    @Before
    public void fillEntries() throws Exception {
        if (entryCount != null)
            return;
        entryRepo.deleteAllInBatch();
        new PopulateDatastore(datastore).populate();
        entryCount = entryRepo.count();
    }

    @Before
    public void fillNcbi() throws Exception {
        if (ncbiCount != null)
            return;
        ncbiRepo.deleteAllInBatch();
        final Ncbi root = saveNcbi(1L, null, false);
        final Ncbi host = saveNcbi(hostRootId, root, false);
        saveNcbi(humanId, host, true);
        final Ncbi ebola = saveNcbi(ebolaId, root, false);
        saveNcbi(ebolaZaireId, ebola, true);
        ncbiCount = ncbiRepo.count();
    }

    @Test
    public void testDump() throws Exception {
        EntryHelper.setEntriesFilepath(projectPath() + "/target/tmp/entries");
        datastore.exportDatastore(MdcDatastoreFormat.MDC_DATA_DIRECTORY_FORMAT);
    }

    @Test
    public void allEntries() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        final Page<Entry> page = rule.findViaOntology(q, null);

        assertAllElementsIn1Page(page);
        assertThat(page).allSatisfy(this::assertStatusIsApproved);
    }

    public void assertAllElementsIn1Page(Page<Entry> page) {
        final int totalElements = (int)page.getTotalElements();
        assertThat(totalElements).isGreaterThan(0);
        assertThat(page.getNumberOfElements()).isEqualTo(totalElements);
    }

    @Test
    public void entriesWithHumanAsHost() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setHostNcbiId(humanId);
        final Page<Entry> entries = rule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .anySatisfy(this::assertTypeIsDataset)
                .anySatisfy(this::assertTypeIsDTM)
                .allSatisfy(this::assertBaseOnTypeForHumanAsHost);
    }

    @Test
    public void entriesEbolaAsPathogen() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setPathogenNcbiId(ebolaId);
        final Page<Entry> entries = rule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .anySatisfy(this::assertTypeIsDataset)
                .anySatisfy(this::assertTypeIsDTM)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    @Test
    public void entriesWithHostAndPathogen() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setHostNcbiId(humanId);
        q.setPathogenNcbiId(ebolaId);
        final Page<Entry> entries = rule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                // .anySatisfy(this::assertTypeIsDataset)
                .allSatisfy(this::assertTypeIsDTM)
                .allSatisfy(this::assertBaseOnTypeForHumanAsHost)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    private void assertBaseOnTypeForHumanAsHost(Entry e) {
        Map<String, Consumer<Map<String, Object>>> map = new HashMap<>();
        map.put(VALUE_DTM, this::assertHumanDtm);
        map.put(VALUE_DATASET, this::assertHumanDataset);
        assertBaseOnType(e, map);
    }

    private void assertBaseOnTypeForEbolaAsPathogen(Entry e) {
        Map<String, Consumer<Map<String, Object>>> map = new HashMap<>();
        map.put(VALUE_DTM, this::assertEbolaDtm);
        map.put(VALUE_DATASET, this::assertEbolaDataset);
        assertBaseOnType(e, map);
    }

    private void assertBaseOnType(Entry e, Map<String, Consumer<Map<String, Object>>> map) {
        final Map<String, Object> content = toContent(e);
        final Map<String, Object> properties = getMap(content, KEY_PROPERTIES);
        final String type = properties.get(KEY_TYPE).toString();
        final Map<String, Object> entry = getMap(content, KEY_ENTRY);
        map.get(type).accept(entry);
    }

    private void assertEbolaDtm(Map<String, Object> entry) {
        assertThat(getList(entry, "pathogenCoverage")).anySatisfy(this::assertEbolaIdentifiers);
    }

    private void assertEbolaDataset(Map<String, Object> entry) {
        assertThat(getList(entry, KEY_IS_ABOUT)).anySatisfy(this::assertEbolaIdentifiers);
    }

    private void assertEbolaIdentifiers(Object o) {
        assertIdentifier(o, ebolaId + "", ebolaZaireId + "");
    }

    private Ncbi saveNcbi(long id, Ncbi parent, boolean leaf) {
        final Ncbi ncbi = toNcbi(id, parent, leaf);
        ncbiRepo.save(ncbi);
        return ncbi;
    }

    private Ncbi toNcbi(long id, Ncbi parent, boolean leaf) {
        final Ncbi ncbi = new Ncbi();
        ncbi.setId(id);
        final String parentPath = parent == null ? "" : parent.getPath() + "/";
        ncbi.setPath(parentPath + id);
        ncbi.setLeaf(leaf);
        ncbi.setParent(parent);
        return ncbi;
    }

    public void assertStatusIsApproved(Entry e) {
        assertThat(e.getStatus()).isEqualToIgnoringCase("approved");
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> toContent(Entry e) {
        return (Map<String, Object>) e.getContent();
    }

    private void assertHumanDtm(Map<String, Object> entry) {
        assertThat(getList(entry, "hostSpeciesIncluded")).anySatisfy(this::assertHumanIdentifier);
    }

    private void assertHumanDataset(Map<String, Object> entry) {
        assertThat(getList(entry, KEY_IS_ABOUT)).anySatisfy(this::assertHumanIdentifier);
    }

    private void assertHumanIdentifier(Object o) {
        assertIdentifier(o, humanId + "");
    }

    private void assertIdentifier(Object o, String... expects) {
        final Map<String, Object> identifier = getMap(o, KEY_IDENTIFIER);
        assertThat(identifier.get(KEY_IDENTIFIER)).isIn(expects);
    }

    @SuppressWarnings("unchecked")
    private List<Object> getList(Map<String, Object> entry, String key) {
        return (List<Object>)entry.get(key);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> getMap(Object map, String key) {
        return (HashMap<String, Object>)((HashMap<String, Object>)map).get(key);
    }

    private void assertTypeIsDTM(Entry entry) {
        assertType(entry, VALUE_DTM);
    }

    private void assertTypeIsDataset(Entry entry) {
        assertType(entry, VALUE_DATASET);
    }

    private void assertType(Entry entry, String expected) {
        final Map<String, Object> content = toContent(entry);
        final Map<String, Object> properties = getMap(content, KEY_PROPERTIES);
        assertThat(properties.get(KEY_TYPE)).isEqualTo(expected);
    }
}
