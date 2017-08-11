package edu.pitt.isg.dc.vm;

public class EntryOntologyQuery {
    private Long controlMeasureId;
    private Long locationId;
    private Long hostId;
    private Long pathogenId;
    private String type;

    public Long getControlMeasureId() {
        return controlMeasureId;
    }

    public void setControlMeasureId(Long controlMeasureId) {
        this.controlMeasureId = controlMeasureId;
    }

    public Long getLocationId() {
        return locationId;
    }

    public void setLocationId(Long locationId) {
        this.locationId = locationId;
    }

    public Long getHostId() {
        return hostId;
    }

    public void setHostId(Long hostId) {
        this.hostId = hostId;
    }

    public Long getPathogenId() {
        return pathogenId;
    }

    public void setPathogenId(Long pathogenId) {
        this.pathogenId = pathogenId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
