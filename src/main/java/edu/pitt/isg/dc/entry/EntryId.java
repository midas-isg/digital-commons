package edu.pitt.isg.dc.entry;

import javax.persistence.Embeddable;
import javax.persistence.GeneratedValue;
import java.io.Serializable;

import static javax.persistence.GenerationType.IDENTITY;
import static javax.persistence.GenerationType.SEQUENCE;

/**
 * Created by amd176 on 8/8/17.
 */
@Embeddable
public class EntryId implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long entryId;
    private Long revisionId;

    public EntryId() {}

    public EntryId(Long entryId, Long revisionId) {
        this.entryId = entryId;
        this.revisionId = revisionId;
    }

    public Long getEntryId() {
        return entryId;
    }

    public void setEntryId(Long entryId) {
        this.entryId = entryId;
    }

    public Long getRevisionId() {
        return revisionId;
    }

    public void setRevisionId(Long revisionId) {
        this.revisionId = revisionId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        EntryId entryId1 = (EntryId) o;

        if (!entryId.equals(entryId1.entryId)) return false;
        return revisionId.equals(entryId1.revisionId);
    }

    @Override
    public int hashCode() {
        int result = entryId.hashCode();
        result = 31 * result + revisionId.hashCode();
        return result;
    }
}
