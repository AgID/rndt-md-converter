# RNDT metadata converter

La soluzione consente di interrogare un servizio [CSW (Catalogue Service for the Web basato sullo standard OGC)](https://www.ogc.org/standards/cat) ed estrarre i metadati di dati e servizi territoriali trasformati dal profilo definito con il Decreto 10/11/2011 (e relative guide operative, coerenti con le linee guida INSPIRE v. 1.3) al nuovo profilo RNDT 2.0 (v. la [guida operativa](https://geodati.gov.it/geoportale/images/struttura/documenti/Manuale-RNDT_2-guida-operativa-compilazione-metadati_v3.0.pdf), coerente con le linee guida INSPIRE v. 2.0.1).

Essa rappresenta uno strumento utile per supportare le amministrazioni pubbliche nell’adeguamento agli ultimi aggiornamenti dello standard relativo ai metadati per i dati territoriali e relativi servizi.

Essa può essere utilizzata anche per la trasformazione dei metadati dalle [Linee Guida INSPIRE v. 1.3](https://inspire.ec.europa.eu/documents/inspire-metadata-implementing-rules-technical-guidelines-based-en-iso-19115-and-en-iso-1) alle [Linee Guida INSPIRE v.2.0](https://inspire.ec.europa.eu/id/document/tg/metadata-iso19139), utilizzando il relativo script XSLT. 

Lo script XSLT, inoltre, può essere adattato ad altri profili di metadati, come quelli, per esempio, di altri Stati Membri della UE.

Per ulteriori informazioni sull'uso del converter, fare riferimento alla [**guida rapida per l'utente**](wiki/Guida-rapida-per-l'utente).

Una installazione della soluzione è disponibile sul [**portale RNDT**](https://geodati.gov.it/rndt-md-converter/).

## Specifiche
Il _RNDT metadata converter_ effettua richieste GetRecords (metodo GET) per interrogare il servizio CSW ed ottenere i record di metadati da trasformare attraverso lo script XSLT.
I parametri utilizzati per le richieste sono i seguenti

| **Parametro** | **Descrizione** | **Note**  |
| ------------- |-------------| -----|
| organizationName | Nome dell'organizzazione (pubblica amministrazione) titolare di dati e servizi di cui si vogliono estrarre i metadati | Questo parametro può essere cambiato, modificando la richiesta CSW nella variabile ```$defaultGetRequest``` nel file [```function/config.properties```](function/config.properties). In caso di modifica, dovrà essere aggiornata anche l'etichetta visualizzata nel form, definita nel file [```index.php```](index.php). Bisogna tenere presente che l'eventuale modifica del parametro impatta anche sul nome del file zip, output della trasformazione. |
| maxRecords | Numero massimo di record che si vogliono trasformare | Il valore massimo che è possibile impostare è 100. Questo valore può essere modificato aggiornando la variabile ```$MaxRecords``` nel file [```function/config.properties```](function/config.properties).  |
| startPosition | Il numero del record da cui partire per l'interrogazione | Il valore deve essere un intero diverso da 0 |

L'output della trasformazione è una cartella compressa (zip) che contiene i seguenti files:

- _ReadMe.txt_: un file di testo riassuntivo del contenuto dello zip;
- _CSWResponseOLD.xml_: la risposta CSW basata sui parametri della richiesta (amministrazione responsabile, numero record iniziale e numero record totali) secondo il profilo RNDT di cui al Decreto 2011 / INSPIRE TG v.1.3;
- _CSWResponseNEW.xml_: la risposta CSW basata sul nuovo profilo (ovvero la risposta CSW CSWResponseOLD.xml trasformata attraverso lo script XSLT);
- _MetadataRecords.zip_: un file zip che contiene i singoli record trasformati e salvati separatamente. I record sono identificati con un numero progressivo.

## Istruzioni per l'installazione
La soluzione è stata sviluppata in PHP 7.1 e gira su qualsiasi web server che ospita quella versione di PHP. Essa è stata testata su Linux, Windows and iOS.

Utilizza le librerie EasyRDF e ML/JSON-LD di PHP che sono [già disponibili nel repository](lib/composer).

Il repository include tutto ciò che è necessario per l'installazione e l'avvio del converter. Prima dell'avvio è necessario modificare le seguenti impostazioni:

- nel file [```function/config.properties```](function/config.properties):
  - inserire l'URL root del servizio CSW da interrogare nella variabile ```$defaultSiteCSW```;
  - inserire l'URL root del server dove è ospitato il servizio CSW nella variabile ```$defaultSiteServerCSW```. Se si vuole interrogare un servizio CSW esterno, allora le due variabili di cui sopra assumono lo stesso URL;
  - inserire il path dello script XSLT nella variabile ```$FileXSLT```;
  - è possibile modificare la richiesta CSW attraverso la variabile ```$defaultGetRequest```. Si può inserire una proprietà diversa (di default quella utilizzata è "apiso.OrganizationName") o un operatore diverso (di default quello utilizzato è "PropertyIsEqualTo"). In caso di modifica della proprietà, dovrà essere aggiornata anche l'etichetta visualizzata nel form, definita nel file [```index.php```](index.php). Bisogna tenere presente, inoltre, che tale modifica impatta anche sul nome del file zip, output della trasformazione. 
  
- nel file [```function/function.php```](function/function.php):
  - inserire l'URL del server dove è installato il converter attraverso la costante ```PATH_ROOT```.
  
Da prestare particolare attenzione alla cartella [```file/```](file), che deve essere inizialmente vuota.  Per poterla aggiungere nel repository, è stato inserito in questa cartella il file vuoto .gitkeep che dopo l'installazione può essere cancellato. Tale cartella viene utilizzata per copiare le cartelle zip contenenti l'output della trasformazione. Per consentire ciò, è necessario che siano abilitati i permessi in scrittura su questa cartella per l'utente del web server.  

### Descrizione in inglese
La descrizione che appare nella prima sezione presente nella pagina iniziale è in italiano. Per passare alla versione in inglese, nel file [```function/config.properties```](function/config.properties) commentare la descrizione in italiano e togliere i commenti dalla descrizione in inglese.  
  
## Trasformazione rispetto ad INSPIRE e ad altri profili di metadati
Se si vuole utilizzare il converter per la trasformazione dei metadati sulla base delle Linee Guida INSPIRE (dalla v. 1.3 alla v. 2.0), senza considerare, quindi, le estensioni introdotte nel profilo nazionale italiano, si deve considerare lo script XSLT per INSPIRE copiandolo e incollandolo nella cartella [```function/```](function).

Da tenere presente:
- la trasformazione si riferisce solo a metadati in inglese;
- nel caso di servizi diversi dai servizi di rete (cioè con serviceType='other'), si assume che il servizio sia un servizio di dati territoriali invocabile. Nel caso in cui non sia così, bisogna intervenire dopo la trasformazione per aggiungere i metadati mancanti;

  
In alternativa, si possono utilizzare altri script XSLT disponibili per la trasformazione INSPIRE, come, per esempio, quello definito nell'ambito di [GeoNetwork](https://github.com/geonetwork/core-geonetwork/blob/master/schemas/iso19139/src/main/plugin/iso19139/process/inspire-tg13-to-tg20.xsl).  

Allo stesso modo, si possono utilizzare script XSLT definiti per profili di metadati di specifiche comunità, come quelli nazionali degli Stati Membri dell'UE. Alcuni esempi di XSLT sono disponibili nella [guida di GeoNetwork](https://geonetwork-opensource.org/manuals/trunk/en/user-guide/describing-information/inspire-editing.html#migrating-from-technical-guidance-version-1-3-to-version-2-0). 

Infine, si possono anche adattare i file XSLT disponibili nel repository a specifici profili di metadati.

In tutti i casi, è necessario che il file XSLT che si decide di utilizzare sia rinominato in "\_\_Transformation.xslt" e sia incollato nella cartella [```function/```](function).

## Licenza
La licenza applicata è [European Union Public License v. 1.2](LICENSE).

## Credits
La soluzione è stata sviluppata da ESRI Italia nell'ambito della gara per le Infrastrutture Nazionali Condivise SPC.
