# RNDT metadata converter

_RNDT metadata converter_ is a reusable solution that allows to query an [OGC CSW (Catalog Service for the Web)](https://www.ogc.org/standards/cat) and transform the metadata records returned from the 2011 Italian metadata profile (aligned and extending the INSPIRE metadata TG v. 1.3) to 2020 Italian metadata profile (aligned and extending the INSPIRE metadata TG v. 2.0).

The solution can be also used for a stricter transformation of metadata from [INSPIRE TG v.1.3](https://inspire.ec.europa.eu/documents/inspire-metadata-implementing-rules-technical-guidelines-based-en-iso-19115-and-en-iso-1) to [INSPIRE TG v.2.0](https://inspire.ec.europa.eu/id/document/tg/metadata-iso19139) by using the [XSLT script for INSPIRE transformation](https://github.com/AgID/rndt-md-converter/tree/master/inspire-xslt). Also, the XSLT script can be adapted in order to transform metadata records against other (own) metadata profiles.

For further information about the use of the converter see the [**quick user guide**](https://github.com/AgID/rndt-md-converter/wiki/Quick-user-guide).

A working installation of the converter is available on the [**RNDT portal**](https://geodati.gov.it/rndt-md-converter/).

## Specification
_RNDT metadata converter_ makes GetRecords requests using the GET method to query the CSW service and transform the metadata records returned through the XSLT script.
The parameters to be used for the requests are included in the table below:

| **Parameter** | **Description** | **Notes**  |
| ------------- |-------------| -----|
| organizationName | The name of the organization (i.e. public administration) provider of metadata records to be transformed. | This parameter can be changed, updating the GetRecords request value in the ```$defaultGetRequest``` variable in the file [```function/config.properties```](function/config.properties). In such a case, the corresponding label in the form (defined in the file [```index.php```](index.php)) shall be updated consequently. Be careful that the update of this parameter will affect the name of the compressed (zip) folder, that is the transformation output. |
| maxRecords | number of records that should be returned from the result set of the query and transformed.  | The maximum number is set to 100, but it can be updated in the ```$MaxRecords``` variable in the file [```function/config.properties```](function/config.properties). Value must be a positive integer.  |
| startPosition | The first record to start querying. | Value must be a non-zero positive integer. |

The transformation output is a compressed folder (zip) including the following files:

- _ReadMe.txt_: a text file with a brief description of the folder content;
- _CSWResponseOLD.xml_: he CSW GetRecords response from the catalogue queried, based on the 2011 Italian profile / INSPIRE TG v.1.3;
- _CSWResponseNEW.xml_: the CSW GetRecords response from the catalogue queried, based on the 2020 Italian profile / INSPIRE TG v. 2.0 (i.e. the response CSWResponseOLD.xml transformed through the XSLT script);
- _MetadataRecords.zip_: a compressed folder that includes the individual metadata records transformed.

## Installation instructions
RNDT metadata converter is developed in PHP 7.1 and runs on top of any web server hosting that PHP version. The converter has been tested on Linux, Windows and iOS with Apache 2.

The EasyRDF and the ML/JSON-LD PHP libraries are used and are [available in the repository](lib/composer).

The repository includes all what is necessary for the installation and running of the converter. Before running it, update the following configuration information:

- in the file [```function/config.properties```](function/config.properties):
  - set the root URL of the CSW service to query in the ```$defaultSiteCSW``` variable;
  - set the root URL to access the CSW server in the ```$defaultSiteServerCSW``` variable. If external, it can be the same root URL used for the $defaultSiteCSW variable;
  - set the path of the XSLT script (included in the same folder) in the ```$FileXSLT``` variable;
  - the CSW GetRecords request in the ```$defaultGetRequest``` variable may (but not necessarily required) be customised modifying the queryable (in the default request "apiso.OrganizationName") and/or the comparison operator (in the default request "PropertyIsEqualTo"). In such a case, the corresponding label in the form (defined in the file [```index.php```](index.php)) shall be updated consequently. Be careful that the update of this parameter will affect the name of the compressed (zip) folder, that is the transformation output. 
  
- in the file [```function/function.php```](function/function.php):
  - set the URL of the server where the converter is installed as value of the constant ```PATH_ROOT```.
  
Pay special attention to the [```file/```](file) folder, that will be initially empty. To add the folder in the repository, the empty file .gitkeep was included in the forder; that file may be removed after the installation. This folder is used to download the compressed folders of the transformation output. Be sure that everything inside this folder has the right read/write/execute permissions.  

### English description
The description shown at the top in the converter homepage is in Italian. To show the English version of this description,  comment the Italian description and uncomment the English one (```$Description``` variable in the file [```function/config.properties```](function/config.properties)).  
  
## Transformation against INSPIRE TGs or other metadata profiles
If you want to use the converter for transforming metadata records against the INSPIRE Technical Guidelines (from v. 1.3 to v. 2.0), then without considering the Italian extensions, the [INSPIRE XSLT script](inspire-xslt) should be used by copying and pasting it in the [```function/```](function) folder.

Be aware that:
- the trasformation refers to metadata records using the English language;
- if the services are not network services (i.e. serviceType='other'), it is assumed that the service is an invocable spatial data service. If that is not the case, further interventions will be needed to add the missing metadata elements;
- in any case, manual checks could be needed.
  
Other XSLT scripts available either for INSPIRE transformation (see, e.g., [GeoNetwork](https://github.com/geonetwork/core-geonetwork/blob/master/schemas/iso19139/src/main/plugin/iso19139/process/inspire-tg13-to-tg20.xsl)) or for specific national metadata profiles (see again [GeoNetwork](https://geonetwork-opensource.org/manuals/trunk/en/user-guide/describing-information/inspire-editing.html#migrating-from-technical-guidance-version-1-3-to-version-2-0)  may be used instead of that one provided in the repository.   

Finally, the XSLT script provided in the repository may be adapted to specific metadata profiles.

In any case, the XSLT file is required to be renamed "\_\_Transformation.xslt" and pasted in the [```function/```](function) folder.

## License
The licence applied is [European Union Public License v. 1.2](LICENSE).

## Credits
The solution is developed by ESRI Italia under the contract for the SPC National Common Infrastructures.
