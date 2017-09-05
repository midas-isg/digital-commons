package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by amd176 on 8/9/17.
 */
@Repository
public interface CommentsRepository extends JpaRepository<Comments, Long> {
    @Transactional(readOnly = true)
    Comments findOne(Long id);

    @Query(nativeQuery = true, value="SELECT * FROM comments c WHERE c.entry_id = ?1 AND c.revision_id = ?2")
    List<Comments> findComment(Long entryId, Long revisionId);

    @Query(nativeQuery = true, value = "SELECT id FROM comments c WHERE c.entry_id = ?1 AND c.revision_id = ?2 AND c.content = ?3")
    Long getCommentId(Long entryId, Long revisionId, String content);
}