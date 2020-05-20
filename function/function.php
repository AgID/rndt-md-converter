<?php

require_once dirname(__FILE__)."/config.properties";


define("PATH_ROOT","http://127.0.0.1"); // The URL of the server where the converter is installed

define("DEFAULT_SITE_CSW",$defaultSiteCSW);
define("DEFAULT_SITE_CSW_SERVER",$defaultSiteServerCSW);
define("PARAM_REQUEST",$defaultGetRequest);

define("PATH_XSL_MODEL",$FileXSLT);

define("PATH_ROOT_FILE",$FolderFile);
define("FILE_NAME_REQUEST","cswResponseOLD.xml");
define("FILE_NAME_RESPONSE","cswResponseNEW.xml");
define("FILE_NAME_ZIP","MetadataRecords.zip");

define("MAX_FILE_REQUEST",$MaxRecords);
define("DESCRIPTION",$Description);
define("REMOVE_FOLDER",true);

define("DEBUG",$Debug);



//NOTA BN
//extension=php_xsl.dll
