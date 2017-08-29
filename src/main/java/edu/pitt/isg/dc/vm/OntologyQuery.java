package edu.pitt.isg.dc.vm;

import lombok.Data;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class OntologyQuery<T> {
    @NonNull private T id;
    private boolean includeAncestors = true;
    private boolean includeDescendants = true;
}
