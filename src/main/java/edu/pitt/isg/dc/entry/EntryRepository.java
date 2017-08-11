package edu.pitt.isg.dc.entry;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigInteger;
import java.util.List;

import static edu.pitt.isg.dc.entry.Values.APPROVED;

@Repository
public interface EntryRepository extends JpaRepository<Entry, Long> {
    String IS_APPROVED = "status = '" + APPROVED + "'";
    String AND_APPROVED = "AND " + IS_APPROVED;

    Page<Entry> findAllByStatus(String status, Pageable pageable);
    Page<Entry> findByIdIn(List<Long> ids, Pageable pageable);

    @Query(nativeQuery = true, value = "SELECT DISTINCT id FROM entry\n" +
            "WHERE EXISTS (\n" +
            "    SELECT 1 FROM jsonb_array_elements(content #> ARRAY['entry',?1]) AS about\n" +
            "    WHERE about #>> '{identifier,identifierSource}' = ?2\n" +
            "    AND about #>> '{identifier,identifier}' IN ?3\n" +
            "    " + AND_APPROVED +"\n" +
            ")")
    List<BigInteger> filterIdsByFieldAndIdentifierSource(String field, String srcId, List<String> onlyIds);

    @Query(nativeQuery = true, value = "SELECT DISTINCT about #>> '{identifier,identifier}' " +
            "FROM entry, jsonb_array_elements(content #> ARRAY['entry',?1]) AS about " +
            "WHERE about #>> '{identifier,identifierSource}' = ?2 " +
            AND_APPROVED)
    List<String> listIdentifiersByFieldAndIdentifierSource(String field, String srcId);

    @Query(nativeQuery = true, value = "SELECT DISTINCT id from entry " +
            "WHERE content #>> '{properties,type}' IN ?1 " +
            AND_APPROVED)
    List<BigInteger> filterIdsByTypes(String[] onlyTypes);

    @Query(nativeQuery = true, value = "SELECT DISTINCT content #>> '{properties,type}' " +
            "FROM entry WHERE " + IS_APPROVED)
    List<String> listTypes();

    //@Query(nativeQuery = true, value = "select a.content #>> '{entry, title}' as s1, a.content #> '{entry, dataOutputFormats}' b.content #> '{entry, dataInputFormats}', b.content #>> '{entry, title}',\n" +
    //@Query(nativeQuery = true, value = "select a.content #>> '{entry, title}' as s1, b.content #>> '{entry, title}'\n" +
    @Query(nativeQuery = true, value = "select a.id as s1, b.id as s2 \n" +
            "from entry a, entry b\n" +
            "where a.content #>> '{properties, type}' like 'edu.pitt.isg.mdc.v1_0.%'\n" +
            "and b.content #>> '{properties, type}' like 'edu.pitt.isg.mdc.v1_0.%'\n" +
            "and a.id <> b.id\n" +
            "and (\n" +
            "   ( b.content #> '{entry, dataInputFormats}' @> (a.content #> '{entry, dataOutputFormats}') )\n" +
            "   or \n" +
            "   ( b.content #> '{entry, dataInputFormats}' <@ (a.content #> '{entry, dataOutputFormats}')  )\n" +
            ")\n" +
            "order by a.content #>> '{entry, title}'" //+ AND_APPROVED
            )
    List<List<BigInteger>> matchSoftware();
}