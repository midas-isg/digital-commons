package edu.pitt.isg.dc.entry;

import com.google.gson.JsonObject;
import edu.pitt.isg.dc.entry.exceptions.DataGovGeneralException;
import edu.pitt.isg.dc.entry.interfaces.EntrySubmissionInterface;
import edu.pitt.isg.dc.entry.interfaces.UsersSubmissionInterface;
import edu.pitt.isg.mdc.dats2_2.*;

import java.text.ParseException;
import java.util.Date;

/**
 * Created by jbs82 on 5/1/2018.
 */
public interface DataGovInterface {
    //https://catalog.data.gov/api/3/action/tag_show?id=nndss
    String searchForTag(String tagId);

    //https://catalog.data.gov/api/3/action/package_show?id=02b5e413-d746-43ee-bd52-eac4e33ecb41
    String searchForPackage(String packageId);

    String getIdentifierFromPackage(DatasetWithOrganization dataGovPackage);

    Boolean identifierExistsInMDC (String identifier, EntryRepository repo);

    String getidentifierStatus(String identifier, EntryRepository repo);

    Entry getEntryFromMDC(String identifier, EntryRepository repo);

    Long getEntryId(Entry entry);

    Long getRevisionId(Entry entry);

    Long getCategoryId(Entry entry);

    Date getlastModifiedDataGov(DatasetWithOrganization dataGovPackage) throws DataGovGeneralException;

    Date getlastModifiedEntry(Entry entry) throws DataGovGeneralException;

    String getRevisionIdFromDataGovPackage(DatasetWithOrganization dataGovPackage);

    String getRevisionIdFromEntry(Entry entry);

    Boolean modifiedDataGovPackage(Entry entry, DatasetWithOrganization dataGovPackage) throws DataGovGeneralException;

    JsonObject datasetToJSonObject(DatasetWithOrganization dataGovPackage);

    String submitDataGovEntry(DatasetWithOrganization dataGovPackage, EntryRepository repo, EntrySubmissionInterface entrySubmissionInterface, UsersSubmissionInterface usersSubmissionInterface) throws DataGovGeneralException;

}
