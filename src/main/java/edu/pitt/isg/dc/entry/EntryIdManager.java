package edu.pitt.isg.dc.entry;

import org.hibernate.HibernateException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.math.BigInteger;

/**
 * Created by amd176 on 8/9/17.
 */
@Component
public class EntryIdManager {
    @Autowired
    private EntityManager entityManager;

    public EntryIdManager() {}

    public EntryId getNewEntryId() {
        EntryId entryId = null;
        try {
            String sqlString = "SELECT max(entry_id) AS entry_id FROM entry";
            Query query = entityManager.createNativeQuery(sqlString);
            BigInteger maxEntryId = (BigInteger) query.getSingleResult();
            entryId = new EntryId(maxEntryId.longValue() + 1, (long) 1);
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return entryId;
    }

    public EntryId getLatestRevisionEntryId(Long providedId) {
        EntryId entryId = null;
        try {
            String sqlString = "SELECT max(revision_id) AS revision_id FROM entry WHERE entry_id = :id GROUP BY entry_id";
            Query query = entityManager.createNativeQuery(sqlString)
                    .setParameter("id", providedId);
            BigInteger maxRevisionId = (BigInteger) query.getSingleResult();
            entryId = new EntryId(providedId, maxRevisionId.longValue() + 1);
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return entryId;
    }

}
