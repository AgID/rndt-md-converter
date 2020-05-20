# RNDT metadata converter – Quick user guide

RNDT metadata converter is a solution that allows to query an OGC CSW (Catalog Service for the Web) in order to transform the metadata records returned from the 2011 Italian metadata profile (aligned and extending the [INSPIRE metadata TG v. 1.3](https://inspire.ec.europa.eu/documents/inspire-metadata-implementing-rules-technical-guidelines-based-en-iso-19115-and-en-iso-1)) to 2020 Italian metadata profile (aligned and extending the [INSPIRE metadata TG v. 2.0](https://inspire.ec.europa.eu/id/document/tg/metadata-iso19139)).

The solution can be also used for a stricter transformation of metadata from INSPIRE TG v.1.3 to INSPIRE v.2.0 by using the XSLT script for INSPIRE transformation. Also, the XSLT script can be customized in order to transform metadata records against other (own) metadata profiles.

## Usage notes

The figure below shows the converter homepage.



The 3 input fields (parameters) are all required and shall be filled in as follows:

- Organization: the name of the organization (i.e. public administration) provider of metadata records to be transformed.
- Max records: number of records that should be returned from the result set of the query and transformed. The maximum number is set to 100, but it can be changed. Value must be a positive integer.
- Start position: used to indicate at which record position the catalogue should start generating output or the first record to start querying. Value must be a non-zero positive integer.

Then click on **TRANSFORM** button.

The page below appears:



Click on **NEW REQUEST** button to return to the converter homepage and send a new request.

Click on **DOWNLOAD** button to download the result of the transformation, i.e. a compressed folder with the name
_&lt;date&gt;&lt;time&gt;\_&lt;organization-name&gt;.zip_.

The compressed folder (i.e. the output of the transformation) includes the following files:

- ReadMe.txt: a text file with a brief description of the folder content;
- CSWResponseOLD.xml: the CSW GetRecords response from the catalogue queried, based on the 2011 Italian profile / INSPIRE TG v.1.3;
- CSWResponseNEW.xml: the CSW GetRecords response from the catalogue queried, based on the 2020 Italian profile / INSPIRE TG v. 2.0 (i.e. the response CSWResponseOLD.xml transformed through the XSLT script);
- MetadataRecords.zip: a compressed folder that includes the individual metadata records transformed.
