package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import edu.pitt.isg.dc.entry.exceptions.DataGovGeneralException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.mdc.dats2_2.*;
import eu.trentorise.opendata.jackan.model.CkanDataset;

import java.text.ParseException;
import java.util.Date;

/**
 * Created by jbs82 on 5/1/2018.
 */
public interface DataGovInterface {
    //https://catalog.data.gov/api/3/action/tag_show?id=nndss
    String searchForTag(String tagId);

    CkanDataset getDatasetFromClient(String catalogURL, String dataGovIdentifier);

    String getIdentifierFromPackage(DatasetWithOrganization dataGovPackage);

    Boolean identifierExistsInMDC (String identifier);

    String getidentifierStatus(String identifier);

    Entry getEntryFromMDC(String identifier);

    Long getEntryId(Entry entry);

    Long getRevisionId(Entry entry);

    Long getCategoryId(Entry entry);

    Date getlastModifiedDataGov(DatasetWithOrganization dataGovPackage) throws DataGovGeneralException;

    Date getlastModifiedEntry(Entry entry) throws DataGovGeneralException;

    String getRevisionIdFromDataGovPackage(DatasetWithOrganization dataGovPackage);

    String getRevisionIdFromEntry(Entry entry);

    Boolean modifiedDataGovPackage(Entry entry, DatasetWithOrganization dataGovPackage) throws DataGovGeneralException;

    JsonObject datasetToJSonObject(DatasetWithOrganization dataGovPackage);

    String submitDataGovEntry(Users user, String catalogURL, Long categoryId, String dataGovIdentifier, String title) throws DataGovGeneralException;

}
