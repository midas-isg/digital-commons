package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.config.hibernate.JsonbType;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import javax.persistence.*;
import java.util.HashMap;

import static javax.persistence.GenerationType.IDENTITY;

@Entity
@TypeDef(name = JsonbType.NAME, typeClass = JsonbType.class, parameters = {
        @Parameter(name = JsonbType.CLASS, value = "java.util.HashMap")})
public class EntryLists {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", updatable = false, nullable = false)
    private Long id;

    @Type(type = JsonbType.NAME)
    private HashMap content;
    private String type;
    private String subType;
    private boolean is_public;


    public Long getId() {return  id;}

    public void setId(Long id) {
        this.id = id;
    }

    @Type(type = JsonbType.NAME)
    public HashMap getContent() { return content; }

    public void setContent(HashMap content) {
        this.content = content;
    }

    public String getType() {return type;}

    public void setType(String type) {
        this.type = type;
    }

    public String getSubType() {return subType;}

    public void setSubType(String subType) {
        this.subType = subType;
    }

    public boolean getIsPublic() {
        return is_public;
    }

    public void setIsPublic(boolean is_Public) {
        this.is_public = is_Public;
    }

}
