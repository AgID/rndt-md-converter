<?php

header('Content-Type: application/json');

//ini_set('display_errors', 1);
//ini_set('display_startup_errors', 1);
//error_reporting(E_ALL);
error_reporting(0);

setlocale(LC_TIME, 'it_IT');

require_once "function/function.php";

require('./lib/composer/vendor/autoload.php');

class ConvertFile{

    private $xml;
    private $xsl;
    private $proc;

    public function __construct($data,$log){
        if(!empty($log)) $log->push("Create convertFile");
        $this->xml = simplexml_load_string($data);

        $this->xsl = new DOMDocument;
        if (!$this->xsl->load(PATH_XSL_MODEL)) {
            Utility::echoError("Missing xslt script");
        }
    }


    function transformToXML($log){
        if(!empty($log)) $log->push("transformToXML to model");
        // Transforming the source document into RDF/XML oppure json
        
        $this->proc = new XSLTProcessor();
        $this->proc->importStyleSheet($this->xsl);

        if (!$rdf = $this->proc->transformToXML($this->xml)) {
            Utility::echoError("xslt script error");
        }

        return $rdf;
    }

}

class Log_Custom{
    private $dir;
    private $nameFile;

    public function __construct($dir){
        $this->dir = $dir;
        $this->nameFile = "log.txt";
        $this->push("Start log -> ".date('Y-m-d H:i:s',time()), "w");
    }

    public function push($text,$mode = "a"){
        $fp = fopen($this->dir . "/".$this->nameFile,$mode) or Utility::echoError("Error opening file");
        fwrite($fp, $text.PHP_EOL);
        fclose($fp);
    }
}

class DownloadFileCSW{

    static function create_url($log){
        $url = DEFAULT_SITE_CSW_SERVER;
        $url.= "?";

        $urlConfig = PARAM_REQUEST;
        $arrayUrl = explode('&',$urlConfig);

        $pars = array(
            'startPosition' => $_REQUEST["start"],
            'maxRecords' => $_REQUEST["max"]
        );

        foreach ($arrayUrl as $item){
            $explode = explode('=',$item);
            $k = $explode[0];
            $v = $explode[1];

            $url.= $k."=";

            if(!empty($pars[$k])) $v = $pars[$k];

            if($k=="Constraint"){

                $a = str_replace("{PARAMETERVALUE}","PARAMSCUSTOMVALUE",$v);
                $b = urlencode($a);
                $c = str_replace("PARAMSCUSTOMVALUE",$_REQUEST["parametervalue"],$b);
                $url.=$c;
               
            }else{
                $url.=$v."&";
            }
        }


        foreach ($pars as $k=>$v){

            $url.= $k."=";
            if($k=="Constraint"){
                $v = str_replace("PARAMSCUSTOMVALUE",$_REQUEST["parametervalue"],$v);
                $url.=$v;
            }else{
                $url.=$v."&";
            }
        }

        if(!empty($log)) $log->push("Call url-> ".$url);

        return $url;
    }


    static function call_service($url,$log){
        $opts = array(
			"ssl"=>array(
				"verify_peer"=>false,
				"verify_peer_name"=>false,
			),
            'http'=>array(
                'method'=>"GET",
                'header'=>"Accept-language: en\r\n" .
                    "Cookie: foo=bar\r\n" //.
                //"Content-Type: text/xml; charset=utf-8\r\n"
            )
        );
        $context = stream_context_create($opts);

        $file = file_get_contents($url,false,$context);

        if(!empty($log)){
            if($file) $log->push("File call service-> success");
            else $log->push("File call service-> fail");
        }


        return $file;
    }
}

class Utility{

    static function echoError($msg){
        exit(json_encode(
            array(
                "error" => $msg
            )
        ));
    }

    static function echoSuccess($msg = null){
        $msg = $msg ? $msg : "Action successfully performed";
        exit(json_encode(
            array(
                "success" => $msg
            )
        ));
    }

    static function dir_father(){
        $dir = dirname(__FILE__)."/".PATH_ROOT_FILE."/".urldecode($_REQUEST['parametervalue']);

        if (file_exists($dir) && REMOVE_FOLDER){
            self::deleteDir($dir);
        }
        self::control_create_dir($dir);
        return $dir;
    }

    static function dir_child($dir_father){
        $dir = $dir_father."/".date('Y-m-d H.i.s',time());
        self::control_create_dir($dir);
        return $dir;
    }

    public static function deleteDir($dirPath) {

        if (substr($dirPath, strlen($dirPath) - 1, 1) != '/') {
            $dirPath .= '/';
        }
        $files = glob($dirPath . '*', GLOB_MARK);
        foreach ($files as $file) {
            if (is_dir($file)) {
                self::deleteDir($file);
            } else {
                unlink($file);
            }
        }
        rmdir($dirPath);
    }


    static function control_create_dir($dir){
        mkdir($dir, 0777, true);
    }

    static function before_create_zip_file($dir,$arrayFile){

        $pathZipFile = $dir.'/'.FILE_NAME_ZIP;
        $zip = new ZipArchive;
        if ($zip->open($pathZipFile, ZipArchive::CREATE) === TRUE) {
            foreach ($arrayFile as $item){
                $zip->addFromString($item["nameFile"],$item['contentFile']);
            }

            $zip->close();
        }

    }

    static function create_zip_file($dir,$arrayFile){

        Utility::before_create_zip_file($dir,$arrayFile);

        $pathZipFile = $dir.'/'.date('Y-m-d H.i.s',time())."_".urldecode($_REQUEST['parametervalue'])."_".$_REQUEST['start']."-".$_REQUEST['max'].".zip";

        // Initialize archive object
        $zip = new ZipArchive();
        $zip->open($pathZipFile, ZipArchive::CREATE | ZipArchive::OVERWRITE);

        // Initialize empty "delete list"
        $filesToDelete = array();

        // Create recursive directory iterator
        /** @var SplFileInfo[] $files */
        $files = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($dir),
            RecursiveIteratorIterator::LEAVES_ONLY
        );

        foreach ($files as $name => $file) {
            // Skip directories (they would be added automatically)
            if (!$file->isDir()) {
                // Get real and relative path for current file
                $filePath = $file->getRealPath();
                $relativePath = substr($filePath, strlen($dir) + 1);

                // Add current file to archive
                $zip->addFile($filePath, $relativePath);

                $filesToDelete[] = $filePath;
            }
        }

        // Zip archive will be created only after closing object
        $zip->close();

        // Delete all files from "delete list"
        foreach ($filesToDelete as $file) {
            unlink($file);
        }

        //FINAL URL
        $pathZipFile = str_replace(dirname(dirname(__FILE__)),PATH_ROOT,$pathZipFile);

        return $pathZipFile;
    }
}


if(empty($_REQUEST['max']) || empty($_REQUEST['start']) || empty($_REQUEST['parametervalue'])) Utility::echoError("Missing parameters error");


/** ===========================
 *  CREATE FOLDER AND LOG
===========================**/

$path_dir_father = Utility::dir_father();
$path_dir = Utility::dir_child($path_dir_father);

$log = DEBUG ? new Log_Custom($path_dir) : null;


/** ===========================
 *  CREATE URL AND FILE DOWNLOAD
===========================**/

$url = DownloadFileCSW::create_url($log);
$file = DownloadFileCSW::call_service($url,$log);


if($file){

    /** === CREATE REQUEST === **/
    if(!empty($log)) $log->push("Create file request-> ".FILE_NAME_REQUEST);
    $fp = fopen($path_dir . "/".FILE_NAME_REQUEST,"w") or Utility::echoError("Error opening file");
    fwrite($fp, $file);
    fclose($fp);
	
	copy("function/ReadMe.txt",$path_dir."/ReadMe.txt");


    /** === TRANSFORMATION === **/

    if(!empty($log)) $log->push("transformToXML by model");

    $convertFile = new ConvertFile($file,$log);
    $newFile = $convertFile->transformToXML($log);//FILE_NAME_BASE_MODEL
    //$newFile = $file;


    /** === SAVE NEW FILE === **/

    if(!empty($log)) $log->push("Create file response-> ".FILE_NAME_RESPONSE);
    $fp = fopen($path_dir . "/".FILE_NAME_RESPONSE,"w") or Utility::echoError("Error opening file");
    fwrite($fp, $newFile);
    fclose($fp);


    /** === CREATE N INDIVIDUAL FILE FOR METADATA RECORDS === **/

    $xml = new DOMDocument();
    $xml->loadXML($newFile);
    $elements = $xml->getElementsByTagName('MD_Metadata');

    if(!empty($log)) $log->push("Create n file single-> ".$elements->length);

    $count = 1;
    $arrayFile = array();
    foreach($elements as $element){
        array_push($arrayFile, array(
            "nameFile"=> $count++.".xml",
            "contentFile"=> $xml->saveXML($element)
        ));
    }

    if(!empty($log)) $log->push("Create fileZip compress n file single");


    /** === ZIP FILE CREATE === **/

    if(!empty($log)) $log->push("Create fileZip finish");
    $zipFolder = Utility::create_zip_file($path_dir,$arrayFile);
    Utility::echoSuccess($zipFolder);
}else{
    Utility::echoError("Error about creation of file");
}

