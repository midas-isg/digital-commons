package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigInteger;
import java.sql.Date;
import java.util.*;

@Repository
public interface EntryRepository extends JpaRepository<Entry, EntryId> {
    String IS_PUBLIC = "is_public = true ";
    String AND_PUBLIC = "AND " + IS_PUBLIC;
    String AND_A_PUBLIC = "AND a." + IS_PUBLIC;
    String AND_B_PUBLIC = "AND b." + IS_PUBLIC;
    String IS_DATA_FORMAT = "category_id = 4 ";
    String FROM_ENTRY = "FROM entry ";

    @Transactional(readOnly=true)
    Entry findOne(EntryId id);

    void delete(EntryId id);

    List<Entry> findAllByStatus(String status);

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + " \n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id " + FROM_ENTRY + " \n" +
            "GROUP BY entry_id) AND status != 'approved'")
    List<Entry> findLatestUnapprovedEntries();

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + " \n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id " + FROM_ENTRY + " \n" +
            "GROUP BY entry_id) AND status != 'approved' AND user_id = ?1")
    List<Entry> findUserLatestUnapprovedEntries(Long userId);

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + " \n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id " + FROM_ENTRY + " \n" +
            "WHERE status = 'approved' AND is_public=true \n " +
            "GROUP BY entry_id) AND status = 'approved' AND entry_id = ?1 AND is_public=true ")
    Entry getEntryByEntryIdAndMaxRevisionId(Long id);

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + " \n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id " + FROM_ENTRY + " \n" +
            "GROUP BY entry_id) AND entry_id = ?1 ")
    Entry getEntryByEntryIdAndMaxRevisionIdIncludeNonPublic(Long id);

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + " \n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id " + FROM_ENTRY + " \n" +
            "WHERE status = 'approved' GROUP BY entry_id) AND is_public = false")
    List<Entry> findLatestApprovedNotPublicEntries();

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + "  where entry_id = ?1 and revision_id != ?2 and is_public = true;")
    List<Entry> findDistinctPublicEntries(Long entryId, Long revisionId);

    Page<Entry> findAllByIsPublic(boolean status, Pageable pageable);
    Page<Entry> findByIdIn(Set<EntryId> ids, Pageable pageable);

    @Query(nativeQuery = true, value = "SELECT DISTINCT entry_id, revision_id  " + FROM_ENTRY + " \n" +
            "WHERE EXISTS (\n" +
            "    SELECT 1 FROM jsonb_array_elements(content #> ARRAY['entry',?1]) AS about\n" +
            "    WHERE about #>> '{identifier,identifierSource}' = ?2\n" +
            "    AND about #>> '{identifier,identifier}' IN ?3\n" +
            "    " + AND_PUBLIC +"\n" +
            ")")
    List<Object[]> filterIdsByFieldAndIdentifierSource(String field, String srcId, Set<String> onlyIds);

    @Query(nativeQuery = true, value = "SELECT DISTINCT about #>> '{identifier,identifier}' " +
            FROM_ENTRY + " , jsonb_array_elements(content #> ARRAY['entry',?1]) AS about " +
            "WHERE about #>> '{identifier,identifierSource}' = ?2 " +
            "and about #>> '{identifier,identifier}' is not null " +
            AND_PUBLIC)
    Set<String> listIdentifiersByFieldAndIdentifierSource(String field, String srcId);

    @Query(nativeQuery = true, value = "SELECT entry_id, revision_id " + FROM_ENTRY +
            "WHERE content #>> '{properties,type}' IN ?1 " +
            AND_PUBLIC)
    List<Object[]> filterIdsByTypes(Set<String> onlyTypes);

/*
    @Query(nativeQuery = true, value = "SELECT a.entry_id, a.revision_id " +
            "FROM \n" +
            "(select \n" +
            "             entry_id, \n" +
            "             revision_id, \n" +
            "             is_public, \n" +
            "             CASE \n" +
            "                 WHEN fsv.top_category_id = 148 \n" +
            "                 THEN 'edu.pitt.isg.mdc.dats2_2.WebsitesWithData' \n" +
            "                 ELSE content->'properties'->>'type' \n" +
            "             END as datatype \n" +
            "     from entry as e \n" +
            "     join vw_findsetsview as fsv \n" +
            "     on e.category_id = fsv.setid) as a \n" +
            " WHERE a.datatype IN ?1 \n" +
            " and a.is_public = true ")
    List<Object[]> filterIdsByTypes(Set<String> onlyTypes);
*/

    @Query(nativeQuery = true, value = "SELECT * " + FROM_ENTRY +
            "WHERE content #>> '{properties,type}' IN ?1 " +
            AND_PUBLIC)
    List<Entry> filterEntryIdsByTypes(Set<String> onlyTypes);

    @Query(nativeQuery = true, value="SELECT * " + FROM_ENTRY + " \n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id " + FROM_ENTRY + " \n" +
            "GROUP BY entry_id) AND is_public = TRUE AND content #>> '{properties,type}' IN ?1 ")
    List<Entry> filterEntryIdsByTypesMaxRevisionID(Set<String> onlyTypes);

    @Query(nativeQuery = true, value = "SELECT DISTINCT content #>> '{properties,type}' " +
            FROM_ENTRY + "  WHERE " + IS_PUBLIC)
    List<String> listTypes();

/*
    @Query(nativeQuery = true, value = "SELECT DISTINCT \n" +
            "CASE \n" +
            "  when fsv.top_category_id = 148 \n" +
            "    then 'edu.pitt.isg.mdc.dats2_2.WebsitesWithData' \n" +
            "  else e.content #>> '{properties,type}' \n" +
            "END \n" +
            FROM_ENTRY + " as e \n"  +
            "  JOIN vw_findsetsview as fsv \n" +
            "  ON fsv.setid = e.category_id \n" +
            "  WHERE " + IS_PUBLIC)
    List<String> listTypes();
*/

    @Query(nativeQuery = true, value = "SELECT DISTINCT content #>> '{properties,type}' " +
            FROM_ENTRY +
            "WHERE content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true")
    List<String> listTypesForIdentifier(String identifier);

/*
    @Query(nativeQuery = true, value = "select a.content #>> '{entry, title}' as s1, text(a.content #> '{entry, dataOutputFormats}') as o," +
                                       "       b.content #>> '{entry, title}' as s2 \n" +
            FROM_ENTRY + "  a, entry b\n" +
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
*/
@Query(nativeQuery = true, value = "select \n" +
        "  a.title as s1 \n" +
        "  , text(a.outputs) as o \n" +
        "  , b.title as s2 \n" +
        "from \n" +
        "(select \n" +
        "      entry_id, \n" +
        "       content #>> '{entry, title}' as title, \n" +
        "      jsonb_array_elements(content #> '{entry, outputs}') #> '{dataFormats}' as outputs \n" +
        "from entry \n" +
        "where \n" +
        "    content #>> '{properties, type}' like 'edu.pitt.isg.mdc.v1_0.%' \n" +
        "  and \n" +
        "    is_public = true) as a \n" +
        "join \n" +
        "(select \n" +
        "    entry_id, \n" +
        "    content #>> '{entry, title}' as title, \n" +
        "    jsonb_array_elements(content #> '{entry, inputs}') #> '{dataFormats}' as inputs \n" +
        "from entry \n" +
        "where \n" +
        "    content #>> '{properties, type}' like 'edu.pitt.isg.mdc.v1_0.%' \n" +
        "  and \n" +
        "    is_public = true) as b \n" +
        "on \n" +
        "  a.entry_id <> b.entry_id \n" +
        "  and \n" +
        "  text(a.outputs) not like '%Undocumented%' \n" +
        "  and \n" +
        "  ( b.inputs @> a.outputs \n" +
        "      or \n" +
        "    b.inputs <@ a.outputs ) \n" +
        "order by s1"
)
List<Object[]> match2Software();


    @Query(nativeQuery = true, value = "select distinct content->'entry'->'identifier'->>'identifier' as identifier, content->'entry'->>'name' || \n" +
            "CASE \n" +
            "when content->'entry'->>'version' is null or content->'entry'->>'version' = '' then '' \n" +
            "when content->'entry'->>'version' = '2010 U.S. Synthesized Population' then concat(' - ', content->'entry'->>'version') \n" +
            "when left(content->'entry'->>'version',1) ~ '^\\d+(\\.\\d+)?$' then concat(' - v', content->'entry'->>'version') \n" +
            "else concat(' - ', content->'entry'->>'version') \n" +
            "end as name \n" +
            FROM_ENTRY +
            "where " + IS_PUBLIC + "and " + IS_DATA_FORMAT +
            "order by name ")
    List<Object[]> findDataFormats();

    @Query(nativeQuery = true, value = "select distinct content->'entry'->>'name' || \n" +
            "CASE \n" +
            "when content->'entry'->>'version' is null or content->'entry'->>'version' = '' then '' \n" +
            "when content->'entry'->>'version' = '2010 U.S. Synthesized Population' then concat(' - ', content->'entry'->>'version') \n" +
            "when left(content->'entry'->>'version',1) ~ '^\\d+(\\.\\d+)?$' then concat(' - v', content->'entry'->>'version') \n" +
            "else concat(' - ', content->'entry'->>'version') \n" +
            "end as name \n" +
            FROM_ENTRY +
            "where " + IS_PUBLIC + "and " + IS_DATA_FORMAT + " and content->'entry'->'identifier'->>'identifier' = :dataFormatId ")
    String findDataFormatNameByIdentifier(@Param("dataFormatId") String dataFormatId);

    /*
    @Query(nativeQuery = true, value = "select entry_lists_id as id, type, subtype, content #>> '{}' as content, is_public \n" +
            "from entry_lists \n" +
            "where type = :listType and subtype is null " + AND_PUBLIC )
    List<EntryLists> findEntryListsObject(@Param("listType") String type);

    @Query(nativeQuery = true, value = "select entry_lists_id as identifier, content #>> '{}' as content \n" +
            "from entry_lists \n" +
            "where type = :listType and subtype is null " + AND_PUBLIC )
    List<Object[]> findEntryLists(@Param("listType") String type);

    @Query(nativeQuery = true, value = "select entry_lists_id as identifier, content #>> '{}' as content \n" +
            "from entry_lists \n" +
            "where type = :listType and subtype = :listSubType " + AND_PUBLIC )
    List<Object[]> findEntryListsWithSubType(@Param("listType") String type, @Param("listSubType")  String subType);

    @Query(nativeQuery = true, value = "select content #>> '{}' as content \n" +
            "from entry_lists \n" +
            "where entry_lists_id = :identifier " )
    String findContentForEntryListByIdentifier(@Param("identifier") BigInteger identifier);

*/
    @Query(nativeQuery = true, value = "select distinct jsonb_array_elements_text(content->'entry'->'licenses') \n" +
            FROM_ENTRY +
            "where " + IS_PUBLIC + "and " + IS_DATA_FORMAT)
    List<String> findDataFormatsLicenses();

    @Query(nativeQuery = true, value = "select distinct l.license \n" +
            "from ( \n" +
                "select jsonb_array_elements_text(content->'entry'->'storedIn'->'licenses') as license \n" +
                FROM_ENTRY + "  \n" +
                "where content->'entry'->'storedIn'->'licenses' is not null and is_public = true \n" +
                "union \n" +
                "select jsonb_array_elements_text(d.distributions->'storedIn'->'licenses') as license \n" +
                "from ( \n" +
                    "select distinct jsonb_array_elements(content->'entry'->'distributions') as distributions \n" +
                    FROM_ENTRY + "  \n" +
                    "where content->'entry'->'distributions' is not null and is_public = true \n" +
                ") as d \n" +
                "where d.distributions->'storedIn'->'licenses' is not null \n" +
            ") as l ")
    List<String> findDataRepositoryLicenses();

    @Query(nativeQuery = true, value = "select display_name, " +
            "content->'entry'#>'{distributions,0}'->'access'->>'accessURL' " +
            "as access_url " + FROM_ENTRY + "  where category_id = 39 order by display_name")
    List<Object[]> spewLocationsAndAccessUrls();

    @Query(nativeQuery = true, value = "select distinct\n" +
            "  content->'entry'->'identifier'->>'identifier'\n" +
            "  " + FROM_ENTRY + "  where is_public = true\n" +
            "                   and content->'entry'->>'identifier' != ''\n" +
            "                   and content->'entry'->'identifier'->>'identifier' != '';")
    List<String> findPublicIdentifiers();

    @Query(nativeQuery = true, value = "select distinct \n" +
            "  e.content->'entry'->'identifier'->>'identifier'\n" +
            "  " + FROM_ENTRY + "  as e \n" +
            "  JOIN vw_findsetsview as fs \n" +
            "  ON fs.setid = e.category_id \n" +
            "  where e.is_public = true\n" +
            "                   and fs.path not LIKE '%Websites with data%' \n" +
            "                   and e.content->'entry'->>'identifier' != ''\n" +
            "                   and e.content->'entry'->'identifier'->>'identifier' != '';")
    List<String> findFirstClassPublicIdentifiers();

    @Query(nativeQuery = true, value = "select distinct content->'entry'#>ARRAY['distributions',?2]->'access'->>'accessURL' " +
            FROM_ENTRY + "  where content->'entry'#>ARRAY['distributions',?2]->'access'->>'accessURL' != '' " +
            "and content->'entry'->'identifier'->>'identifier' != ''" +
            "and content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true limit 1")
    String findAccessUrlByIdentifierAndDistributionId(String identifier, String distributionId);

    @Query(nativeQuery = true, value = "select * " + FROM_ENTRY + "  where " +
            "content->'entry'->'identifier'->>'identifier' = ?1 and is_public = true limit 1")
    Entry findByMetadataIdentifier(String identifier);

    @Query(nativeQuery = true, value = "select category_id " + FROM_ENTRY + "  where " +
            "content->'entry'->'identifier'->>'identifier' = :identifier  and " +
            "is_public = true limit 1")
    Integer findCategoryIdByIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value = "select concat(" +
            "CASE \n" +
            "when category_id = 4 then content->'entry'->>'name' \n" +
            "else content->'entry'->>'title' \n" +
            "end, \n" +
            "CASE \n" +
            "when left(trim(array_to_string(ARRAY(select ' ' || jsonb_array_elements_text(content->'entry'->'softwareVersion')), ',')),1) ~ '^\\d+(\\.\\d+)?$' then concat(' - v', trim(array_to_string(ARRAY(select ' ' || jsonb_array_elements_text(content->'entry'->'softwareVersion')), ','))) \n" +
            "when content->'entry'->>'softwareVersion' is not null then trim(array_to_string(ARRAY(select ' ' || jsonb_array_elements_text(content->'entry'->'softwareVersion')), ',')) \n" +
            "when content->'entry'->>'version' is null or content->'entry'->>'version' = '' then '' \n" +
            "when content->'entry'->>'version' = '2010 U.S. Synthesized Population' then concat(' - ', content->'entry'->>'version') \n" +
            "when category_id = 4 and left(content->'entry'->>'version',1) ~ '^\\d+(\\.\\d+)?$' then concat(' - v', content->'entry'->>'version') \n" +
            "when category_id = 4 then concat(' - ', content->'entry'->>'version') \n" +
            "when left(trim(array_to_string(ARRAY(select ' ' || jsonb_array_elements_text(content->'entry'->'version')), ',')),1) ~ '^\\d+(\\.\\d+)?$' then concat(' - v', trim(array_to_string(ARRAY(select ' ' || jsonb_array_elements_text(content->'entry'->'version')), ','))) \n" +
            "else trim(array_to_string(ARRAY(select ' ' || jsonb_array_elements_text(content->'entry'->'version')), ',')) \n" +
            "end) \n" +
            FROM_ENTRY + "  " +
            "where entry_id = :entryId  and " +
            "is_public = true ")
    String findTitleByEntryId(@Param("entryId") Long entryId);

    @Query(nativeQuery = true, value = "select count(*) " + FROM_ENTRY + "  where " +
            "content->'entry'->'identifier'->>'identifier' = :identifier  and " +
            "is_public = true ")
    Integer findCountOfIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value="select * " + FROM_ENTRY + "  where is_public = true;")
    List<Entry> findPublicEntries();

    @Query(nativeQuery = true, value="select e.* \n" +
            FROM_ENTRY + "  as e \n" +
            "JOIN vw_findsetsview as fs \n" +
            "ON fs.setid = e.category_id \n" +
            "where \n" +
            "fs.path not LIKE '%Websites with data%' \n" +
            "and is_public = true;")
    List<Entry> findFirstClassPublicEntries();

    @Query(nativeQuery = true, value="select c2.category " + FROM_ENTRY + "  " +
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
    "select e.* " + FROM_ENTRY + "  as e \n" +
    "JOIN vw_findsetsview as fs \n" +
    "ON fs.setid = e.category_id \n" +
    "where date_added BETWEEN ?1 AND ?2 \n" +
    "and fs.path not LIKE '%Websites with data%' \n" +
    "and is_public = true;")
    List<Entry> getListRecordsByDate(@Param("from") java.util.Date from, @Param("until") java.util.Date until);


    @Query(nativeQuery = true, value=
    "SELECT DISTINCT \n" +
    "content->'entry'->'identifier'->>'identifier' as identifier \n" +
    FROM_ENTRY + "  as e \n" +
    "JOIN \n" +
            "(select entry_id, max(revision_id) as revision_id \n" +
            FROM_ENTRY + "  \n" +
            "group by entry_id) as eid \n" +
            "on e.entry_id = eid.entry_id and e.revision_id = eid.revision_id; ")
    List<String> getAllIdentifiers();

    @Query(nativeQuery = true, value=
    "SELECT status \n" +
    FROM_ENTRY + "  as e \n" +
    "JOIN \n" +
            "(select entry_id, max(revision_id) as revision_id \n" +
    FROM_ENTRY + "  \n" +
    "group by entry_id) as eid \n" +
    "on e.entry_id = eid.entry_id and e.revision_id = eid.revision_id \n" +
    "WHERE content->'entry'->'identifier'->>'identifier' = ?1 ; ")
    String getStatusForIdentifier(@Param("identifier") String identifier);

    @Query(nativeQuery = true, value =
    "SELECT * \n" +
    FROM_ENTRY + "  as e \n" +
    "JOIN \n" +
    "(select entry_id, max(revision_id) as revision_id \n" +
    FROM_ENTRY + "  \n" +
    "group by entry_id) as eid \n" +
    "on e.entry_id = eid.entry_id and e.revision_id = eid.revision_id \n" +
    "WHERE content->'entry'->'identifier'->>'identifier' = ?1 ; ")
    Entry findByMetadataIdentifierIncludeNotPublic(String identifier);


    @Query(nativeQuery = true, value =
            "select e.* \n" +
                    "from entry as e \n" +
                    "       join vw_findsetsview as fsv  \n" +
                    "         on e.category_id = fsv.setid \n" +
                    "where \n" +
                    "    fsv.top_category_id = ?1 \n" +
                    "  and \n" +
                    "    e.is_public = true \n" +
                    "union \n" +
                    "select e.* \n" +
                    "from entry as e \n" +
                    "where category_id = 4 \n" +
                    "  and is_public = true \n" +
                    "  and content #> '{entry, identifier, identifier}' in \n" +
                    "      ( \n" +
                    "      select distinct jsonb_array_elements(jsonb_array_elements(e.content #> '{entry, inputs}') #> '{dataFormats}') \n" +
                    "      from entry as e \n" +
                    "             join vw_findsetsview as fsv \n" +
                    "               on e.category_id = fsv.setid \n" +
                    "      where \n" +
                    "          fsv.top_category_id = ?1 \n" +
                    "        and \n" +
                    "          e.is_public = true \n" +
                    "      union \n" +
                    "      select distinct jsonb_array_elements(jsonb_array_elements(e.content #> '{entry, outputs}') #> '{dataFormats}') \n" +
                    "      from entry as e \n" +
                    "             join vw_findsetsview as fsv \n" +
                    "               on e.category_id = fsv.setid \n" +
                    "      where \n" +
                    "          fsv.top_category_id = ?1 \n" +
                    "        and \n" +
                    "          e.is_public = true \n" +
                    "      ) \n" +
                    "union \n" +
                    "select \n" +
                    "      e.entry_id \n" +
                    "    , e.revision_id \n" +
                    "    , e.content \n" +
                    "    , e.display_name \n" +
                    "    , e.is_public \n" +
                    "    , e.status \n" +
                    "    , e.category_id \n" +
                    "    , e.date_added \n" +
                    "    , e.user_id \n" +
                    "from \n" +
                    " (select \n" +
                    "  entry_id \n" +
                    "  , revision_id \n" +
                    "  , content \n" +
                    "  , display_name \n" +
                    "  , is_public \n" +
                    "  , status \n" +
                    "  , category_id \n" +
                    "  , date_added \n" +
                    "  , user_id \n" +
                    "  , jsonb_array_elements(jsonb_array_elements(content #> '{entry, distributions}') #> '{conformsTo}') #> '{identifier, identifier}' as identifier \n" +
                    "from entry) as e \n" +
                    "join \n" +
                    "   (select content #> '{entry, identifier, identifier}' as identifier \n" +
                    "     from entry \n" +
                    "     where category_id = 4 \n" +
                    "       and is_public = true \n" +
                    "       and content #> '{entry, identifier, identifier}' in \n" +
                    "       (select distinct jsonb_array_elements(jsonb_array_elements(e.content #> '{entry, inputs}') #> '{dataFormats}') \n" +
                    "         from entry as e \n" +
                    "                join vw_findsetsview as fsv \n" +
                    "                  on e.category_id = fsv.setid \n" +
                    "         where \n" +
                    "             fsv.top_category_id = ?1 \n" +
                    "           and \n" +
                    "             e.is_public = true \n" +
                    "         union \n" +
                    "         select distinct jsonb_array_elements(jsonb_array_elements(e.content #> '{entry, outputs}') #> '{dataFormats}') \n" +
                    "         from entry as e \n" +
                    "                join vw_findsetsview as fsv \n" +
                    "                  on e.category_id = fsv.setid \n" +
                    "         where \n" +
                    "             fsv.top_category_id = ?1 \n" +
                    "           and \n" +
                    "             e.is_public = true \n" +
                    "       ) \n" +
                    "   ) as d \n" +
                    "on e.identifier = d.identifier \n" +
                    "where \n" +
                    "    e.is_public = true \n" +
                    "union \n" +
                    "select distinct \n" +
                            "       entry_id \n" +
                            "    , revision_id \n" +
                            "    , content \n" +
                            "    , display_name \n" +
                            "    , is_public \n" +
                            "    , status \n" +
                            "    , category_id \n" +
                            "    , date_added \n" +
                            "    , user_id \n" +
                            "from \n" +
                            "(select \n" +
                            "       entry_id \n" +
                            "    , revision_id \n" +
                            "    , content \n" +
                            "    , display_name \n" +
                            "    , is_public \n" +
                            "    , status \n" +
                            "    , category_id \n" +
                            "    , date_added \n" +
                            "    , user_id \n" +
                            "    , jsonb_array_elements(jsonb_array_elements(content #> '{entry, inputs}') #> '{dataFormats}') as dataFormats \n" +
                            "    , fsv.top_category_id \n" +
                            "from entry \n" +
                            "       join vw_findsetsview as fsv \n" +
                            "         on category_id = fsv.setid \n" +
                            "where fsv.top_category_id != ?1 \n" +
                            "  and is_public = true \n" +
                            "union \n" +
                            "select \n" +
                            "    entry_id \n" +
                            "    , revision_id \n" +
                            "    , content \n" +
                            "    , display_name \n" +
                            "    , is_public \n" +
                            "    , status \n" +
                            "    , category_id \n" +
                            "    , date_added \n" +
                            "    , user_id \n" +
                            "    , jsonb_array_elements(jsonb_array_elements(content #> '{entry, outputs}') #> '{dataFormats}') as dataFormats \n" +
                            "    , fsv.top_category_id \n" +
                            "    from entry \n" +
                            "    join vw_findsetsview as fsv \n" +
                            "    on category_id = fsv.setid \n" +
                            "    where fsv.top_category_id != ?1 \n" +
                            "      and is_public = true \n" +
                            ") as e \n" +
                            "  join \n" +
                            "    (select content #> '{entry, identifier, identifier}' as identifier \n" +
                            "     from entry \n" +
                            "     where category_id = 4 \n" +
                            "       and is_public = true \n" +
                            "       and content #> '{entry, identifier, identifier}' in \n" +
                            "           (select distinct jsonb_array_elements(jsonb_array_elements(e.content #> '{entry, inputs}') #> '{dataFormats}') \n" +
                            "            from entry as e \n" +
                            "                   join vw_findsetsview as fsv \n" +
                            "                     on e.category_id = fsv.setid \n" +
                            "            where \n" +
                            "                fsv.top_category_id = ?1 \n" +
                            "              and \n" +
                            "                e.is_public = true \n" +
                            "            union \n" +
                            "            select distinct jsonb_array_elements(jsonb_array_elements(e.content #> '{entry, outputs}') #> '{dataFormats}') \n" +
                            "            from entry as e \n" +
                            "                   join vw_findsetsview as fsv \n" +
                            "                     on e.category_id = fsv.setid \n" +
                            "            where \n" +
                            "                fsv.top_category_id = ?1 \n" +
                            "              and \n" +
                            "                e.is_public = true \n" +
                            "           ) \n" +
                            "    ) as d \n" +
                            "    on e.dataFormats = d.identifier \n" +
                            "where \n" +
                            "    e.is_public = true \n" +
                            "   and e.top_category_id not in ?2 ; ")
    List<Entry> getAllEntriesPertainingToCategory(@Param("categoryId") Long categoryId, @Param("excludeTopCategoryIds") List<Long> excludeTopCategoryIds);

}