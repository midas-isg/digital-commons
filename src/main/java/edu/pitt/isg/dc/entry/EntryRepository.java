package edu.pitt.isg.dc.entry;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.util.List;
import java.util.Set;

@Repository
public interface EntryRepository extends JpaRepository<Entry, EntryId> {
    String IS_PUBLIC = "is_public = true ";
    String AND_PUBLIC = "AND " + IS_PUBLIC;
    String AND_A_PUBLIC = "AND a." + IS_PUBLIC;
    String AND_B_PUBLIC = "AND b." + IS_PUBLIC;

    @Transactional(readOnly=true)
    Entry findOne(EntryId id);

    void delete(EntryId id);

    List<Entry> findAllByStatus(String status);

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "GROUP BY entry_id) AND status != 'approved'")
    List<Entry> findLatestUnapprovedEntries();

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "GROUP BY entry_id) AND status != 'approved' AND user_id = ?1")
    List<Entry> findUserLatestUnapprovedEntries(Long userId);

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "WHERE status = 'approved' AND is_public=true \n " +
            "GROUP BY entry_id) AND status = 'approved' AND entry_id = ?1 AND is_public=true ")
    Entry getEntryByEntryIdAndMaxRevisionId(Long id);

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "GROUP BY entry_id) AND entry_id = ?1 ")
    Entry getEntryByEntryIdAndMaxRevisionIdIncludeNonPublic(Long id);

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "WHERE status = 'approved' GROUP BY entry_id) AND is_public = false")
    List<Entry> findLatestApprovedNotPublicEntries();

    @Query(nativeQuery = true, value="SELECT * from entry where entry_id = ?1 and revision_id != ?2 and is_public = true;")
    List<Entry> findDistinctPublicEntries(Long entryId, Long revisionId);

    Page<Entry> findAllByIsPublic(boolean status, Pageable pageable);
    Page<Entry> findByIdIn(Set<EntryId> ids, Pageable pageable);

    @Query(nativeQuery = true, value = "SELECT DISTINCT entry_id, revision_id  FROM entry\n" +
            "WHERE EXISTS (\n" +
            "    SELECT 1 FROM jsonb_array_elements(content #> ARRAY['entry',?1]) AS about\n" +
            "    WHERE about #>> '{identifier,identifierSource}' = ?2\n" +
            "    AND about #>> '{identifier,identifier}' IN ?3\n" +
            "    " + AND_PUBLIC +"\n" +
            ")")
    List<Object[]> filterIdsByFieldAndIdentifierSource(String field, String srcId, Set<String> onlyIds);

    @Query(nativeQuery = true, value = "SELECT DISTINCT about #>> '{identifier,identifier}' " +
            "FROM entry, jsonb_array_elements(content #> ARRAY['entry',?1]) AS about " +
            "WHERE about #>> '{identifier,identifierSource}' = ?2 " +
            AND_PUBLIC)
    Set<String> listIdentifiersByFieldAndIdentifierSource(String field, String srcId);

    @Query(nativeQuery = true, value = "SELECT entry_id, revision_id from entry " +
            "WHERE content #>> '{properties,type}' IN ?1 " +
            AND_PUBLIC)
    List<Object[]> filterIdsByTypes(Set<String> onlyTypes);

    @Query(nativeQuery = true, value = "SELECT * from entry " +
            "WHERE content #>> '{properties,type}' IN ?1 " +
            AND_PUBLIC)
    List<Entry> filterEntryIdsByTypes(Set<String> onlyTypes);

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "GROUP BY entry_id) AND is_public = TRUE AND content #>> '{properties,type}' IN ?1 ")
    List<Entry> filterEntryIdsByTypesMaxRevisionID(Set<String> onlyTypes);

    @Query(nativeQuery = true, value = "SELECT DISTINCT content #>> '{properties,type}' " +
            "FROM entry WHERE " + IS_PUBLIC)
    List<String> listTypes();

    @Query(nativeQuery = true, value = "SELECT DISTINCT content #>> '{properties,type}' " +
            "FROM entry " +
            "WHERE content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true")
    List<String> listTypesForIdentifier(String identifier);

    @Query(nativeQuery = true, value = "select a.content #>> '{entry, title}' as s1, text(a.content #> '{entry, dataOutputFormats}') as o," +
                                       "       b.content #>> '{entry, title}' as s2 \n" +
            "from entry a, entry b\n" +
            "where a.content #>> '{properties, type}' like 'edu.pitt.isg.mdc.v1_0.%'\n" +
            "and b.content #>> '{properties, type}' like 'edu.pitt.isg.mdc.v1_0.%'\n" +
            "and a.entry_id <> b.entry_id\n" +
            "and (\n" +
            "   ( b.content #> '{entry, dataInputFormats}' @> (a.content #> '{entry, dataOutputFormats}') )\n" +
            "   or \n" +
            "   ( b.content #> '{entry, dataInputFormats}' <@ (a.content #> '{entry, dataOutputFormats}')  )\n" +
            ")\n" +
            AND_A_PUBLIC + AND_B_PUBLIC +
            "order by s1"
    )
    List<Object[]> match2Software();

    @Query(nativeQuery = true, value = "select content->'entry'->>'name' as name " +
            "from entry " +
            "where " + IS_PUBLIC + "and category_id == 4 " +
            "order by name ")
    List findDataFormats();

    @Query(nativeQuery = true, value = "select display_name, " +
            "content->'entry'#>'{distributions,0}'->'access'->>'accessURL' " +
            "as access_url from entry where category_id = 39 order by display_name")
    List<Object[]> spewLocationsAndAccessUrls();

    @Query(nativeQuery = true, value = "select distinct\n" +
            "  content->'entry'->'identifier'->>'identifier'\n" +
            "  from entry where is_public = true\n" +
            "                   and content->'entry'->>'identifier' != ''\n" +
            "                   and content->'entry'->'identifier'->>'identifier' != '';")
    List<String> findPublicIdentifiers();

    @Query(nativeQuery = true, value = "select distinct \n" +
            "  e.content->'entry'->'identifier'->>'identifier'\n" +
            "  from entry as e \n" +
            "  JOIN vw_findsetsview as fs \n" +
            "  ON fs.setid = e.category_id \n" +
            "  where e.is_public = true\n" +
            "                   and fs.path not LIKE '%Websites with data%' \n" +
            "                   and e.content->'entry'->>'identifier' != ''\n" +
            "                   and e.content->'entry'->'identifier'->>'identifier' != '';")
    List<String> findFirstClassPublicIdentifiers();

    @Query(nativeQuery = true, value = "select distinct content->'entry'#>ARRAY['distributions',?2]->'access'->>'accessURL' " +
            "from entry where content->'entry'#>ARRAY['distributions',?2]->'access'->>'accessURL' != '' " +
            "and content->'entry'->'identifier'->>'identifier' != ''" +
            "and content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true limit 1")
    String findAccessUrlByIdentifierAndDistributionId(String identifier, String distributionId);

    @Query(nativeQuery = true, value = "select * from entry where " +
            "content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true limit 1")
    Entry findByMetadataIdentifier(String identifier);

    @Query(nativeQuery = true, value = "select category_id from entry where " +
            "content->'entry'->'identifier'->>'identifier' = :identifier  and " +
            "is_public = true limit 1")
    Integer findCategoryIdByIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value = "select CASE " +
            "WHEN content->'entry'->>'title' IS NOT NULL THEN content->'entry'->>'title' " +
            "WHEN content->'entry'->>'name' IS NOT NULL THEN content->'entry'->>'name' " +
            "END from entry where " +
            "entry_id = :entryId  and " +
            "is_public = true ")
    String findTitleByEntryId(@Param("entryId") Long entryId);

    @Query(nativeQuery = true, value = "select count(*) from entry where " +
            "content->'entry'->'identifier'->>'identifier' = :identifier  and " +
            "is_public = true ")
    Integer findCountOfIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value="select * from entry where is_public = true;")
    List<Entry> findPublicEntries();

    @Query(nativeQuery = true, value="select e.* \n" +
            "from entry as e \n" +
            "JOIN vw_findsetsview as fs \n" +
            "ON fs.setid = e.category_id \n" +
            "where \n" +
            "fs.path not LIKE '%Websites with data%' \n" +
            "and is_public = true;")
    List<Entry> findFirstClassPublicEntries();

    @Query(nativeQuery = true, value="select c2.category from entry " +
            "join category c2 ON entry.category_id = c2.id " +
            "where content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true;")
    List<String> getCategoryForIdentifier(@Param("identifier") String identifier);


    @Query(nativeQuery = true, value=
            "WITH RECURSIVE set_subset as ( \n" +
                "SELECT \n" +
                    "co.category_id AS set, \n" +
                    "co.subcategory_id AS subset \n" +
                "FROM category_order AS co \n" +
                "UNION ALL \n" +
                "SELECT \n" +
                    "ss.set as set, \n" +
                    "co2.subcategory_id AS subset \n" +
                "FROM category_order as co2 \n" +
                "INNER JOIN set_subset AS ss \n" +
                "ON  ss.subset = co2.category_id and ss.set <> 1 \n" +
                ") \n" +
            "SELECT DISTINCT \n" +
                "--ss2.set, \n" +
                "c1.category as setname \n" +
                "--ss2.subset, \n" +
                "--c2.category as subsetname \n" +
            "FROM set_subset ss2 \n" +
            "join entry as e \n" +
            "on ss2.subset = e.category_id \n" +
            "join category c1 ON ss2.set = c1.id \n" +
            "join category c2 ON ss2.subset = c2.id \n" +
            "where content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true \n" +
            "UNION \n" +
                "SELECT \n" +
                    "--c.id as set, \n" +
                    "c.category as setname \n" +
                    "--c.id as subset, \n" +
                    "--c.category as subsetname \n" +
                "FROM category as c \n" +
                "join entry e2 ON c.id = e2.category_id \n" +
                "where content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true;")
    List<String> getCategoriesForIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value=
    "select e.* from entry as e \n" +
    "JOIN vw_findsetsview as fs \n" +
    "ON fs.setid = e.category_id \n" +
    "where date_added BETWEEN ?1 AND ?2 \n" +
    "and fs.path not LIKE '%Websites with data%' \n" +
    "and is_public = true;")
    List<Entry> getListRecordsByDate(@Param("from") java.util.Date from, @Param("until") java.util.Date until);


    @Query(nativeQuery = true, value=
    "SELECT DISTINCT \n" +
    "content->'entry'->'identifier'->>'identifier' as identifier \n" +
    "from entry as e \n" +
    "JOIN \n" +
            "(select entry_id, max(revision_id) as revision_id \n" +
            "from entry \n" +
            "group by entry_id) as eid \n" +
            "on e.entry_id = eid.entry_id and e.revision_id = eid.revision_id; ")
    List<String> getAllIdentifiers();

    @Query(nativeQuery = true, value=
    "SELECT status \n" +
    "from entry as e \n" +
    "JOIN \n" +
            "(select entry_id, max(revision_id) as revision_id \n" +
    "from entry \n" +
    "group by entry_id) as eid \n" +
    "on e.entry_id = eid.entry_id and e.revision_id = eid.revision_id \n" +
    "WHERE content->'entry'->'identifier'->>'identifier' = ?1 ; ")
    String getStatusForIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value =
    "SELECT * \n" +
    "from entry as e \n" +
    "JOIN \n" +
    "(select entry_id, max(revision_id) as revision_id \n" +
    "from entry \n" +
    "group by entry_id) as eid \n" +
    "on e.entry_id = eid.entry_id and e.revision_id = eid.revision_id \n" +
    "WHERE content->'entry'->'identifier'->>'identifier' = ?1 ; ")
    Entry findByMetadataIdentifierIncludeNotPublic(String identifier);



}