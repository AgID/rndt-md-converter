# RNDT metadata converter

La soluzione consente di interrogare un servizio [CSW (Catalogue Service for the Web basato sullo standard OGC)](https://www.ogc.org/standards/cat) ed estrarre i metadati di dati e servizi territoriali trasformati dal profilo definito con il Decreto 10/11/2011 (e relative guide operative, coerenti con le linee guida INSPIRE v. 1.3) al nuovo profilo RNDT 2.0 (v. la [guida operativa](https://geodati.gov.it/geoportale/images/struttura/documenti/Manuale-RNDT_2-guida-operativa-compilazione-metadati_v3.0.pdf), coerente con le linee guida INSPIRE v. 2.0.1).

Essa rappresenta uno strumento utile per supportare le amministrazioni pubbliche nell’adeguamento agli ultimi aggiornamenti dello standard relativo ai metadati per i dati territoriali e relativi servizi.

Essa può essere utilizzata anche per la trasformazione dei metadati dalle [Linee Guida INSPIRE v. 1.3](https://inspire.ec.europa.eu/documents/inspire-metadata-implementing-rules-technical-guidelines-based-en-iso-19115-and-en-iso-1) alle [Linee Guida INSPIRE v.2.0](https://inspire.ec.europa.eu/id/document/tg/metadata-iso19139), utilizzando il relativo script XSLT. 

Lo script XSLT, inoltre, può essere adattato ad altri profili di metadati, come quelli, per esempio, di altri Stati Membri della UE.

## Specifiche
Il _RNDT metadata converter_ effettua richieste GetRecords (metodo GET) per interrogare il servizio CSW ed ottenere i record di metadati da trasformare attraverso lo script XSLT.
I parametri utilizzati per le richieste sono i seguenti

| **Parametro** | **Descrizione** | **Note**  |
| ------------- |-------------| -----|
| organizationName | Nome dell'organizzazione (pubblica amministrazione) titolare di dati e servizi di cui si vogliono estrarre i metadati | Questo parametro può essere cambiato, modificando la richiesta CSW nella variabile ```$defaultGetRequest``` nel file [```function/config.properties```](function/config.properties). In caso di modifica, dovrà essere aggiornata anche l'etichetta visualizzata nel form, definita nel file [```index.php```](index.php). Bisogna tenere presente che l'eventuale modifica del parametro impatta anche sul nome del file zip, output della trasformazione. |
| maxRecords | Numero massimo di record che si vogliono trasformare | Il valore massimo che è possibile impostare è 100. Questo valore può essere modificato aggiornando la variabile ```$MaxRecords``` nel file [```function/config.properties```](function/config.properties).  |
| startPosition | Il numero del record da cui partire per l'interrogazione | Il valore deve essere un intero diverso da 0 |

## Istruzioni per l'installazione
La soluzione è stata sviluppata in PHP 7.1 e gira su qualsiasi web server che ospita quella versione di PHP. Essa è stata testata su Linux, Windows and iOS.

Utilizza le librerie EasyRDF e ML/JSON-LD di PHP che possono essere installate attraverso [Composer](https://getcomposer.org/), ma che sono comunque [già disponibili nel repository](lib/composer).

Il repository include tutto ciò che è necessario per l'installazione e l'avvio del converter. Prima dell'avvio è necessario modificare le seguenti impostazioni:

- nel file [```function/config.properties```](function/config.properties):
  - inserire l'URL root del servizio CSW da interrogare attraverso la variabile ```$defaultSiteCSW```;
  - inserire l'URL root del server dove è ospitato il servizio CSW attraverso la variabile ```$defaultSiteServerCSW```. Se si vuole interrogare un servizio CSW esterno, allora le due variabili di cui sopra assumono lo stesso URL;
  - inserire il path dello script XSLT attraverso la variabile ```$FileXSLT```;
  - è possibile modificare la richiesta CSW attraverso la variabile ```$defaultGetRequest```. Si può inserire una proprietà diversa (di default quella utilizzata è "apiso.OrganizationName") o un operatore diverso (di default quello utilizzato è "PropertyIsEqualTo"). In caso di modifica della proprietà, dovrà essere aggiornata anche l'etichetta visualizzata nel form, definita nel file [```index.php```](index.php). Bisogna tenere presente, inoltre, che tale modifica impatta anche sul nome del file zip, output della trasformazione. 
  
- nel file [```function/function.php```](function/function.php):
  - inserire l'URL del server dove è installato il converter attraverso la costante ```PATH_ROOT```.
