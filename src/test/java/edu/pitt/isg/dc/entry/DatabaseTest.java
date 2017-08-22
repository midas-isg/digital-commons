package edu.pitt.isg.dc.entry;


import com.google.gson.Gson;
import edu.pitt.isg.dc.entry.impl.Datastore;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import edu.pitt.isg.dc.vm.EntryOntologyQuery;
import edu.pitt.isg.dc.vm.MatchedSoftware;
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
import java.util.stream.Collectors;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;
import static edu.pitt.isg.dc.entry.Keys.ENTRY;
import static edu.pitt.isg.dc.entry.Keys.HOST_SPECIES;
import static edu.pitt.isg.dc.entry.Keys.IS_ABOUT;
import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PATHOGEN_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PROPERTIES;
import static edu.pitt.isg.dc.entry.Keys.TYPE;
import static edu.pitt.isg.dc.entry.Values.APPROVED;
import static edu.pitt.isg.dc.entry.Values.DATASET_2_2;
import static edu.pitt.isg.dc.entry.Values.DATA_FORMAT_CONVERTERS1_0;
import static edu.pitt.isg.dc.entry.Values.DTM_1_0;
import static edu.pitt.isg.dc.entry.Values.PATH_SEPARATOR;
import static java.util.Arrays.asList;
import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest // TODO should replace with @DataJpaTest to run faster.
@TestPropertySource(properties = {
        "app.identifierSource.ncbi=https://biosharing.org/bsg-s000154",
        "app.identifierSource.ls=https://biosharing.org/bsg-s000708",
        "app.identifierSource.sv=https://biosharing.org/bsg-s002688",
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
    private static final long usaId = 1216;
    private static final String QuarantineIri = "http://purl.obolibrary.org/obo/APOLLO_SV_00000327";
    private static Long entryCount = null;
    private static Long ncbiCount = null;
    private static Long asvCount = null;
    private static final List<String> asvList = asList("123", "231", "286", "308", "327", "328", "390");


    @Autowired
    private Datastore datastore;
    @Autowired
    private EntryRepository entryRepo;
    @Autowired
    private NcbiRepository ncbiRepo;
    @Autowired
    private AsvRepository asvRepo;
    @Autowired
    private EntryRule entryRule;
    @Autowired
    private TypeRule typeRule;
    @Autowired
    private AsvRule asvRule;
    @Autowired
    private LsRule lsRule;

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
    public void fillAsv() throws Exception {
        if (asvCount != null)
            return;
        asvRepo.deleteAllInBatch();

        final String last3digit = "086";
        final String rIri = toAsvIri(last3digit);
        final Asv root = saveAsv(rIri, null, false);
        asvList.forEach(s -> saveAsv(toAsvIri(s), rIri, true));
        asvCount = asvRepo.count();
    }

    private String toAsvIri(String last3digit) {
        final String prefix = "http://purl.obolibrary.org/obo/APOLLO_SV_00000";
        return prefix + last3digit;
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

    private Asv saveAsv(String iri, String parentAncestors, boolean leaf) {
        final Asv e = toAsv(iri, parentAncestors, leaf);
        asvRepo.save(e);
        return e;
    }

    private Asv toAsv(String iri, String parentAncestors, boolean leaf) {
        final Asv asv = new Asv();
        asv.setIri(iri);
        final String parentPath = parentAncestors == null ? "" : parentAncestors + ",";
        asv.setAncestors(parentPath + iri);
        asv.setLeaf(leaf);
        return asv;
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
    public void allControlMeasures() throws Exception {
        final List<String> all = asvRule.listAsvIdsAsControlMeasureInEntries();
        assertThat(all).containsExactlyInAnyOrder(asvList.stream()
                .map(this::toAsvIri)
                .collect(Collectors.toList()).toArray(new String[asvList.size()]));
    }

    @Test
    public void allLocations() throws Exception {
        final List<String> all = lsRule.listlsIdsAsLocationInEntries();
        assertThat(all).containsExactlyInAnyOrder("11", "1216", "366188", "510873", "542924", "544694");
    }

    @Test
    public void allTypes() throws Exception {
        final List<String> all = typeRule.findAll();
        assertThat(all).containsExactlyInAnyOrder(DATASET_2_2, DATA_FORMAT_CONVERTERS1_0, DTM_1_0);
    }

    @Test
    public void matchSoftware() throws Exception {
        final List<MatchedSoftware> list = entryRule.listSoftwareMatched();

        assertThat(list.size()).isGreaterThan(0);
        assertThat(list).allSatisfy(this::assertMatchSoftware);
    }

    public void assertMatchSoftware(MatchedSoftware m) {
        assertThat(m.getSourceSoftwareName()).isNotEmpty();
        assertThat(m.getSinkSoftwareName()).isNotEmpty();
        final String linkDataFormatName = m.getLinkDataFormatName();
        assertThat(linkDataFormatName).isNotEmpty();
        final String[] formats = fromJsonToStringArray(linkDataFormatName);
        assertThat(formats)
                .isNotEmpty()
                .allSatisfy(f -> assertThat(f).isNotEmpty());
    }

    private static String[] fromJsonToStringArray(String linkDataFormatName) {
        return new Gson().fromJson(linkDataFormatName, String[].class);
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
                .anySatisfy(this::assertTypeIsDtm)
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
                .anySatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    @Test
    public void entriesQuarantineAsControlMeasure() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setControlMeasureId(QuarantineIri);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertQuarantineDtm);
    }

    @Test
    public void entriesUsaAsLocation() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setLocationId(usaId);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .anySatisfy(this::assertTypeIsDataset)
                .anySatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertBaseOnTypeForUsaAsLocation);
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
                .allSatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertBaseOnTypeForHumanAsHost)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    @Test
    public void entriesWithControlMeasureAndLocation() throws Exception {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setControlMeasureId(QuarantineIri);
        q.setLocationId(usaId);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertQuarantineDtm)
                .allSatisfy(this::assertBaseOnTypeForUsaAsLocation);
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

    private void assertBaseOnTypeForUsaAsLocation(Entry e) {
        Map<String, Consumer<Map<String, Object>>> map = new HashMap<>();
        map.put(DTM_1_0, this::assertUsaDtm);
        map.put(DATASET_2_2, this::assertUsaDataset);
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

    private void assertQuarantineDtm(Entry entry) {
        final Map<String, Object> content = toContent(entry);
        final List<Object> list = getList(getMap(content, ENTRY), CONTROL_MEASURES);
        assertThat(list).anySatisfy(this::assertQuarantineIdentifiers);
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

    private void assertQuarantineIdentifiers(Object o) {
        assertIdentifier(o, QuarantineIri);
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

    private void assertUsaDtm(Map<String, Object> entry) {
        assertThat(getList(entry, LOCATION_COVERAGE)).anySatisfy(this::assertUsaIdentifier);
    }

    private void assertUsaDataset(Map<String, Object> entry) {
        assertThat(getList(entry, "spatialCoverage")).anySatisfy(this::assertUsaIdentifier);
    }

    private void assertHumanIdentifier(Object o) {
        assertIdentifier(o, humanId + "");
    }

    private void assertUsaIdentifier(Object o) {
        assertIdentifier(o, "1216");
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

    private void assertTypeIsDtm(Entry entry) {
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
