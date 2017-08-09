package edu.pitt.isg.dc.entry;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigInteger;
import java.util.List;

@Repository
public interface EntryRepository extends JpaRepository<Entry, Long> {
    Page<Entry> findAllByStatus(String status, Pageable pageable);
    Page<Entry> findByIdIn(List<Long> ids, Pageable pageable);

    @Query(nativeQuery = true, value = "SELECT DISTINCT id FROM entry\n" +
            "WHERE EXISTS (\n" +
            "    SELECT 1 FROM jsonb_array_elements(content #> ARRAY['entry',?1]) AS about\n" +
            "    WHERE about #>> '{identifier,identifierSource}' = ?2\n" +
            "    AND about #>> '{identifier,identifier}' IN ?3\n" +
            "    AND status = 'approved'\n" +
            ")")
    List<BigInteger> filterIdsByFieldAndIdentifierSource(String field, String srcId, List<String> onlyIds);

    @Query(nativeQuery = true, value = "SELECT DISTINCT about #>> '{identifier,identifier}' " +
            "FROM entry, jsonb_array_elements(content #> ARRAY['entry',?1]) AS about " +
            "WHERE about #>> '{identifier,identifierSource}' = ?2 " +
            "AND status = 'approved' " +
            "")
    List<String> listIdentifiersByFieldAndIdentifierSource(String field, String srcId);
}