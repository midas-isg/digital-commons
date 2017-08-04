package edu.pitt.isg.dc.vm;

public class EntryOntologyQuery {
    private Long controlMeasureId;
    private Long coverageLsId;
    private Long hostNcbiId;
    private Long pathogenNcbiId;

    public static EntryOntologyQuery of(Long host, Long pathogen, Long location, Long measure) {
        final EntryOntologyQuery q = new EntryOntologyQuery();
        q.setControlMeasureId(measure);
        q.setHostNcbiId(host);
        q.setCoverageLsId(location);
        q.setPathogenNcbiId(pathogen);
        return q;
    }

    public Long getControlMeasureId() {
        return controlMeasureId;
    }

    public void setControlMeasureId(Long controlMeasureId) {
        this.controlMeasureId = controlMeasureId;
    }

    public Long getCoverageLsId() {
        return coverageLsId;
    }

    public void setCoverageLsId(Long coverageLsId) {
        this.coverageLsId = coverageLsId;
    }

    public Long getHostNcbiId() {
        return hostNcbiId;
    }

    public void setHostNcbiId(Long hostNcbiId) {
        this.hostNcbiId = hostNcbiId;
    }

    public Long getPathogenNcbiId() {
        return pathogenNcbiId;
    }

    public void setPathogenNcbiId(Long pathogenNcbiId) {
        this.pathogenNcbiId = pathogenNcbiId;
    }
}
