package edu.pitt.isg.dc.entry;


import edu.pitt.isg.dc.entry.impl.Datastore;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;

import java.math.BigInteger;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import static edu.pitt.isg.dc.entry.Keys.ENTRY;
import static edu.pitt.isg.dc.entry.Keys.HOST_SPECIES;
import static edu.pitt.isg.dc.entry.Keys.IS_ABOUT;
import static edu.pitt.isg.dc.entry.Keys.PATHOGEN_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PROPERTIES;
import static edu.pitt.isg.dc.entry.Keys.TYPE;
import static edu.pitt.isg.dc.entry.Values.APPROVED;
import static edu.pitt.isg.dc.entry.Values.DATASET_2_2;
import static edu.pitt.isg.dc.entry.Values.DATA_FORMAT_CONVERTERS1_0;
import static edu.pitt.isg.dc.entry.Values.DTM_1_0;
import static edu.pitt.isg.dc.entry.Values.PATH_SEPARATOR;
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
    private static final String KEY_IDENTIFIER = "identifier";
    private static final long humanId = 9606;
    private static final long hostRootId = 33208;
    private static final long ebolaId = 1570291;
    private static final long ebolaZaireId = 128951;
    private static Long entryCount = null;
    private static Long ncbiCount = null;

    @Autowired
    private Datastore datastore;
    @Autowired
    private EntryRepository entryRepo;
    @Autowired
    private NcbiRepository ncbiRepo;
    @Autowired
    private EntryRule entryRule;
    @Autowired
    private TypeRule typeRule;

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
    public void allApprovedEntries() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        final Page<Entry> page = entryRule.findViaOntology(q, null);

        assertAllElementsIn1Page(page);
        assertThat(page).allSatisfy(this::assertStatusIsApproved);
    }

    @Test
    public void allTypes() throws Exception {
        final List<String> all = typeRule.findAll();
        assertThat(all).containsExactlyInAnyOrder(DATASET_2_2, DATA_FORMAT_CONVERTERS1_0, DTM_1_0);
    }

    @Test
    public void matchSoftware() throws Exception {
        final List<List<BigInteger>> lists = entryRepo.matchSoftware();
        assertThat(lists.size()).isGreaterThan(0);
    }

    @Test
    public void entriesWithHumanAsHost() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setHostId(humanId);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

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
        q.setPathogenId(ebolaId);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .anySatisfy(this::assertTypeIsDataset)
                .anySatisfy(this::assertTypeIsDTM)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    @Test
    public void entriesWithHostAndPathogenAndType() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setHostId(humanId);
        q.setPathogenId(ebolaId);
        q.setType(DTM_1_0);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDTM)
                .allSatisfy(this::assertBaseOnTypeForHumanAsHost)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    @Test
    public void entriesDataset() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setType(DATASET_2_2);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDataset);
    }

    private void assertAllElementsIn1Page(Page<Entry> page) {
        final int totalElements = (int)page.getTotalElements();
        assertThat(totalElements).isGreaterThan(0);
        assertThat(page.getNumberOfElements()).isEqualTo(totalElements);
    }

    private void assertBaseOnTypeForHumanAsHost(Entry e) {
        Map<String, Consumer<Map<String, Object>>> map = new HashMap<>();
        map.put(DTM_1_0, this::assertHumanDtm);
        map.put(DATASET_2_2, this::assertHumanDataset);
        assertBaseOnType(e, map);
    }

    private void assertBaseOnTypeForEbolaAsPathogen(Entry e) {
        Map<String, Consumer<Map<String, Object>>> map = new HashMap<>();
        map.put(DTM_1_0, this::assertEbolaDtm);
        map.put(DATASET_2_2, this::assertEbolaDataset);
        assertBaseOnType(e, map);
    }

    private void assertBaseOnType(Entry e, Map<String, Consumer<Map<String, Object>>> map) {
        final Map<String, Object> content = toContent(e);
        final Map<String, Object> properties = getMap(content, PROPERTIES);
        final String type = properties.get(TYPE).toString();
        final Map<String, Object> entry = getMap(content, ENTRY);
        map.get(type).accept(entry);
    }

    private void assertEbolaDtm(Map<String, Object> entry) {
        assertThat(getList(entry, PATHOGEN_COVERAGE)).anySatisfy(this::assertEbolaIdentifiers);
    }

    private void assertEbolaDataset(Map<String, Object> entry) {
        assertThat(getList(entry, IS_ABOUT)).anySatisfy(this::assertEbolaIdentifiers);
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
        final String parentPath = parent == null ? "" : parent.getPath() + PATH_SEPARATOR;
        ncbi.setPath(parentPath + id);
        ncbi.setLeaf(leaf);
        ncbi.setParent(parent);
        return ncbi;
    }

    private void assertStatusIsApproved(Entry e) {
        assertThat(e.getStatus()).isEqualToIgnoringCase(APPROVED);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> toContent(Entry e) {
        return (Map<String, Object>) e.getContent();
    }

    private void assertHumanDtm(Map<String, Object> entry) {
        assertThat(getList(entry, HOST_SPECIES)).anySatisfy(this::assertHumanIdentifier);
    }

    private void assertHumanDataset(Map<String, Object> entry) {
        assertThat(getList(entry, IS_ABOUT)).anySatisfy(this::assertHumanIdentifier);
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
        assertType(entry, DTM_1_0);
    }

    private void assertTypeIsDataset(Entry entry) {
        assertType(entry, DATASET_2_2);
    }

    private void assertType(Entry entry, String expected) {
        final Map<String, Object> content = toContent(entry);
        final Map<String, Object> properties = getMap(content, PROPERTIES);
        assertThat(properties.get(TYPE)).isEqualTo(expected);
    }
}
