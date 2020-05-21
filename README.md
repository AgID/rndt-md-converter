# RNDT metadata converter

La soluzione consente di interrogare un servizio [CSW (Catalogue Service for the Web basato sullo standard OGC)](https://www.ogc.org/standards/cat) ed estrarre i metadati di dati e servizi territoriali trasformati dal profilo definito con il Decreto 10/11/2011 (e relative guide operative, coerenti con le linee guida INSPIRE v. 1.3) al nuovo profilo RNDT 2.0 (v. la [guida operativa](https://geodati.gov.it/geoportale/images/struttura/documenti/Manuale-RNDT_2-guida-operativa-compilazione-metadati_v3.0.pdf), coerente con le linee guida INSPIRE v. 2.0.1).

Essa rappresenta uno strumento utile per supportare le amministrazioni pubbliche nell’adeguamento agli ultimi aggiornamenti dello standard relativo ai metadati per i dati territoriali e relativi servizi.

Essa può essere utilizzata anche per la trasformazione dei metadati dalle [Linee Guida INSPIRE v. 1.3](https://inspire.ec.europa.eu/documents/inspire-metadata-implementing-rules-technical-guidelines-based-en-iso-19115-and-en-iso-1) alle [Linee Guida INSPIRE v.2.0](https://inspire.ec.europa.eu/id/document/tg/metadata-iso19139), utilizzando il relativo script XSLT. 

Lo script XSLT, inoltre, può essere adattato ad altri profili di metadati, come quelli, per esempio, di altri Stati Membri della UE.

## Specifiche
Il RNDT metadata converter effettua richieste GetRecords (metodo GET) per interrogare il servizio CSW ed ottenere i record di metadati da trasformare attraverso lo script XSLT.
I parametri utilizzati per le richieste sono i seguenti

| **Parametro** | **Descrizione** | **Note**  |
| ------------- |-------------| -----|
| organizationName | Nome dell'organizzazione (pubblica amministrazione) titolare di dati e servizi di cui si vogliono estrarre i metadati | Questo parametro può essere cambiato, modificando la richiesta CSW nel file config.properties. |
| maxRecords | Numero massimo di record che si vogliono trasformare | Il valore massimo che è possibile impostare è 100. |
| startPosition | Il numero del record da cui partire per l'interrogazione |    Il valore deve essere un intero diverso da 0 |



## Istruzioni per l'installazione
Istruzioni
