package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.config.hibernate.JsonbType;
import org.hibernate.annotations.Parameter;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.util.HashMap;

@Entity
@TypeDef(name = JsonbType.NAME, typeClass = JsonbType.class, parameters = {
        @Parameter(name = JsonbType.CLASS, value = "java.util.HashMap")})
public class EntryList {

    @EmbeddedId
    @Type(type="pg-uuid")
    private Integer id;
    @Type(type = JsonbType.NAME)
    private HashMap content;
/*
    private String content;
*/
    private String type;
    private String subType;
    private boolean is_Public;


    public Integer getId() {return  id;}

    public void setId(Integer id) {
        this.id = id;
    }

    @Type(type = JsonbType.NAME)
    public HashMap getContent() { return content; }

    public void setContent(HashMap content) {
        this.content = content;
    }

/*
    public String getContent() { return content; }

    public void setContent(String content) {
        this.content = content;
    }
*/

    public String getType() {return type;}

    public void setType(String type) {
        this.type = type;
    }

    public String getSubType() {return subType;}

    public void setSubType(String subType) {
        this.subType = subType;
    }

    public boolean getIsPublic() {
        return is_Public;
    }

    public void setIsPublic(boolean is_Public) {
        this.is_Public = is_Public;
    }

}
