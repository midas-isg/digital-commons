package edu.pitt.isg.dc.repository;

/**
 * Created by jdl50 on 5/26/17.
 */
public class RepositoryEntry<T> {
    private String sourceData;
    private String memberOf;
    private T t;

    public RepositoryEntry(T t, String sourceData, String memberOf) {
        this.t = t;
        this.sourceData = sourceData;
        this.memberOf = memberOf;
    }

    public T getInstance() {
        return t;
    }
    public String getSourceData() {
        return sourceData;
    }

    public String getMemberOf() {
        return memberOf;
    }


}
