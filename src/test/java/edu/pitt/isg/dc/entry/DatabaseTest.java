package edu.pitt.isg.dc.entry;


import com.google.gson.Gson;
import edu.pitt.isg.dc.entry.impl.Datastore;
import edu.pitt.isg.dc.entry.impl.MdcDatastoreFormat;
import edu.pitt.isg.dc.entry.util.EntryHelper;
import edu.pitt.isg.dc.vm.EntryComplexQuery;
import edu.pitt.isg.dc.vm.EntrySimpleQuery;
import edu.pitt.isg.dc.vm.MatchedSoftware;
import edu.pitt.isg.dc.vm.OntologyQuery;
import org.assertj.core.api.IterableAssert;
import org.assertj.core.api.ListAssert;
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
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Consumer;
import java.util.stream.Collectors;

import static edu.pitt.isg.dc.entry.Keys.CONTROL_MEASURES;
import static edu.pitt.isg.dc.entry.Keys.ENTRY;
import static edu.pitt.isg.dc.entry.Keys.HOST_SPECIES;
import static edu.pitt.isg.dc.entry.Keys.IS_ABOUT;
import static edu.pitt.isg.dc.entry.Keys.LOCATION_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PATHOGEN_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.PROPERTIES;
import static edu.pitt.isg.dc.entry.Keys.SPATIAL_COVERAGE;
import static edu.pitt.isg.dc.entry.Keys.TYPE;
import static edu.pitt.isg.dc.entry.Values.APPROVED;
import static edu.pitt.isg.dc.entry.Values.DATASET_2_2;
import static edu.pitt.isg.dc.entry.Values.DATA_FORMAT_CONVERTERS1_0;
import static edu.pitt.isg.dc.entry.Values.DTM_1_0;
import static edu.pitt.isg.dc.entry.Values.PATH_SEPARATOR;
import static java.util.Arrays.asList;
import static java.util.Collections.singleton;
import static java.util.Collections.singletonList;
import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest // TODO should replace with @DataJpaTest to run faster.
@TestPropertySource(properties = {
        "app.identifierSource.ncbi=https://biosharing.org/bsg-s000154",
        "app.identifierSource.ls=https://biosharing.org/bsg-s000708",
        "app.identifierSource.sv=https://biosharing.org/bsg-s002688",
        "app.ncbi.host.root.path=1/33208",

        "spring.datasource.url=jdbc:postgresql://localhost:54320/mdc?currentSchema=test",
        "spring.datasource.username=dev",
        "spring.datasource.password=dev",
        "spring.jpa.hibernate.ddl-auto=create"
})
public class DatabaseTest {
    private static final String KEY_IDENTIFIER = "identifier";
    private static final long rootId = 1L;
    private static final long humanId = 9606;
    private static final long hostRootId = 33208;
    private static final long ebolaId = 1570291;
    private static final long ebolaZaireId = 128951;
    private static final long usaAlc = 1216;
    private static final long laAlc = 366188;
    private static final String laId = laAlc + "";
    private static final String seattleId = "510873";
    private static final String earthId = "544694";
    private static final String rootIri = toAsvIri("086");
    private static final String quarantineIri = "http://purl.obolibrary.org/obo/APOLLO_SV_00000327";
    private static final String vectorIri = "http://purl.obolibrary.org/obo/APOLLO_SV_00000308";
    private static final String wolbachiaVectorIri = "http://purl.obolibrary.org/obo/APOLLO_SV_00000390";
    private static Long entryCount = null;
    private static Long ncbiCount = null;
    private static Long asvCount = null;
    private static Long lsCount = null;
    private static final List<String> usaIds = asList(usaAlc + "", seattleId, laId, earthId);
    private static final List<String> asvList = asList("123", "231", "286", "308", "327", "328");


    @Autowired
    private Datastore datastore;
    @Autowired
    private EntryRepository entryRepo;
    @Autowired
    private NcbiRepository ncbiRepo;
    @Autowired
    private AsvRepository asvRepo;
    @Autowired
    private LocationRepository lsRepo;
    @Autowired
    private EntryRule entryRule;
    @Autowired
    private TypeRule typeRule;
    @Autowired
    private AsvRule asvRule;
    @Autowired
    private LocationRule lsRule;
    @Autowired
    private NcbiRule ncbiRule;

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

        saveAsv(rootIri, null, false);
        asvList.forEach(s -> saveAsv(toAsvIri(s), rootIri, true));
        final Asv vector = new ArrayList<>(asvRepo.findByIriIn(singleton(vectorIri))).get(0);
        vector.setLeaf(false);
        saveAsv(wolbachiaVectorIri, vectorIri, true);
        asvCount = asvRepo.count();
    }

    @Before
    public void fillLsCache() throws Exception {
        if (lsCount != null)
            return;
        lsRepo.deleteAllInBatch();
        fillLsMap().forEach(this::saveLocation);
    }

    private static Map<Long, List<String>> fillLsMap() {
        long earthId = 544694;
        final String prefix = earthId + ",";
        final String path = earthId + "";

        final Map<Long, List<String>> map = new HashMap<>();
        final long usaId = 1216L;
        final String usaPrefix = prefix + usaId + ",";
        final String usaPath = path + "/" + usaId;
        map.put(366188L, asList("Los Angeles", "Populated Place", usaPrefix + "366188", usaPath + "/366188"));
        map.put(510873L, asList("Seattle", "Populated Place", usaPrefix + "510873", usaPath + "/510873"));
        map.put(usaId, asList("USA", "Country", prefix + toAllRelativeCsv(map), usaPath));
        map.put(11L, asList("Sierra Leone", "Country", prefix + "11", path + "/11"));
        map.put(542924L, asList("Cairns", "City", prefix + "542924", path + "/542924"));
        map.put(85164L, asList("Kikwit", "Epidemic Zone", prefix + "85164", path + "/85164"));
        map.put(earthId, asList("Earth", "Planet", toAllRelativeCsv(map), path));
        return map;
    }

    private static String toAllRelativeCsv(Map<Long, List<String>> map) {
        final Set<String> ids = map.keySet().stream()
                .map(Object::toString)
                .collect(Collectors.toSet());
        return String.join(",", ids);
    }

    private void saveLocation(long id, List<String> v) {
        final Location l = new Location();
        l.setId(id);
        l.setName(v.get(0));
        l.setLocationTypeName(v.get(1));
        l.setRelatives(v.get(2));
        l.setPath(v.get(3));
        lsRepo.save(l);
    }

    private static String toAsvIri(String last3digit) {
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
        final EntrySimpleQuery q = new EntrySimpleQuery();
        final Page<Entry> page = entryRule.findViaOntology(q, null);

        assertAllElementsIn1Page(page);
        assertThat(page).allSatisfy(this::assertStatusIsApproved);
    }

    @Test
    public void allControlMeasures() throws Exception {
        final Set<String> all = asvRule.listAsvIrisAsControlMeasureInEntries();
        final List<String> expected = new ArrayList<>(asvList);
        expected.add("390");
        assertThat(all).containsExactlyInAnyOrder(expected.stream()
                .map(DatabaseTest::toAsvIri)
                .collect(Collectors.toList()).toArray(new String[expected.size()]));
    }

    @Test
    public void allLocations() throws Exception {
        final List<Location> all = lsRule.findLocationsInEntries();
        final Set<String> set = all.stream()
                .map(Location::getId)
                .map(Object::toString)
                .collect(Collectors.toSet());
        final Set<String> expects = new HashSet<>(usaIds);
        expects.addAll(asList("11", "85164", "542924"));
        assertContainsExactlyInAnyOrder(set,expects);
    }

    @Test
    public void allTypes() throws Exception {
        final List<String> all = typeRule.findAll();
        final List<String> expects = asList(DATASET_2_2, DATA_FORMAT_CONVERTERS1_0, DTM_1_0);
        assertContainsExactlyInAnyOrder(all, expects);
    }

    @Test
    public void matchSoftware() throws Exception {
        final List<MatchedSoftware> list = entryRule.listSoftwareMatched();

        assertThat(list.size()).isGreaterThan(0);
        assertThat(list).allSatisfy(this::assertMatchSoftware);
    }

    @Test
    public void entriesWithHumanAsHost() throws Exception {
        final EntrySimpleQuery q = new EntrySimpleQuery();
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
        final EntryComplexQuery q = new EntryComplexQuery();
        final OntologyQuery<Long> ebola = new OntologyQuery<>(ebolaId);
        q.setPathogens(singletonList(ebola));
        testEntriesEbolaAndDescendantsAsPathogen(q);
    }

    @Test
    public void entriesEbolaOnlyAsPathogen() throws Exception {
        final EntryComplexQuery q = new EntryComplexQuery();
        final OntologyQuery<Long> ebola = newOntologyQueryOnly(ebolaId);
        q.setPathogens(singletonList(ebola));
        testEntriesEbolaOnlyAsPathogen(q);
    }

    @Test
    public void entriesEbolaAndAncestorsAsPathogen() throws Exception {
        final EntryComplexQuery q = new EntryComplexQuery();
        final OntologyQuery<Long> ebola = newOntologyQueryOnly(ebolaId);
        ebola.setIncludeAncestors(true);
        q.setPathogens(singletonList(ebola));
        testEntriesEbolaOnlyAsPathogen(q);
    }

    @Test
    public void entriesEbolaAndDescendantsAsPathogen() throws Exception {
        final EntryComplexQuery q = new EntryComplexQuery();
        final OntologyQuery<Long> ebola = newOntologyQueryOnly(ebolaId);
        ebola.setIncludeDescendants(true);
        q.setPathogens(singletonList(ebola));
        testEntriesEbolaAndDescendantsAsPathogen(q);
    }

    @Test
    public void entriesQuarantineAsControlMeasure() throws Exception {
        final EntrySimpleQuery q = new EntrySimpleQuery();
        q.setControlMeasureId(quarantineIri);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertQuarantineDtm);
    }

    @Test
    public void entriesAllControlMeasures() throws Exception {
        final EntrySimpleQuery q = new EntrySimpleQuery();
        q.setControlMeasureId(rootIri);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDtm)
                .anySatisfy(this::assertQuarantineDtm);
    }

    @Test
    public void entriesUsaAsLocation() throws Exception {
        final EntrySimpleQuery q = new EntrySimpleQuery();
        q.setLocationId(usaAlc);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        final IterableAssert<Entry> entriesAssert = assertThat(entries);
        entriesAssert
                .allSatisfy(this::assertStatusIsApproved)
                .anySatisfy(this::assertTypeIsDataset)
                .anySatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertBaseOnTypeForUsaAsLocation);
        usaIds.stream()
                .forEach(id -> entriesAssert.anySatisfy(e -> assertDtmByLocation(e, id)));
    }

    @Test
    public void entriesWithHostAndPathogenAndType() throws Exception {
        final EntrySimpleQuery q = new EntrySimpleQuery();
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
        final EntrySimpleQuery q = new EntrySimpleQuery();
        q.setControlMeasureId(quarantineIri);
        q.setLocationId(usaAlc);
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
        final EntrySimpleQuery q = new EntrySimpleQuery();
        q.setType(DATASET_2_2);
        final Page<Entry> entries = entryRule.findViaOntology(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDataset);
    }

    @Test // @Ignore("LS is down")
    public void cacheLsZaire() throws Exception {
        final long zaireId = 4898;
        assertThat(lsRepo.findOne(zaireId)).isNull();
        lsRule.findAll(Collections.singleton(zaireId + ""));
        final Location zaire = lsRepo.findOne(zaireId);
        assertThat(zaire.getId()).isEqualTo(zaireId);
        assertThat(zaire.getPath()).endsWith("/" + zaireId);
        assertThat(zaire.getRelatives().split(",")).doesNotContain(zaireId + "");
    }

    @Test
    public void relevantIdentifiersForEbola() throws Exception {
        OntologyQuery<Long> q = new OntologyQuery<>(ebolaId);
        final Set<String> identifiers = ncbiRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(rootId + "", ebolaId + "", ebolaZaireId +"");
    }

    @Test
    public void relevantIdentifiersForEbolaOnly() throws Exception {
        OntologyQuery<Long> q = newOntologyQueryOnly(ebolaId);
        final Set<String> identifiers = ncbiRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(DatabaseTest.ebolaId + "");
    }

    @Test
    public void relevantIdentifiersForEbolaOrHumanOnly() throws Exception {
        OntologyQuery<Long> ebola = newOntologyQueryOnly(ebolaId);
        OntologyQuery<Long> human = newOntologyQueryOnly(humanId);

        final Set<String> identifiers = ncbiRule.toRelevantIdentifiers(asList(ebola, human));
        assertThat(identifiers).containsExactlyInAnyOrder(ebolaId + "", humanId + "");
    }

    @Test
    public void relevantIdentifiersForEbolaAndDescendants() throws Exception {
        OntologyQuery<Long> q = newOntologyQueryOnly(ebolaId);
        q.setIncludeDescendants(true);
        final Set<String> identifiers = ncbiRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(ebolaId + "", ebolaZaireId +"");
    }

    @Test
    public void relevantIdentifiersForEbolaAndAncestors() throws Exception {
        OntologyQuery<Long> q = newOntologyQueryOnly(ebolaId);
        q.setIncludeAncestors(true);
        final Set<String> identifiers = ncbiRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(rootId + "",ebolaId + "");
    }

    @Test
    public void relevantIdentifiersForUsa() throws Exception {
        OntologyQuery<Long> q = new OntologyQuery<>(usaAlc);
        final Set<String> identifiers = lsRule.toRelevantIdentifiers(singletonList(q));
        assertContainsExactlyInAnyOrder(identifiers, usaIds);
    }

    @Test
    public void relevantIdentifiersForUsaOnly() throws Exception {
        OntologyQuery<Long> q = newOntologyQueryOnly(usaAlc);
        final Set<String> identifiers = lsRule.toRelevantIdentifiers(singletonList(q));
        assertContainsExactlyInAnyOrder(identifiers, asList(usaAlc + ""));
    }

    @Test
    public void relevantIdentifiersForUsaAndAncestors() throws Exception {
        OntologyQuery<Long> q = newOntologyQueryOnly(usaAlc);
        q.setIncludeAncestors(true);
        final Set<String> identifiers = lsRule.toRelevantIdentifiers(singletonList(q));
        assertContainsExactlyInAnyOrder(identifiers, asList(usaAlc + "", earthId + ""));
    }

    @Test
    public void relevantIdentifiersForUsaAndDescendants() throws Exception {
        OntologyQuery<Long> q = newOntologyQueryOnly(usaAlc);
        q.setIncludeDescendants(true);
        final Set<String> identifiers = lsRule.toRelevantIdentifiers(singletonList(q));
        assertContainsExactlyInAnyOrder(identifiers, asList(usaAlc + "", laId, seattleId));
    }

    @Test
    public void relevantIdentifiersForUsaAndLaOnly() throws Exception {
        OntologyQuery<Long> usa = newOntologyQueryOnly(usaAlc);
        OntologyQuery<Long> la = newOntologyQueryOnly(laAlc);
        final Set<String> identifiers = lsRule.toRelevantIdentifiers(asList(usa, la));
        assertContainsExactlyInAnyOrder(identifiers, asList(usaAlc + "", laId));
    }
    @Test
    public void relevantIdentifiersForQuarantine() throws Exception {
        OntologyQuery<String> q = new OntologyQuery<>(quarantineIri);
        final Set<String> identifiers = asvRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(rootIri, quarantineIri);
    }


    @Test
    public void relevantIdentifiersForQuarantineOnly() throws Exception {
        OntologyQuery<String> q = newOntologyQueryOnly(quarantineIri);
        final Set<String> identifiers = asvRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(quarantineIri);
    }

    @Test
    public void relevantIdentifiersForQuarantineOrVectorOnly() throws Exception {
        OntologyQuery<String> quarantine = newOntologyQueryOnly(quarantineIri);
        OntologyQuery<String> vector = newOntologyQueryOnly(vectorIri);

        final Set<String> identifiers = asvRule.toRelevantIdentifiers(asList(quarantine, vector));
        assertThat(identifiers).containsExactlyInAnyOrder(quarantineIri, vectorIri);
    }

    @Test
    public void relevantIdentifiersForVectorAndDescendants() throws Exception {
        OntologyQuery<String> q = newOntologyQueryOnly(vectorIri);
        q.setIncludeDescendants(true);
        final Set<String> identifiers = asvRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(vectorIri, wolbachiaVectorIri);
    }

    @Test
    public void relevantIdentifiersForVectorAndAncestors() throws Exception {
        OntologyQuery<String> q = newOntologyQueryOnly(vectorIri);
        q.setIncludeAncestors(true);
        final Set<String> identifiers = asvRule.toRelevantIdentifiers(singletonList(q));
        assertThat(identifiers).containsExactlyInAnyOrder(rootIri, vectorIri);
    }

    private void testEntriesEbolaAndDescendantsAsPathogen(EntryComplexQuery q) {
        final Page<Entry> entries = entryRule.search(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .anySatisfy(this::assertTypeIsDataset)
                .anySatisfy(this::assertTypeIsDtm)
                .allSatisfy(this::assertBaseOnTypeForEbolaAsPathogen);
    }

    private void testEntriesEbolaOnlyAsPathogen(EntryComplexQuery q) {
        final Page<Entry> entries = entryRule.search(q, null);

        assertThat(entries.getTotalElements()).isGreaterThan(0);
        assertThat(entries)
                .allSatisfy(this::assertStatusIsApproved)
                .allSatisfy(this::assertTypeIsDtm)
                .allSatisfy(e -> {
                    final Map<String, Object> content = toContent(e);
                    final Map<String, Object> entry = getMap(content, ENTRY);
                    assertThat(getList(entry, PATHOGEN_COVERAGE))
                            .anySatisfy(o -> assertIdentifier(o, ebolaId + ""));
                });
    }

    private void assertMatchSoftware(MatchedSoftware m) {
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
        assertIdentifier(o, quarantineIri);
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
        ncbi.setIsLeaf(leaf);
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
        dtmLocationAssert(entry).allSatisfy(this::assertUsaIdentifier);
    }

    private ListAssert<Object> dtmLocationAssert(Map<String, Object> entry) {
        return assertThat(getList(entry, LOCATION_COVERAGE));
    }

    private void assertUsaDataset(Map<String, Object> entry) {
        assertThat(getList(entry, SPATIAL_COVERAGE))
                .allSatisfy(this::assertUsaIdentifier);
    }

    private void assertHumanIdentifier(Object o) {
        assertIdentifier(o, humanId + "");
    }

    private void assertUsaIdentifier(Object o) {
        assertIdentifiers(o, usaIds);
    }

    private void assertDtmByLocation(Entry e, String alc) {
        final Map<String, Object> content = toContent(e);
        final Map<String, Object> entry = getMap(content, ENTRY);
        dtmLocationAssert(entry).anySatisfy(o -> assertIdentifier(o, alc));
    }

    private void assertIdentifier(Object o, String... expects) {
        final Map<String, Object> identifier = getMap(o, KEY_IDENTIFIER);
        assertThat(identifier.get(KEY_IDENTIFIER)).isIn(expects);
    }

    private void assertIdentifiers(Object o, List<String> expects) {
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

    private static <T> OntologyQuery<T> newOntologyQueryOnly(T id) {
        final OntologyQuery<T> q = new OntologyQuery<>(id);
        q.setIncludeAncestors(false);
        q.setIncludeDescendants(false);
        return q;
    }

    private static <T> void assertContainsExactlyInAnyOrder(Iterable<T> iterable, Iterable<T> expects) {
        final IterableAssert<T> iterableAssert = assertThat(iterable);
        iterableAssert.containsAll(expects);
        iterableAssert.containsOnlyElementsOf(expects);
    }
}
