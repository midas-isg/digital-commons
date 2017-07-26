package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.persistence.NamedNativeQuery;
import java.math.BigInteger;
import java.util.Collection;
import java.util.List;
import java.util.Set;

@NamedNativeQuery(name = "Todo.findByTitleIs",
        query="SELECT * FROM todos t WHERE t.title = 'title'",
        resultClass = Entry.class
)
@Repository
public interface EntryRepository extends JpaRepository<Entry, Long> {
    List<Entry> findAllByStatus(String status);

    @Query(nativeQuery = true, value = "SELECT * FROM entry e WHERE e.status = 'approved' and e.content @> jsonb(?1)")
    List<Entry> findAllByContentContainingJson(String json);

    @Query(nativeQuery = true, value = "select * from entry\n" +
            "where exists (\n" +
            "    select 1 from jsonb_array_elements(content #> '{entry,isAbout}') as about\n" +
            "    where about #>> '{identifier,identifier}' like ?1\n" +
            "    and about #>> '{identifier,identifierSource}' = 'https://biosharing.org/bsg-s000154'\n" +
            ")\n")
    List<Entry> findAllByAboutNcbiId(String likeId);

    @Query(nativeQuery = true, value = "select distinct id from entry\n" +
            "where exists (\n" +
            "    select 1 from jsonb_array_elements(content #> '{entry,isAbout}') as about\n" +
            "    where about #>> '{identifier,identifier}' in ?1\n" +
            "    and about #>> '{identifier,identifierSource}' = 'https://biosharing.org/bsg-s000154'\n" +
            ")\n")
    List<BigInteger> findAllByAboutNcbiIdViaOntology(List<String> ncbiIds);

    @Query(nativeQuery = true, value = "select distinct id from entry\n" +
            "where exists (\n" +
            "    select 1 from jsonb_array_elements(content #> '{entry,spatialCoverage}') as about\n" +
            "    where about #>> '{identifier,identifier}' in ?1\n" +
            "    and about #>> '{identifier,identifierSource}' = 'ApolloLS'\n" +
            ")\n")
    List<BigInteger> findAllBySpatialCoverageLsIdViaOntology(List<String> lsIds);

    @Query(nativeQuery = true, value = "SELECT DISTINCT about #>> '{identifier,identifier}' FROM entry, jsonb_array_elements(content #> '{entry,isAbout}') AS about WHERE about #>> '{identifier,identifierSource}' = 'https://biosharing.org/bsg-s000154'")
    List<String> listAboutNcbiIds();

    @Query(nativeQuery = true, value = "SELECT DISTINCT loc #>> '{identifier,identifier}' FROM entry, jsonb_array_elements(content #> '{entry,spatialCoverage}') AS loc WHERE loc #>> '{identifier,identifierSource}' =  'apollo location service'")
    List<String> listSpatialCoverageLsIds();
}