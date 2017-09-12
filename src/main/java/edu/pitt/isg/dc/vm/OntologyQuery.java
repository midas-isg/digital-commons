package edu.pitt.isg.dc.vm;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
@NoArgsConstructor
public class OntologyQuery<T> {
    @NonNull private T id;
    private boolean includeAncestors = true;
    private boolean includeDescendants = true;
}
