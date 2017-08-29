package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.entry.ls.Properties;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

@Data
@Entity(name = "ls_cache")
public class Location {
    @Id
    private Long alc;
    private String locationTypeName;
    private String name;
    @Column(length = 10485760)
    private String relatives;

    public static Location of(Properties p, List<Long> alcs) {
        final Location location = new Location();
        location.setAlc(p.getGid());
        location.setLocationTypeName(p.getLocationTypeName());
        location.setName(p.getName());

        location.setRelatives(alcs.stream()
                .map(Object::toString)
                .collect(Collectors.joining(",")));
        return location;
    }
}
