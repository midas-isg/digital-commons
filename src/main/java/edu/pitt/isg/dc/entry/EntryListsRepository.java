package edu.pitt.isg.dc.entry;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigInteger;
import java.util.List;

@Repository
public interface EntryListRepository extends JpaRepository<EntryList, Integer> {
    String IS_PUBLIC = " is_public = true ";
    String AND_PUBLIC = " AND " + IS_PUBLIC;
    String FROM_ENTRY_LISTS = " FROM entry_lists \n ";

    @Transactional(readOnly=true)
    EntryList findOne(Integer id);

    @Query(nativeQuery = true, value = "select entry_lists_id as id, type as type, subtype as subType, content as content, is_public as is_public \n " +
            FROM_ENTRY_LISTS +
            "where type = :listType and subtype is null " + AND_PUBLIC )
    List<EntryList> findEntryListsObject(@Param("listType") String type);

/*
    @Query(nativeQuery = true, value = "select entry_lists_id as id, type, subtype, content #>> '{}' as content, is_public \n" +
            FROM_ENTRY_LISTS +
            "where type = :listType and subtype is null " + AND_PUBLIC )
    List<EntryList> findEntryListsObject(@Param("listType") String type);
*/

    @Query(nativeQuery = true, value = "select entry_lists_id as identifier, content #>> '{}' as content \n" +
            FROM_ENTRY_LISTS +
            "where type = :listType and subtype is null " + AND_PUBLIC )
    List<Object[]> findEntryLists(@Param("listType") String type);

    @Query(nativeQuery = true, value = "select entry_lists_id as identifier, content #>> '{}' as content \n" +
            FROM_ENTRY_LISTS +
            "where type = :listType and subtype = :listSubType " + AND_PUBLIC )
    List<Object[]> findEntryListsWithSubType(@Param("listType") String type, @Param("listSubType")  String subType);

    @Query(nativeQuery = true, value = "select content #>> '{}' as content \n" +
            FROM_ENTRY_LISTS +
            "where entry_lists_id = :identifier " )
    String findContentForEntryListByIdentifier(@Param("identifier") BigInteger identifier);


}
