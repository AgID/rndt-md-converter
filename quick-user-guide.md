# RNDT metadata converter - Guida all'uso

La soluzione permette di interrogare un catalogo CSW ed estrarre i metadati trasformati secondo le specifiche del nuovo profilo RNDT 2.0.

La trasformazione permette ad una PA di ottenere i propri metadati conformi alle nuove regole e, nel caso di qualche informazione mancante, valutare le ulteriori modifiche necessarie da apportare per adeguarli al nuovo profilo.

## Uso dell'applicazione

L'applicazione presenta la seguente maschera iniziale:


I 3 campi di input sono tutti obbligatori e vanno così compilati:

- Organizzazione: il nome della PA di cui si vogliono estrarre i metadati.
- Numero record richiesti: numero dei record che si vogliono trasformare. Il numero massimo è 100.
- Numero primo record: il record da cui partire per l'interrogazione. Ad esempio, per avere i record dal 101 al 150, si possono richiedere 50 record a partire dal numero 101.

Una volta impostati i parametri si può cliccare sul bottone **TRASFORMA**.

Appare quindi la seguente schermata:


Cliccando su **NUOVA RICHIESTA** si ritorna alla pagina iniziale per inserire una nuova richiesta.

Cliccando su **SCARICA** viene richiesto di scaricare un file zip con nome

_&lt;data&gt; &lt;ora&gt;\_&lt;nome amministrazione&gt;.zip_

Il file zip contiene i seguenti files:

- ReadMe.txt: un file di testo riassuntivo del contenuto dello zip;
- CSWResponseOLD.xml: la risposta CSW del catalogo RNDT basata sui parametri della richiesta (amministrazione responsabile, numero record iniziale e numero record totali) secondo il profilo RNDT di cui al Decreto 2011;
- CSWResponseNEW.xml: la risposta CSW del catalogo RNDT secondo il nuovo profilo (ovvero la risposta CSW CSWResponseOLD.xml trasformata attraverso lo script XSLT);
- MetadataRecords.zip: un file zip che contiene i singoli record trasformati e salvati separatamente. I record sono identificati con un numero progressivo.
