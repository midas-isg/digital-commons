package edu.pitt.isg.dc.vm;

import lombok.Data;

import java.util.Collections;
import java.util.Set;

@Data
public class EntryComplexQuery {
    private Set<OntologyQuery<String>> controlMeasures;
    private Set<OntologyQuery<Long>> locations;
    private Set<OntologyQuery<Long>> hosts;
    private Set<OntologyQuery<Long>> pathogens;
    private Set<OntologyQuery<String>> types;

    public static EntryComplexQuery of(EntrySimpleQuery q) {
        final EntryComplexQuery query = new EntryComplexQuery();
        query.setControlMeasures(setOf(q.getControlMeasureId()));
        query.setLocations(setOf(q.getLocationId()));
        query.setHosts(setOf(q.getHostId()));
        query.setPathogens(setOf(q.getPathogenId()));
        query.setTypes(setOf(q.getType()));
        return query;
    }

    private static <T> Set<OntologyQuery<T>> setOf(T id) {
        if (id == null)
            return null;
        return Collections.singleton(new OntologyQuery<T>(id));
    }
}
