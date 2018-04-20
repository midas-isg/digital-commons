package edu.pitt.isg.dc.repository.utils;

import edu.pitt.isg.dc.entry.*;
import edu.pitt.isg.dc.entry.classes.EntryView;
import org.jsoup.Jsoup;
import org.openarchives.oai._2.*;
import org.openarchives.oai._2_0.oai_dc.OaiDcType;
import org.purl.dc.elements._1.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.bind.JAXBElement;
import java.util.*;

/**
 * Created by jdl50 on 5/27/17.
 */
@Component
public class ApiUtil {
    @Autowired
    CategoryOrderRepository categoryOrderRepository;
    @Autowired
    private EntryRepository repo;
    @Autowired
    private CategoryRepository categoryRepository;

    public List<String> getIdentifiers() {
        List<String> unparsedIdentifiers = repo.findPublicIdentifiers();
        List<String> parsedIdentifiers = new ArrayList<>();
        for (String unparsedIdentifier : unparsedIdentifiers) {
            String parsedIdentifier = Jsoup.parse(unparsedIdentifier).text();
            //parsedIdentifier = parsedIdentifier.replaceAll("https?://doi\\.org/", "");
            parsedIdentifiers.add(parsedIdentifier);
        }
        Collections.sort(parsedIdentifiers);
        return parsedIdentifiers;
    }

    public String getAccessUrl(String identifier, String distributionId) {
        if (distributionId == null) distributionId = "0";
        String accessUrl = repo.findAccessUrlByIdentifierAndDistributionId(identifier, distributionId);
        if (accessUrl == null) {
            Map<String, String> parsedToUnparsedIdentifierMap = getParsedToUnparsedIdentifierMapping();
            if (parsedToUnparsedIdentifierMap.containsKey(identifier)) {
                accessUrl = repo.findAccessUrlByIdentifierAndDistributionId(parsedToUnparsedIdentifierMap.get(identifier), distributionId);
            }
        }
        return accessUrl;
    }

    public String getMetadata(String identifier, String header) {
        EntryView entryView = this.getEntryView(identifier);
        if (entryView != null) {
            String metadata = null;
            if (header.equalsIgnoreCase("application/xml")) {
                metadata = entryView.getXmlString();
            } else {
                metadata = entryView.getUnescapedEntryJsonString();
            }
            return metadata;
        }
        return null;
    }

    public String getMetadataType(String identifier) {
        EntryView entryView = this.getEntryView(identifier);

        if (entryView != null) {
            return entryView.getEntryType();
        }

        return null;
    }


    public List<Entry> getPublicEntryContents() {
        return repo.findPublicEntries();
    }

    private Map<String, String> getParsedToUnparsedIdentifierMapping() {
        Map<String, String> parsedToUnparsedIdentifierMap = new HashMap<>();
        for (String unparsedIdentifier : repo.findPublicIdentifiers()) {
            String parsedIdentifier = Jsoup.parse(unparsedIdentifier).text();
            parsedIdentifier = parsedIdentifier.replaceAll("https?://doi\\.org/", "");
            parsedToUnparsedIdentifierMap.put(parsedIdentifier, unparsedIdentifier);
        }
        return parsedToUnparsedIdentifierMap;
    }

    private EntryView getEntryView(String identifier) {
        Entry entry = repo.findByMetadataIdentifier(identifier);

        if (entry == null) {
            Map<String, String> parsedToUnparsedIdentifierMap = getParsedToUnparsedIdentifierMapping();
            if (parsedToUnparsedIdentifierMap.containsKey(identifier)) {
                entry = repo.findByMetadataIdentifier(parsedToUnparsedIdentifierMap.get(identifier));
            }
        }

        if (entry != null) {
            return new EntryView(entry);
        }

        return null;
    }

    public List<Category> getCategoryLineage(String identifier) {
        List<Category> categories = new ArrayList<>();
        Integer categoryId = repo.findCategoryIdByIdentifier(identifier);
        if (categoryId != null) {
            categories.add(categoryRepository.findOne(new Long(categoryId)));
            Integer categoryForSubcategory = categoryOrderRepository.findCategoryIdForSubcategory(categoryId);
            while (categoryForSubcategory != null) {
                categories.add(categoryRepository.findOne(new Long(categoryForSubcategory)));
                categoryForSubcategory = categoryOrderRepository.findCategoryIdForSubcategory(categoryForSubcategory);
            }
        }
        return categories;
    }

//error handling if identifier doesn't exist
/*
4.1 GetRecord
Summary and Usage Notes
This verb is used to retrieve an individual metadata record from a repository. Required arguments specify the
identifier of the item from which the record is requested and the format of the metadata that should be included
in the record. Depending on the level at which a repository tracks deletions, a header with a "deleted" value for
the status attribute may be returned, in case the metadata format specified by the metadataPrefix is no longer
available from the repository or from the specified item.
Arguments
identifier a required argument that specifies the unique identifier of the item in the repository from which the
    record must be disseminated.
metadataPrefix a required argument that specifies the metadataPrefix of the format that should be included in the
    metadata part of the returned record . A record should only be returned if the format specified by the metadataPrefix
    can be disseminated from the item identified by the value of the identifier argument. The metadata formats supported
    by a repository and for a particular record can be retrieved using the ListMetadataFormats request.
 */
public OAIPMHtype getRecord(String identifier){
    OAIPMHtype oaipmHtype = new OAIPMHtype();
    oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.GET_RECORD);

    EntryView entryView = new EntryView();
    entryView = getEntryView(identifier);
    Entry entry = new Entry();
    entry = repo.findOne(entryView.getId());

    RecordType recordType = new RecordType();
    HeaderType headerType = new HeaderType();
    if(entry.getId() != null){
        headerType.setIdentifier(identifier);
    }
    if(entry.getDateAdded() != null){
        XMLGregorianCalendar xmlGregorianCalendar = formatToXMLGregorianCalendar(entry.getDateAdded());
        headerType.setDatestamp(xmlGregorianCalendar.toString());
        //headerType.setDatestamp(entry.getDateAdded().toString());
    }

/*
    headerType.getSetSpec().add(categoryRepository.getCategoryPathForIdentifier(identifier));

    List<String> categories = categoryRepository.getCategoryPathForIdentifier(identifier);
    for(String category : categories){
        headerType.getSetSpec().add(category);
    }
*/
    headerType = getCategoriesforIdentifier(headerType, identifier);
    recordType.setHeader(headerType);
    MetadataType metadataType = new MetadataType();
    if(entry.getContent() != null){
        OaiDcType oaiDcType = setOaiDcType(entry);
        JAXBElement<OaiDcType> jaxbOaiDcType = new org.openarchives.oai._2_0.oai_dc.ObjectFactory().createDc(oaiDcType);
        metadataType.setAny(jaxbOaiDcType);
    }
    recordType.setMetadata(metadataType);
/*
    MetadataType metadataType = new MetadataType();
    if(entry.getContent() != null){
        OaiDcType oaiDcType = new OaiDcType();
        oaiDcType = setOaiDcType(entry);

        metadataType.setAny(oaiDcType);
        //metadataType.setAny(entry.getContent());
    }
    recordType.setMetadata(metadataType);
*/
    GetRecordType getRecordType = new GetRecordType();
    getRecordType.setRecord(recordType);
    oaipmHtype.setGetRecord(getRecordType);

    return oaipmHtype;
}


/*
4.2 Identify
Summary and Usage Notes
This verb is used to retrieve information about a repository. Some of the information returned is required as part of
the OAI-PMH. Repositories may also employ the Identify verb to return additional descriptive information.
 */
public OAIPMHtype getIdentifyInfo(){
    OAIPMHtype oaipmHtype = new OAIPMHtype();
    oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.IDENTIFY);

    IdentifyType identifyType = new IdentifyType();
    identifyType.setRepositoryName("MIDAS Digital Commons");
    identifyType.setBaseURL("http://epimodels.org/apps/mdc");
    //identifyType.getAdminEmail().add("admin@mdc.pitt.edu");
    identifyType.getAdminEmail().add("isg-feedback@list.pitt.edu");
    identifyType.setProtocolVersion("2.0");

    identifyType.setGranularity(GranularityType.YYYY_MM_DD_THH_MM_SS_Z);
    identifyType.setDeletedRecord(DeletedRecordType.NO);
    identifyType.setEarliestDatestamp("2017-10-10T12:30:16Z");
/*
    String earliestDateStamp = "2017-10-10T12:30:16.857000";
    String formatter = "yyyy-MM-dd'T'HH:mm:ss";
    DateFormat format = new SimpleDateFormat(formatter);
    try {
        Date date = format.parse(earliestDateStamp);
    }catch (Exception e){
        System.out.println("Error: " + e);
    }
*/
    oaipmHtype.setIdentify(identifyType);
    return oaipmHtype;
}

/*
4.3 ListIdentifiers
Summary and Usage Notes
This verb is an abbreviated form of ListRecords, retrieving only headers rather than records.
Optional arguments permit selective harvesting of headers based on set membership and/or datestamp.
Depending on the repository's support for deletions, a returned header may have a status attribute of "deleted" if a
record matching the arguments specified in the request has been deleted.
Arguments
from an optional argument with a UTCdatetime value, which specifies a lower bound for datestamp-based selective harvesting.
until an optional argument with a UTCdatetime value, which specifies a upper bound for datestamp-based selective harvesting.
metadataPrefix a required argument, which specifies that headers should be returned only if the metadata
    format matching the supplied metadataPrefix is available or, depending on the repository's support for deletions,
    has been deleted. The metadata formats supported by a repository and for a particular item can be retrieved using
    the ListMetadataFormats request.
set an optional argument with a setSpec value , which specifies set criteria for selective harvesting.
resumptionToken an exclusive argument with a value that is the flow control token returned by a previous
    ListIdentifiers request that issued an incomplete list.
*/
    public OAIPMHtype getIdentifiersList(){
        List<String> unparsedIdentifiers = repo.findPublicIdentifiers();
        ListIdentifiersType listIdentifiersType = new ListIdentifiersType();
        OAIPMHtype oaipmHtype = new OAIPMHtype();
        oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.LIST_IDENTIFIERS);

        for(String unparsedIdentifier : unparsedIdentifiers){
            EntryView entryView = new EntryView();
            entryView = getEntryView(unparsedIdentifier);

            HeaderType headerType = new HeaderType();
            headerType.setIdentifier(unparsedIdentifier);
/*
            if(entryView.getDateAdded() != null){
                XMLGregorianCalendar xmlGregorianCalendar = formatToXMLGregorianCalendar(entryView.getDateAdded());
                headerType.setDatestamp(xmlGregorianCalendar.toString());
                //headerType.setDatestamp(entryView.getDateAdded().toString());
            }
*/
            headerType = getCategoriesforIdentifier(headerType, unparsedIdentifier);

            listIdentifiersType.getHeader().add(headerType);
        }

        oaipmHtype.setListIdentifiers(listIdentifiersType);

        return oaipmHtype;
    }

    private HeaderType getCategoriesforIdentifier(HeaderType headerType,String identifier){
        //String category = categoryRepository.getCategoryPathForIdentifier(identifier);

        List<String> categories;
        //categories = repo.getCategoriesForIdentifier(identifier);
        categories = categoryRepository.getCategoryPathForIdentifier(identifier);
        //categories = repo.getCategoryForIdentifier(unparsedIdentifier);

        //headerType.getSetSpec().add(categoryRepository.findOne(entryView.getCategory().getId()).toString());
        for(String category : categories){
            headerType.getSetSpec().add(category);
        }

        return headerType;

    }

/*
4.4 ListMetadataFormats
Summary and Usage Notes
This verb is used to retrieve the metadata formats available from a repository. An optional argument restricts the
request to the formats available for a specific item.
Arguments
identifier an optional argument that specifies the unique identifier of the item for which available metadata
    formats are being requested. If this argument is omitted, then the response includes all metadata formats
    supported by this repository. Note that the fact that a metadata format is supported by a repository does
    not mean that it can be disseminated from all items in the repository.
*/
public OAIPMHtype getMetadataFormatsAll() {
    //List<String> unparsedTypes = repo.listTypes();
    OAIPMHtype oaipmHtype = new OAIPMHtype();
    oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.LIST_METADATA_FORMATS);
    ListMetadataFormatsType listMetadataFormatsType = new ListMetadataFormatsType();

    MetadataFormatType metadataFormatType = new MetadataFormatType();
    metadataFormatType.setMetadataPrefix("oai_dc");
    metadataFormatType.setMetadataNamespace("http://www.openarchives.org/OAI/2.0/oai_dc.xsd");
    metadataFormatType.setSchema("http://www.openarchives.org/OAI/2.0/oai_dc/");

    //oaipmHtype = getMetadataFormats(oaipmHtype, unparsedTypes);
    listMetadataFormatsType.getMetadataFormat().add(metadataFormatType);
    oaipmHtype.setListMetadataFormats(listMetadataFormatsType);

    return oaipmHtype;
}
/*
    private OAIPMHtype getMetadataFormats(OAIPMHtype oaipmHtype, List<String> unparsedTypes) {
        oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.LIST_METADATA_FORMATS);
        ListMetadataFormatsType listMetadataFormatsType = new ListMetadataFormatsType();

        for (String unparsedType : unparsedTypes) {
            String parsedType = Jsoup.parse(unparsedType).text();
            int lastPeriod = parsedType.lastIndexOf('.');
            int strLength = parsedType.length();
            //metadataFormatType.setMetadataPrefix(parsedType.substring(lastPeriod+1,strLength));
            //metadataFormatType.setMetadataNamespace(parsedType.substring(0,lastPeriod));
            //metadataFormatType.setSchema();

            listMetadataFormatsType.getMetadataFormat().add(metadataFormatType);
        }

        oaipmHtype.setListMetadataFormats(listMetadataFormatsType);

        return oaipmHtype;
    }
*/
/*
    public OAIPMHtype getMetadataFormatsForIdentifier(String identifier) {
        List<String> unparsedTypes = repo.listTypesForIdentifier(identifier);
        OAIPMHtype oaipmHtype = new OAIPMHtype();

        oaipmHtype = getMetadataFormats(oaipmHtype, unparsedTypes);

        return oaipmHtype;
    }
*/
//check Header and Metadata
/*
4.5 ListRecords
Summary and Usage Notes
This verb is used to harvest records from a repository. Optional arguments permit selective harvesting of records based
on set membership and/or datestamp. Depending on the repository's support for deletions, a returned header may have
a status attribute of "deleted" if a record matching the arguments specified in the request has been deleted.
No metadata will be present for records with deleted status.
Arguments
from an optional argument with a UTCdatetime value, which specifies a lower bound for datestamp-based selective harvesting.
until an optional argument with a UTCdatetime value, which specifies a upper bound for datestamp-based selective harvesting.
set an optional argument with a setSpec value , which specifies set criteria for selective harvesting.
resumptionToken an exclusive argument with a value that is the flow control token returned by a previous
    ListRecords request that issued an incomplete list.
metadataPrefix a required argument (unless the exclusive argument resumptionToken is used) that specifies the
    metadataPrefix of the format that should be included in the metadata part of the returned records.
    Records should be included only for items from which the metadata format matching the metadataPrefix can
    be disseminated. The metadata formats supported by a repository and for a particular item can be retrieved
    using the ListMetadataFormats request.
*/
    public OAIPMHtype getRecords(String metadataFormat) {
        //List<Entry> unparsedRecords = getPublicEntryContents();
        List<Entry> unparsedRecords = null;
        Set<String> metadataFormatSet = new HashSet<String>();
        if(metadataFormat != null){
            metadataFormatSet.add(metadataFormat);
            //Currently only supporting 'oai_dc' metadata Format
            //this will need updated if we support other formats
            //in the meantime return all public records
            //unparsedRecords = repo.filterEntryIdsByTypes(metadataFormatSet);
            unparsedRecords = repo.findPublicEntries();
        }
        //List<Entry> unparsedRecords = repo.filterIdsByTypes();
        ListRecordsType listRecordsType = new ListRecordsType();

        OAIPMHtype oaipmHtype = new OAIPMHtype();
        oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.LIST_RECORDS);

        for (Entry unparsedRecord : unparsedRecords) {
            //Entry parsedRecord = Jsoup.parse(unparsedRecord).text();
            RecordType recordType = new RecordType();
            HeaderType headerType = new HeaderType();
            if(unparsedRecord.getId() != null){
                headerType.setIdentifier(unparsedRecord.getId().toString());
            }
            if(unparsedRecord.getDateAdded() != null){
                XMLGregorianCalendar xmlGregorianCalendar = formatToXMLGregorianCalendar(unparsedRecord.getDateAdded());
                headerType.setDatestamp(xmlGregorianCalendar.toString());
                //headerType.setDatestamp(unparsedRecord.getDateAdded().toString());
            }
            recordType.setHeader(headerType);
            MetadataType metadataType = new MetadataType();
            if(unparsedRecord.getContent() != null){
                OaiDcType oaiDcType = setOaiDcType(unparsedRecord);
                JAXBElement<OaiDcType> jaxbOaiDcType = new org.openarchives.oai._2_0.oai_dc.ObjectFactory().createDc(oaiDcType);
                metadataType.setAny(jaxbOaiDcType);
/*
                OaiDcType oaiDcType = new OaiDcType();
                oaiDcType = setOaiDcType(unparsedRecord);

                metadataType.setAny(oaiDcType);
                //metadataType.setAny(unparsedRecord.getContent());
*/
            }
            recordType.setMetadata(metadataType);


            listRecordsType.getRecord().add(recordType);
        }

        oaipmHtype.setListRecords(listRecordsType);

        return oaipmHtype;
    }

//Specify Description for Set
/*
4.6 ListSets
Summary and Usage Notes
This verb is used to retrieve the set structure of a repository, useful for selective harvesting.
Arguments
resumptionToken an exclusive argument with a value that is the flow control token returned by a previous ListSets
    request that issued an incomplete list.
 */
    public OAIPMHtype getSets() {
        List<String> unparsedSets = categoryRepository.findSets();
        ListSetsType listSets = new ListSetsType();

        OAIPMHtype oaipmHtype = new OAIPMHtype();
        oaipmHtype = setDefaultInfoOAIPMHtype(oaipmHtype, VerbType.LIST_SETS);

        for (String unparsedSet : unparsedSets) {
            String parsedSet = Jsoup.parse(unparsedSet).text();
            SetType setType = new SetType();
            setType.setSetSpec(parsedSet);


            String setName = parsedSet;
            setName = setName.replace(": ([Project Tycho Datasets])"," contained in Project Tycho.");
            setName = setName.replace("Root: ","");
            setName = setName.replace("(","");
            setName = setName.replace(")",".");
            setName = setName.replace("Data: ","");
            setName = setName.replaceFirst(":"," for");
            //setName.replace("Software: ","Software for ");
            //setName.replace("Data Formats: ","");
            setName = setName.replaceAll(":"," in");
            setType.setSetName(setName);

            listSets.getSet().add(setType);
        }

        oaipmHtype.setListSets(listSets);

        return oaipmHtype;
    }

//set Date
//look into resumption token --  i believe this token is only pertinent in some cases (ie. ListRecords, ListSets...)
    private OAIPMHtype setDefaultInfoOAIPMHtype(OAIPMHtype oaipmHtype, VerbType verbType){

        RequestType requestType = new RequestType();
        requestType.setVerb(verbType);
        oaipmHtype.setRequest(requestType);

        ListMetadataFormatsType listMetadataFormatsType = new ListMetadataFormatsType();
        MetadataFormatType metadataFormatType = new MetadataFormatType();
        metadataFormatType.setMetadataPrefix("oai_dc");
        metadataFormatType.setMetadataNamespace("http://www.openarchives.org/OAI/2.0/oai_dc.xsd");
        metadataFormatType.setSchema("http://www.openarchives.org/OAI/2.0/oai_dc/");
        listMetadataFormatsType.getMetadataFormat().add(metadataFormatType);

        oaipmHtype.setListMetadataFormats(listMetadataFormatsType);

        Date today = new Date();
        XMLGregorianCalendar xmlGregorianCalendar = formatToXMLGregorianCalendar(today);

        oaipmHtype.setResponseDate(xmlGregorianCalendar);

        return oaipmHtype;

    }

    public XMLGregorianCalendar formatToXMLGregorianCalendar(Date date){
        //String formatter = "yyyy-MM-dd'T'HH:mm:ss'Z'";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        simpleDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        XMLGregorianCalendar xmlGregorianCalendar = null;
        try{
            xmlGregorianCalendar = DatatypeFactory.newInstance().newXMLGregorianCalendar(simpleDateFormat.format(date));
        }
        catch (DatatypeConfigurationException e){
            System.out.println("Error: " + e);
        }

        return xmlGregorianCalendar;
    }

    private OaiDcType setOaiDcType(Entry entry){
        OaiDcType oaiDcType = new OaiDcType();
        HashMap entryMap;
        entryMap = entry.getContent();

        org.purl.dc.elements._1.ObjectFactory elementFactory = new org.purl.dc.elements._1.ObjectFactory();

        //source
        if(((HashMap)entryMap.get("entry")).containsKey("source")){
            ElementType sourceValue = elementFactory.createElementType();
            sourceValue.setValue(((HashMap)entryMap.get("entry")).get("source").toString());
            JAXBElement<ElementType> sourceElement = elementFactory.createSource(sourceValue);
            oaiDcType.getTitleOrCreatorOrSubject().add(sourceElement);
        }

        //title
        if(((HashMap)entryMap.get("entry")).containsKey("title")){
            ElementType titleValue = elementFactory.createElementType();
            titleValue.setValue(((HashMap)entryMap.get("entry")).get("title").toString());
            JAXBElement<ElementType> titleElement = elementFactory.createTitle(titleValue);
            oaiDcType.getTitleOrCreatorOrSubject().add(titleElement);
        }

        //identifier
        if(((HashMap)entryMap.get("entry")).containsKey("identifier")){
            ElementType identifierValue = elementFactory.createElementType();
            identifierValue.setValue(((HashMap)((HashMap)entryMap.get("entry")).get("identifier")).get("identifier").toString());
            JAXBElement<ElementType> identifierElement = elementFactory.createIdentifier(identifierValue);
            oaiDcType.getTitleOrCreatorOrSubject().add(identifierElement);
        }

        //description
        if(((HashMap)entryMap.get("entry")).containsKey("description")){
            ElementType descriptionValue = elementFactory.createElementType();
            descriptionValue.setValue(((HashMap)entryMap.get("entry")).get("description").toString());
            JAXBElement<ElementType> descriptionElement = elementFactory.createDescription(descriptionValue);
            oaiDcType.getTitleOrCreatorOrSubject().add(descriptionElement);
        }
        /*
        ElementType descriptionValue = elementFactory.createElementType();
        if(((HashMap)entryMap.get("entry")).containsKey("humanReadableSynopsis")){
            descriptionValue.setValue(((HashMap)entryMap.get("entry")).get("humanReadableSynopsis").toString());
        }
        JAXBElement<ElementType> descriptionElement = elementFactory.createDescription(descriptionValue);
        oaiDcType.getTitleOrCreatorOrSubject().add(descriptionElement);
        */

        //subject
        if(((HashMap)entryMap.get("entry")).containsKey("isAbout")){
            Map entryHashMap = (LinkedHashMap)entryMap.get("entry");
            List<LinkedHashMap> subject = (ArrayList)entryHashMap.get("isAbout");

            for(Map<String,String> subjectMap : subject) {
                Iterator<String> iterator = subjectMap.keySet().iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    if (key == "name") {
                        String subjectName = subjectMap.get("name");
                        ElementType subjectValue = elementFactory.createElementType();
                        subjectValue.setValue(subjectName);
                        JAXBElement<ElementType> subjectElement = elementFactory.createSubject(subjectValue);
                        oaiDcType.getTitleOrCreatorOrSubject().add(subjectElement);
                    } //if
                } //while
            } //for
        } //if

        //creator
        //ElementType creatorValue = elementFactory.createElementType();
        if(((HashMap)entryMap.get("entry")).containsKey("creators")){
            //HashMap creators = ((HashMap((HashMap)entryMap.get("entry")).get("creators"));
            Map entryHashMap = (LinkedHashMap)entryMap.get("entry");
            List<LinkedHashMap> creators = (ArrayList)entryHashMap.get("creators");

            for(Map<String,String> creatorMap : creators){
                String firstname = "";
                String middleinitial = "";
                String lastname = "";
                String space ="";
                String mispace ="";
                Boolean organization = false;
                String organizationName = "";
                Iterator<String> iterator = creatorMap.keySet().iterator();
                while (iterator.hasNext()){
                    String key = iterator.next();
                    //String value = creatorMap.get(key);
                    if(key == "firstName") {
                        firstname = creatorMap.get(key);
                        space = " ";
                    }
                    if(key == "middleInitial") {
                        middleinitial = creatorMap.get(key);
                        mispace = " ";
                    }
                    if(key == "lastName") {
                        lastname = creatorMap.get(key);
                    }
                    if(key == "type" && creatorMap.get(key) == "organization") {
                        organization = true;
                    }
                    if(organization && key == "description") {
                        organizationName = creatorMap.get(key);
                    }
                    //System.out.println(key + " = " + value);
                }

                ElementType creatorValue = elementFactory.createElementType();
                creatorValue.setValue(firstname + space + middleinitial + mispace + lastname + organization);
                JAXBElement<ElementType> creatorElement = elementFactory.createCreator(creatorValue);
                oaiDcType.getTitleOrCreatorOrSubject().add(creatorElement);
            }
        }

        //publishers
        if(((HashMap)entryMap.get("entry")).containsKey("publishers")){
            Map entryHashMap = (LinkedHashMap)entryMap.get("entry");
            List<LinkedHashMap> publishers = (ArrayList)entryHashMap.get("publishers");

            for(Map<String,String> publisherMap : publishers) {
                Iterator<String> iterator = publisherMap.keySet().iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    if (key == "name") {
                        String publisherName = publisherMap.get("name");
                        ElementType publisherValue = elementFactory.createElementType();
                        publisherValue.setValue(publisherName);
                        JAXBElement<ElementType> publisherElement = elementFactory.createPublisher(publisherValue);
                        oaiDcType.getTitleOrCreatorOrSubject().add(publisherElement);
                    } //if
                } //while
            } //for
        } //if

        //Date
        if(((HashMap)entryMap.get("entry")).containsKey("dates")){
            Map entryHashMap = (LinkedHashMap)entryMap.get("entry");
            List<LinkedHashMap> dates = (ArrayList)entryHashMap.get("dates");

            for(Map<String,String> dateMap : dates) {
                Iterator<String> iterator = dateMap.keySet().iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    if (key == "date") {
                        String date = dateMap.get("name");
                        ElementType dateValue = elementFactory.createElementType();
                        dateValue.setValue(date);
                        JAXBElement<ElementType> dateElement = elementFactory.createDate(dateValue);
                        oaiDcType.getTitleOrCreatorOrSubject().add(dateElement);
/*
                        String formatter = "yyyy-MM-dd";
                        DateFormat format = new SimpleDateFormat(formatter);
                        Date date = null;
                        try {
                            date = format.parse(dateMap.get("date"));
                        }catch (Exception e){
                            System.out.println("Error: " + e);
                        }
                        XMLGregorianCalendar xmlGregorianCalendar = formatToXMLGregorianCalendar(date);
                        ElementType dateValue = elementFactory.createElementType();
                        dateValue.setValue(xmlGregorianCalendar.toString());
                        JAXBElement<ElementType> dateElement = elementFactory.createDate(dateValue);
                        oaiDcType.getTitleOrCreatorOrSubject().add(dateElement);
*/
                    } //if
                } //while
            } //for
        } //if

        //coverage
        if(((HashMap)entryMap.get("entry")).containsKey("spatialCoverage")){
            Map entryHashMap = (LinkedHashMap)entryMap.get("entry");
            List<LinkedHashMap> spatialCoverage = (ArrayList)entryHashMap.get("spatialCoverage");

            for(Map<String,String> spatialCoverageMap : spatialCoverage) {
                Iterator<String> iterator = spatialCoverageMap.keySet().iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    if (key == "name") {
                        String spatialCoverageName = spatialCoverageMap.get("name");
                        ElementType spatialCoverageValue = elementFactory.createElementType();
                        spatialCoverageValue.setValue(spatialCoverageName);
                        JAXBElement<ElementType> coverageElement = elementFactory.createCoverage(spatialCoverageValue);
                        oaiDcType.getTitleOrCreatorOrSubject().add(coverageElement);
                    } //if
                } //while
            } //for
        } //if
/*
        //formats
        if(((HashMap)entryMap.get("entry")).containsKey("distributions")){
            Map entryHashMap = (LinkedHashMap)entryMap.get("entry");
            List<LinkedHashMap> distributions = (ArrayList)entryHashMap.get("distributions");

            for(Map<String,String> distributionsMap : distributions) {
                Iterator<String> iterator = distributionsMap.keySet().iterator();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    if (key == "formats") {
                        ArrayList<String> formats = (distributionsMap.get("formats");
                        String formats = distributionsMap.get("formats");
                        ElementType formatsValue = elementFactory.createElementType();
                        formatsValue.setValue(formats);
                        JAXBElement<ElementType> formatsElement = elementFactory.createFormat(formatsValue);
                        oaiDcType.getTitleOrCreatorOrSubject().add(formatsElement);
                    } //if
                } //while
            } //for
        } //if
*/
        /*
            @XmlElementRef(name = "source", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "title", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "rights", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "identifier", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "description", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "relation", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "contributor", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "subject", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "type", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "creator", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "publisher", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "coverage", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "language", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
            @XmlElementRef(name = "date", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false),
        @XmlElementRef(name = "format", namespace = "http://purl.org/dc/elements/1.1/", type = JAXBElement.class, required = false)

         */


        return oaiDcType;
    }
}
