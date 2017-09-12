package edu.pitt.isg.dc.vm;

import lombok.Data;

import java.util.Collections;
import java.util.List;

@Data
public class EntryComplexQuery {
    private List<OntologyQuery<String>> controlMeasures;
    private List<OntologyQuery<Long>> locations;
    private List<OntologyQuery<Long>> hosts;
    private List<OntologyQuery<Long>> pathogens;
    private List<OntologyQuery<String>> types;

    public static EntryComplexQuery of(EntrySimpleQuery q) {
        final EntryComplexQuery query = new EntryComplexQuery();
        query.setControlMeasures(list(q.getControlMeasureId()));
        query.setLocations(list(q.getLocationId()));
        query.setHosts(list(q.getHostId()));
        query.setPathogens(list(q.getPathogenId()));
        query.setTypes(list(q.getType()));
        return query;
    }

    private static <T> List<OntologyQuery<T>> list(T id) {
        if (id == null)
            return null;
        return Collections.singletonList(new OntologyQuery<T>(id));
    }
}
