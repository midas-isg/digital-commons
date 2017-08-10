package edu.pitt.isg.dc.entry;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by amd176 on 8/9/17.
 */
@Repository
public interface CommentsRepository extends JpaRepository<Comments, EntryId> {
    @Transactional(readOnly = true)
    Comments findOne(EntryId id);
}