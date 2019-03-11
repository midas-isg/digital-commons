package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;

@Repository
public interface EntryListsRepository extends JpaRepository<EntryLists, Integer> {
    String IS_PUBLIC = " is_public = true ";
    String AND_PUBLIC = " AND " + IS_PUBLIC;
    String FROM_ENTRY_LISTS = " FROM entry_lists \n ";

    @Transactional(readOnly=true)
    EntryLists findOne(Integer id);

    @Query(nativeQuery = true, value = "select id, type, sub_type, content, is_public \n" +
            FROM_ENTRY_LISTS +
            "where type = :listType " + AND_PUBLIC )
    List<EntryLists> findEntryLists(@Param("listType") String type);

    @Query(nativeQuery = true, value = "select id, type, sub_type, content, is_public \n" +
            FROM_ENTRY_LISTS +
            "where type = :listType and subtype = :listSubType " + AND_PUBLIC )
    List<EntryLists> findEntryListsWithSubType(@Param("listType") String type, @Param("listSubType")  String subType);

/*
    @Query(nativeQuery = true, value = "select content #>> '{}' as content \n" +
            FROM_ENTRY_LISTS +
            "where id = :identifier " )
    String findContentForEntryListsByIdentifier(@Param("identifier") BigInteger identifier);
*/

    @Query(nativeQuery = true, value = "select content \n" +
            FROM_ENTRY_LISTS +
            "where id = :identifier " )
    HashMap findContentForEntryListsByIdentifier(@Param("identifier") BigInteger identifier);

}
