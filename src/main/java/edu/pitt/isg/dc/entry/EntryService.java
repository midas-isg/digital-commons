package edu.pitt.isg.dc.entry;

import edu.pitt.isg.dc.entry.util.EntryListsHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class EntryService {
    @Autowired
    private EntryRepository entryRepository;
    @Autowired
    private EntryListsHelper entryListsHelper;

    public void delete(EntryId id){
        entryRepository.delete(id);
    }

    public void deleteAllInBatch(){
        entryRepository.deleteAllInBatch();
    }

    public Long count() {
        return entryRepository.count();
    }

    public List<Entry> findAllByStatus(String status) {
        return getContentFromEntryLists(entryRepository.findAllByStatus(status));
    }

    public List<Entry> findAll() {
        return getContentFromEntryLists(entryRepository.findAll());
    }
    public void save(Entry s){
        entryRepository.save(s);
    }

    private Entry getContentFromEntryLists(Entry entry){
        //convert ids to content
/*
        if(entry.getContent().containsKey("entry")){
            entry.getContent().put("entry", entryListsHelper.convertListIdToContent((HashMap<String, Object>) entry.getContent().get("entry")));
        }
*/
        return entry;
    }

    private List<Entry> getContentFromEntryLists(List<Entry> entryList){
        List<Entry> revisedEntryList = new ArrayList<Entry>();
        for(Entry entry : entryList){
            revisedEntryList.add(getContentFromEntryLists(entry));
        }

        return revisedEntryList;
    }

    private Page<Entry> getContentFromEntryLists(Page<Entry> entryPage){
        List<Entry> entryList = entryPage.getContent();
        Page<Entry> revisedEntryPage = new PageImpl<>(getContentFromEntryLists(entryList));
        return revisedEntryPage;
    }

    public Entry findOne(EntryId id){
        return getContentFromEntryLists(entryRepository.findOne(id));
    }

    public List<Entry> findLatestUnapprovedEntries() {
        return getContentFromEntryLists(entryRepository.findLatestUnapprovedEntries());
    }

    public List<Entry> findUserLatestUnapprovedEntries(Long userId){
        return getContentFromEntryLists(entryRepository.findUserLatestUnapprovedEntries(userId));
    }

    public Entry getEntryByEntryIdAndMaxRevisionId(Long id){
        return getContentFromEntryLists(entryRepository.getEntryByEntryIdAndMaxRevisionId(id));
    }

    public Entry getEntryByEntryIdAndMaxRevisionIdIncludeNonPublic(Long id){
        return getContentFromEntryLists(entryRepository.getEntryByEntryIdAndMaxRevisionIdIncludeNonPublic(id));
    }

    public List<Entry> findLatestApprovedNotPublicEntries(){
        return getContentFromEntryLists(entryRepository.findLatestApprovedNotPublicEntries());
    }

    public List<Entry> findDistinctPublicEntries(Long entryId, Long revisionId){
        return getContentFromEntryLists(entryRepository.findDistinctPublicEntries(entryId, revisionId));
    }

    public Page<Entry> findAllByIsPublic(boolean status, Pageable pageable){
        return getContentFromEntryLists(entryRepository.findAllByIsPublic(status, pageable));
    }

    public Page<Entry> findByIdIn(Set<EntryId> ids, Pageable pageable){
        return getContentFromEntryLists(entryRepository.findByIdIn(ids, pageable));
    }

    public List<Object[]> filterIdsByFieldAndIdentifierSource(String field, String srcId, Set<String> onlyIds){
        return entryRepository.filterIdsByFieldAndIdentifierSource(field, srcId, onlyIds);
    }

    public Set<String> listIdentifiersByFieldAndIdentifierSource(String field, String srcId){
        return entryRepository.listIdentifiersByFieldAndIdentifierSource(field, srcId);
    }

    public List<Object[]> filterIdsByTypes(Set<String> onlyTypes){
        return entryRepository.filterIdsByTypes(onlyTypes);
    }

    public List<Entry> filterEntryIdsByTypes(Set<String> onlyTypes){
        return getContentFromEntryLists(entryRepository.filterEntryIdsByTypes(onlyTypes));
    }

    public List<Entry> filterEntryIdsByTypesMaxRevisionID(Set<String> onlyTypes){
        return getContentFromEntryLists(entryRepository.filterEntryIdsByTypesMaxRevisionID(onlyTypes));
    }

    public List<String> listTypes(){
        return entryRepository.listTypes();
    }

    public List<String> listTypesForIdentifier(String identifier){
        return entryRepository.listTypesForIdentifier(identifier);
    }

    public List<Object[]> match2Software(){
        return entryRepository.match2Software();
    }

    public List<Object[]> findDataFormats(){
        return entryRepository.findDataFormats();
    }

    public String findDataFormatNameByIdentifier(String dataFormatId){
        return entryRepository.findDataFormatNameByIdentifier(dataFormatId);
    }

    public List<String> findDataFormatsLicenses(){
        return entryRepository.findDataFormatsLicenses();
    }

    public List<String> findDataRepositoryLicenses(){
        return entryRepository.findDataRepositoryLicenses();
    }

    public List<Object[]> spewLocationsAndAccessUrls(){
        return entryRepository.spewLocationsAndAccessUrls();
    }

    public List<String> findPublicIdentifiers(){
        return entryRepository.findPublicIdentifiers();
    }

    public List<String> findFirstClassPublicIdentifiers(){
        return entryRepository.findFirstClassPublicIdentifiers();
    }

    public String findAccessUrlByIdentifierAndDistributionId(String identifier, String distributionId){
        return entryRepository.findAccessUrlByIdentifierAndDistributionId(identifier, distributionId);
    }

    public Entry findByMetadataIdentifier(String identifier){
        return getContentFromEntryLists(entryRepository.findByMetadataIdentifier(identifier));
    }

    public Integer findCategoryIdByIdentifier(String identifier){
        return entryRepository.findCategoryIdByIdentifier(identifier);
    }

    public String findTitleByEntryId(Long entryId){
        return entryRepository.findTitleByEntryId(entryId);
    }

    public Integer findCountOfIdentifier(String identifier){
        return entryRepository.findCountOfIdentifier(identifier);
    }

    public List<Entry> findPublicEntries(){
        return getContentFromEntryLists(entryRepository.findPublicEntries());
    }

    public List<Entry> findFirstClassPublicEntries(){
        return getContentFromEntryLists(entryRepository.findFirstClassPublicEntries());
    }

    public List<String> getCategoryForIdentifier(String identifier){
        return entryRepository.getCategoryForIdentifier(identifier);
    }

    public List<String> getCategoriesForIdentifier(String identifier){
        return entryRepository.getCategoriesForIdentifier(identifier);
    }

    public List<Entry> getListRecordsByDate(java.util.Date from, java.util.Date until){
        return getContentFromEntryLists(entryRepository.getListRecordsByDate(from, until));
    }

    public List<String> getAllIdentifiers(){
        return entryRepository.getAllIdentifiers();
    }

    public String getStatusForIdentifier(String identifier){
        return entryRepository.getStatusForIdentifier(identifier);
    }

    public Entry findByMetadataIdentifierIncludeNotPublic(String identifier){
        return getContentFromEntryLists(entryRepository.findByMetadataIdentifierIncludeNotPublic(identifier));
    }

    public List<Entry> getAllEntriesPertainingToCategory(Long categoryId) {
        List<Long> excludeTopCategoryIds = new ArrayList<>();
        excludeTopCategoryIds.add(0L); // have to add something to the list or the database query will not be happy
/*
        if(categoryId == 9L){ // Disease Forecasters
            excludeTopCategoryIds.add(469L); // Data-format validators
            excludeTopCategoryIds.add(8L); // Data visualizers
            excludeTopCategoryIds.add(6L); // Data-format converters
            excludeTopCategoryIds.add(7L); // Data services
        }
        if(categoryId == 10L){ // Disease Transmission Models
            excludeTopCategoryIds.add(8L); // Data visualizers
            excludeTopCategoryIds.add(6L); // Data-format converters
            excludeTopCategoryIds.add(7L); // Data services
        }
*/
        if(categoryId == 14L){ // Pathogen Evolution Models
            excludeTopCategoryIds.add(448L); // Metagenomic Analytics
            excludeTopCategoryIds.add(15L); // Phylogenetic tree constructors
        }
        return entryRepository.getAllEntriesPertainingToCategory(categoryId, excludeTopCategoryIds);
    }

}
