package edu.pitt.isg.dc.entry;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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
            "GROUP BY entry_id) AND status != 'approved' ")
    List<Entry> findLatestUnapprovedEntries();

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "GROUP BY entry_id) AND status != 'approved' AND user_id = ?1")
    List<Entry> findUserLatestUnapprovedEntries(Long userId);

    @Query(nativeQuery = true, value="SELECT * FROM entry\n" +
            "WHERE (entry_id, revision_id) IN\n" +
            "(SELECT entry_id, max(revision_id) AS revision_id FROM entry\n" +
            "WHERE status = 'approved' GROUP BY entry_id) AND is_public = false")
    List<Entry> findLatestApprovedNotPublicEntries();

    @Query(nativeQuery = true, value="SELECT * from entry where entry_id = ?1 and revision_id != ?2 and is_public = true;")
    List<Entry> findDistinctPublicEntries(Long entryId, Long revisionId);

    Page<Entry> findByStatus(String status, Pageable pageable);
    Page<Entry> findByIdIn(List<EntryId> ids, Pageable pageable);

    @Query(nativeQuery = true, value = "SELECT DISTINCT entry_id, revision_id  FROM entry\n" +
            "WHERE EXISTS (\n" +
            "    SELECT 1 FROM jsonb_array_elements(content #> ARRAY['entry',?1]) AS about\n" +
            "    WHERE about #>> '{identifier,identifierSource}' = ?2\n" +
            "    AND about #>> '{identifier,identifier}' IN ?3\n" +
            "    " + AND_PUBLIC +"\n" +
            ")")
    List<Object[]> filterIdsByFieldAndIdentifierSource(String field, String srcId, List<String> onlyIds);

    @Query(nativeQuery = true, value = "SELECT DISTINCT about #>> '{identifier,identifier}' " +
            "FROM entry, jsonb_array_elements(content #> ARRAY['entry',?1]) AS about " +
            "WHERE about #>> '{identifier,identifierSource}' = ?2 " +
            AND_PUBLIC)
    List<String> listIdentifiersByFieldAndIdentifierSource(String field, String srcId);

    @Query(nativeQuery = true, value = "SELECT entry_id, revision_id from entry " +
            "WHERE content #>> '{properties,type}' IN ?1 " +
            AND_PUBLIC)
    List<Object[]> filterIdsByTypes(String[] onlyTypes);

    @Query(nativeQuery = true, value = "SELECT DISTINCT content #>> '{properties,type}' " +
            "FROM entry WHERE " + IS_PUBLIC)
    List<String> listTypes();

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


    @Query(nativeQuery = true, value = "select display_name, " +
            "content->'entry'#>'{distributions,0}'->'access'->>'accessURL' " +
            "as access_url from dev.entry where category_id = 39 order by display_name")
    List<Object[]> spewLocationsAndAccessUrls();
}