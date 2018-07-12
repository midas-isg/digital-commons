package edu.pitt.isg.dc.entry.classes;

import edu.pitt.isg.mdc.dats2_2.Identifier;
import edu.pitt.isg.mdc.dats2_2.IsAbout;

import javax.xml.bind.annotation.XmlElement;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class IsAboutItems extends IsAbout implements Serializable {

    protected String value;
    protected String valueIRI;
    protected Identifier identifier;
    protected List<Identifier> alternateIdentifiers;
    @XmlElement(required = true)
    protected String name;
    protected String description;

    /**
     * Gets the value of the value property.
     *
     * @return
     *     possible object is
     *     {@link String }
     *
     */
    public String getValue() {
        return value;
    }

    /**
     * Sets the value of the value property.
     *
     * @param value
     *     allowed object is
     *     {@link String }
     *
     */
    public void setValue(String value) {
        this.value = value;
    }

    /**
     * Gets the value of the valueIRI property.
     *
     * @return
     *     possible object is
     *     {@link String }
     *
     */
    public String getValueIRI() {
        return valueIRI;
    }

    /**
     * Sets the value of the valueIRI property.
     *
     * @param value
     *     allowed object is
     *     {@link String }
     *
     */
    public void setValueIRI(String value) {
        this.valueIRI = value;
    }

    /**
     * Gets the value of the identifier property.
     *
     * @return
     *     possible object is
     *     {@link Identifier }
     *
     */
    public Identifier getIdentifier() {
        return identifier;
    }

    /**
     * Sets the value of the identifier property.
     *
     * @param value
     *     allowed object is
     *     {@link Identifier }
     *
     */
    public void setIdentifier(Identifier value) {
        this.identifier = value;
    }

    /**
     * Gets the value of the alternateIdentifiers property.
     *
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the alternateIdentifiers property.
     *
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAlternateIdentifiers().add(newItem);
     * </pre>
     *
     *
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Identifier }
     *
     *
     */
    public List<Identifier> getAlternateIdentifiers() {
        if (alternateIdentifiers == null) {
            alternateIdentifiers = new ArrayList<Identifier>();
        }
        return this.alternateIdentifiers;
    }

    /**
     * Gets the value of the name property.
     *
     * @return
     *     possible object is
     *     {@link String }
     *
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the value of the name property.
     *
     * @param value
     *     allowed object is
     *     {@link String }
     *
     */
    public void setName(String value) {
        this.name = value;
    }

    /**
     * Gets the value of the description property.
     *
     * @return
     *     possible object is
     *     {@link String }
     *
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the value of the description property.
     *
     * @param value
     *     allowed object is
     *     {@link String }
     *
     */
    public void setDescription(String value) {
        this.description = value;
    }

}
