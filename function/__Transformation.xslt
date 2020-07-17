<?xml version="1.0" encoding="UTF-8"?>
<!--
/* Licensed under the EUPL, Version 1.2 (the "Licence");
  You may not use this work except in compliance with the Licence.
  You may obtain a copy of the Licence at:
 
  https://joinup.ec.europa.eu/sites/default/files/custom-page/attachment/eupl_v1.2_it.pdf
 
 
  Date: 21/05/2020
  AgID - Agenzia per l'Italia Digitale (Agency for Digital Italy)
  - Created by ESRI Italy under the contract for the National Common Infrastructures -
  info@rndt.gov.it

* Converter tool to transform metadata records for spatial datasets (including grid ones), series of datasets and services 
  from RNDT metadata profile defined with the Decree 10 November 2011 (conformant to INSPIRE profile 1.3) to RNDT metadata profile 2.0 (conformant to INSPIRE profile 2.0)
*/ 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation=" http://www.isotc211.org/2005/gmd http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd ">
   <xsl:output method="xml" encoding="UTF-8" indent="yes" />
   <!--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		Dichiarazione di Variabili generali 
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-->

   <xsl:variable name="apice">'</xsl:variable>
   <xsl:variable name="doppioapice">"</xsl:variable>
   <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
   <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
   <!-- hierarchyLevel -->
   	<xsl:variable name="hierarchyLevel">
	   	<xsl:choose>
			<xsl:when test="translate(//gmd:hierarchyLevel/gmd:MD_ScopeCode/text(), $uppercase, $lowercase) = 'servizio' or
					translate(//gmd:hierarchyLevel/gmd:MD_ScopeCode/text(), $uppercase, $lowercase) = 'service' or
					//gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'service'">
				<xsl:value-of select="'servizio'"/>
			</xsl:when>
			<xsl:when test="translate(//gmd:hierarchyLevel/gmd:MD_ScopeCode/text(), $uppercase, $lowercase) = 'dataset'">
				<xsl:value-of select="'dataset'"/>
			</xsl:when>
			<xsl:when test="translate(//gmd:hierarchyLevel/gmd:MD_ScopeCode/text(), $uppercase, $lowercase) = 'series'">
				<xsl:value-of select="'series'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'dataset'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
   <!-- useLimitation -->
   <xsl:variable name="useLimitation">
      <xsl:value-of select="//gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation" />
   </xsl:variable>
   <!-- serviceType -->
   <xsl:variable name="serviceType">
   	<xsl:variable name="appo" select="translate(//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName/text(), $uppercase, $lowercase)"/>
   	<xsl:choose>
			<xsl:when test="$appo = 'servizio di ricerca'">
				<xsl:value-of select="'discovery'"/>
			</xsl:when>
			<xsl:when test="$appo = 'servizio di consultazione'">
				<xsl:value-of select="'view'"/>
			</xsl:when>
			<xsl:when test="$appo = 'servizio di conversione'">
				<xsl:value-of select="'transformation'"/>
			</xsl:when>
			<xsl:when test="$appo = 'servizio di scaricamento'">
				<xsl:value-of select="'download'"/>
			</xsl:when>
			<xsl:when test="$appo = 'servizio di richiesta dei servizi di dati territoriali'">
				<xsl:value-of select="'other'"/>
			</xsl:when>
			<xsl:when test="$appo = 'servizio di richiesta dei servizi'">
				<xsl:value-of select="'other'"/>
			</xsl:when>
			<xsl:when test="$appo = 'altro servizio'">
				<xsl:value-of select="'other'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$appo"/>
			</xsl:otherwise>
		</xsl:choose>
   </xsl:variable>
   <!-- +++++++++++++++++++++++++++++++++ -->
   <!-- +++++++++++++++++++++++++++++++++++++
		Inizio Template 
		+++++++++++++++++++++++++++++++++++++-->
   <!-- Match di tutti i template -->
	<xsl:template name="HeaderTemplate" match="@* | node()">
	  <xsl:copy>
		 <xsl:apply-templates select="@* | node()" />
	  </xsl:copy>
	</xsl:template>
   
    <!-- Aggiunta del namespace gmx e aggiunta dello schema se non esisteva  -->
	<xsl:template name="Namespaces" match="gmd:MD_Metadata">
		<gmd:MD_Metadata 
			xmlns:gmx="http://www.isotc211.org/2005/gmx"
			xsi:schemaLocation="http://www.isotc211.org/2005/gmd https://inspire.ec.europa.eu/draft-schemas/inspire-md-schemas-temp/apiso-inspire/apiso-inspire.xsd">
			<xsl:apply-templates select="@* | node()" />
		</gmd:MD_Metadata>
	</xsl:template>
    <!-- Sostituzione dello schema se già esisteva -->
	<xsl:template match="@xsi:schemaLocation">
			<xsl:choose>
				<xsl:when  test="$hierarchyLevel = 'servizio'">
					<xsl:attribute name="{name()}">
						<xsl:text>http://www.isotc211.org/2005/srv https://inspire.ec.europa.eu/draft-schemas/inspire-md-schemas-temp/apiso-inspire/apiso-inspire.xsd</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="{name()}">
						<xsl:text>http://www.isotc211.org/2005/gmd https://inspire.ec.europa.eu/draft-schemas/inspire-md-schemas-temp/apiso-inspire/apiso-inspire.xsd</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		<xsl:apply-templates select="@* | node()" />
	</xsl:template> 
	
	<!-- Codelist per lingua metadati e dati -->
	<xsl:template match="//gmd:language">
		<xsl:choose>
			<xsl:when test="gmd:LanguageCode/@codeList='http://www.loc.gov/standards/iso639-2/' or gmd:LanguageCode/@codeList='http://www.loc.gov/standards/iso639-2'">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
		</xsl:when>
		<xsl:otherwise>
			<gmd:language>
			<xsl:element name="gmd:LanguageCode">
				<xsl:attribute name="codeList">
					<xsl:text>http://www.loc.gov/standards/iso639-2/</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="codeListValue">
					<xsl:value-of select="gmd:LanguageCode/@codeListValue"/>
				</xsl:attribute>
				<xsl:value-of select="gmd:LanguageCode/text()"/>
				</xsl:element>
			</gmd:language>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template> 
   
   <!-- Character set -->
   <xsl:template match="//gmd:characterSet">
      <xsl:comment>
         <xsl:value-of select="concat(' Se l', $apice, 'elemento ', $doppioapice, 'set di caratteri dei metadati o dei dati', $doppioapice, ' è UTF8 può essere omesso ')" />
      </xsl:comment>
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   </xsl:template>
   <!-- Parent Identifier -->
   <xsl:template match="//gmd:parentIdentifier">
      <xsl:comment>
         <xsl:value-of select="concat(' L', $apice, 'elemento ', $doppioapice, 'Identificativo file precedente', $doppioapice, ' è opzionale e può essere omesso ')" />
      </xsl:comment>
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   </xsl:template>
   <!-- Web site and phone  -->
   <xsl:template match="//gmd:CI_Contact/gmd:phone | //gmd:CI_Contact/gmd:onlineResource">
      <xsl:comment>
         <xsl:value-of select="concat(' Gli elementi ', $doppioapice, 'Telefono e Sito web', $doppioapice, ' non sono più condizionati e possono essere omessi entrambi ')" />
      </xsl:comment>
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   </xsl:template>
   <!-- Hierarchy Level  -->
   <xsl:template match="//gmd:hierarchyLevel">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
      
      <!-- Hierarchy Level Name -->
      	<xsl:if test="gmd:MD_ScopeCode/@codeListValue='service'">
         <xsl:comment>Per i servizi va documentato anche il nome del livello</xsl:comment>
         <gmd:hierarchyLevelName>
            <gco:CharacterString>Servizio</gco:CharacterString>
         </gmd:hierarchyLevelName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//gmd:hierarchyLevelName"/>
   <!-- Metadata standard -->
   <xsl:template match="//gmd:metadataStandardName">
      <xsl:comment>
         <xsl:value-of select="'Il nuovo standard va indicato tramite un link gmx:Anchor'" />
      </xsl:comment>
      <gmd:metadataStandardName>
         <gmx:Anchor xlink:href="http://registry.geodati.gov.it/document/rndt-lg">Linee guida RNDT</gmx:Anchor>
      </gmd:metadataStandardName>
   </xsl:template>
   <xsl:template match="//gmd:metadataStandardVersion">
      <xsl:comment>
         <xsl:value-of select="'La nuova versione dello standard è 2.0'" />
      </xsl:comment>
      <gmd:metadataStandardVersion>
         <gco:CharacterString>2.0</gco:CharacterString>
      </gmd:metadataStandardVersion>
   </xsl:template>
   <!-- INSPIRE themes -->
   <xsl:template match="//gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString[text() = 'GEMET - INSPIRE themes, version 1.0']]">
      <xsl:comment>Per le parole chiave INSPIRE deve essere usata la forma gmx:Anchor</xsl:comment>
      <gmd:MD_Keywords>
         <xsl:for-each select="gmd:keyword">
            <gmd:keyword>
               <xsl:if test="gco:CharacterString = 'Condizioni atmosferiche' or gco:CharacterString = 'Atmospheric conditions'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ac">Condizioni atmosferiche</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Produzione e impianti industriali' or gco:CharacterString = 'Production and industrial facilities'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/pf">Produzione e impianti industriali</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Copertura del suolo' or gco:CharacterString = 'Land cover'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/lc">Copertura del suolo</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Regioni biogeografiche' or gco:CharacterString = 'Bio-geographical regions'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/br">Regioni biogeografiche</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Distribuzione della popolazione - demografia' or gco:CharacterString = 'Population distribution — demography'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/br">Distribuzione della popolazione - demografia</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Regioni marine' or gco:CharacterString = 'Sea regions'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/sr">Regioni marine</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Distribuzione delle specie' or gco:CharacterString = 'Species distribution'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/sd">Distribuzione delle specie</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Reti di trasporto' or gco:CharacterString = 'Transport networks'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/tn">Reti di trasporto</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Edifici' or gco:CharacterString = 'Buildings'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/bu">Edifici</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Risorse energetiche' or gco:CharacterString = 'Energy resources'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/er">Risorse energetiche</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Elementi geografici meteorologici' or gco:CharacterString = 'Meteorological geographical features'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/mf">Elementi geografici meteorologici</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Risorse minerarie' or gco:CharacterString = 'Mineral resources'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/mr">Risorse minerarie</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Elementi geografici oceanografici' or gco:CharacterString = 'Oceanographic geographical features'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/of">Elementi geografici oceanografici</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Salute umana e sicurezza' or gco:CharacterString = 'Human health and safety'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/hh">Salute umana e sicurezza</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Elevazione' or gco:CharacterString = 'Elevation'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/el">Elevazione</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Servizi di pubblica utilità e servizi amministrativi' or gco:CharacterString = 'Utility and governmental services'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/us">Servizi di pubblica utilità e servizi amministrativi</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Geologia' or gco:CharacterString = 'Geology'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ge">Geologia</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Sistemi di coordinate' or gco:CharacterString = 'Coordinate reference systems'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/rs">Sistemi di coordinate</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Habitat e biotopi' or gco:CharacterString = 'Habitats and biotopes'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/hb">Habitat e biotopi</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Sistemi di griglie geografiche' or gco:CharacterString = 'Geographical grid systems'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/gg">Sistemi di griglie geografiche</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Idrografia' or gco:CharacterString = 'Hydrography'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/hy">Idrografia</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Siti protetti' or gco:CharacterString = 'Protected sites'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ps">Siti protetti</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Impianti agricoli e di acquacoltura' or gco:CharacterString = 'Agricultural and aquaculture facilities'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/af">Impianti agricoli e di acquacoltura</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Suolo' or gco:CharacterString = 'Soil'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/so">Suolo</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Impianti di monitoraggio ambientale' or gco:CharacterString = 'Environmental monitoring facilities'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ef">Impianti di monitoraggio ambientale</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Unità amministrative' or gco:CharacterString = 'Administrative units'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/au">Unità amministrative</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Indirizzi' or gco:CharacterString = 'Addresses'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ad">Indirizzi</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Unità statistiche' or gco:CharacterString = 'Statistical units'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/su">Unità statistiche</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Nomi geografici' or gco:CharacterString = 'Geographical names'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/gn">Nomi geografici</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Utilizzo del territorio' or gco:CharacterString = 'Land use'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/lu">Utilizzo del territorio</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Orto immagini' or gco:CharacterString = 'Orthoimagery'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/oi">Orto immagini</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Zone a rischio naturale' or gco:CharacterString = 'Natural risk zones'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/nz">Zone a rischio naturale</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Parcelle catastali' or gco:CharacterString = 'Cadastral parcels'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/cp">Parcelle catastali</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati' or gco:CharacterString = 'Area management/restriction/regulation zones and reporting units'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/am">Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati</gmx:Anchor>
               </xsl:if>
            </gmd:keyword>
         </xsl:for-each>
         <gmd:thesaurusName>
            <gmd:CI_Citation>
               <gmd:title>
                  <gmx:Anchor xlink:href="https://www.eionet.europa.eu/gemet/it/inspire-themes">GEMET - INSPIRE themes, version 1.0</gmx:Anchor>
               </gmd:title>
               <gmd:date>
                  <gmd:CI_Date>
                     <gmd:date>
                        <gco:Date>2008-06-01</gco:Date>
                     </gmd:date>
                     <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication">Pubblicazione</gmd:CI_DateTypeCode>
                     </gmd:dateType>
                  </gmd:CI_Date>
               </gmd:date>
            </gmd:CI_Citation>
         </gmd:thesaurusName>
      </gmd:MD_Keywords>
   </xsl:template>
   <!-- Keywords -->
   <xsl:template match="//gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString[text() = 'GEMET - Concepts, version 2.4']]">
      <gmd:MD_Keywords>
         <xsl:for-each select="gmd:keyword">
            <gmd:keyword>
               <gco:CharacterString>
                  <xsl:value-of select="gco:CharacterString/text()" />
               </gco:CharacterString>
            </gmd:keyword>
         </xsl:for-each>
         <gmd:thesaurusName>
            <gmd:CI_Citation>
               <gmd:title>
                  <gmx:Anchor xlink:href="http://www.eionet.europa.eu/gemet/">GEMET - Concepts, version 2.4</gmx:Anchor>
               </gmd:title>
               <gmd:date>
                  <gmd:CI_Date>
                     <gmd:date>
                        <gco:Date>2010-01-13</gco:Date>
                     </gmd:date>
                     <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication">Pubblicazione</gmd:CI_DateTypeCode>
                     </gmd:dateType>
                  </gmd:CI_Date>
               </gmd:date>
            </gmd:CI_Citation>
         </gmd:thesaurusName>
      </gmd:MD_Keywords>
   </xsl:template>
   <!-- Resource constraints -->
   <xsl:template match="//gmd:resourceConstraints[gmd:MD_Constraints/gmd:useLimitation]">
      <xsl:variable name="otherConstraints">
         <xsl:value-of select="//gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString" />
      </xsl:variable>
      <gmd:resourceConstraints>
         <gmd:MD_LegalConstraints>
            <gmd:accessConstraints>
               <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions">otherRestrictions</gmd:MD_RestrictionCode>
            </gmd:accessConstraints>
            <gmd:otherConstraints>
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">Nessuna limitazione al pubblico accesso</gmx:Anchor>
            </gmd:otherConstraints>
         </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
      <gmd:resourceConstraints>
         <gmd:MD_LegalConstraints>
            <gmd:useConstraints>
               <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions">otherRestrictions</gmd:MD_RestrictionCode>
            </gmd:useConstraints>
            <gmd:otherConstraints>
	     <xsl:choose>
              <xsl:when test="contains(translate(gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString, $uppercase, $lowercase),'nessuna condizione applicabile')">
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/noConditionsApply">Nessuna condizione applicabile</gmx:Anchor>
              </xsl:when>
              <xsl:when test="contains(translate(gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString, $uppercase, $lowercase), 'condizioni sconosciute')">
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/conditionsUnknown">Condizioni sconosciute</gmx:Anchor>
              </xsl:when>
              <xsl:otherwise>  
               <gco:CharacterString>
                  <xsl:value-of select="$useLimitation" />
               </gco:CharacterString>
	      </xsl:otherwise>
            </xsl:choose>  
            </gmd:otherConstraints>
         </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
   </xsl:template>
   <xsl:template match="//gmd:resourceConstraints[gmd:MD_LegalConstraints]">
   </xsl:template>
   <xsl:template match="//gmd:resourceConstraints[gmd:MD_SecurityConstraints]">
      <xsl:comment>La sezione MD_SecurityConstraints è divenuta opzionale.</xsl:comment>
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   </xsl:template>
   <!-- Coordinate reference system -->
   <xsl:template match="//gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code">
      <xsl:choose>
		<xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ETRS89'">
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/4258">
                  <xsl:value-of select="'ETRS89-GRS80'" />
               </gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase)  = 'ETRS89/ETRS-LAEA'">
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/3035">
                  <xsl:value-of select="'ETRS89-LAEA'" />
               </gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ETRS89/ETRS-LCC'">
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/3034">
                  <xsl:value-of select="'ETRS89-LCC'" />
               </gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ETRS89/UTM-ZONE32N'">
            <!-- Manca code -->
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/25832">
                  <xsl:value-of select="'ETRS89-UTM32N'" />
               </gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ETRS89/UTM-ZONE33N'">
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/25833">
                  <xsl:value-of select="'ETRS89-UTM33N'" />
               </gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ROMA40/EST'">
            <xsl:comment>Il nome del sistema di riferimento è stato aggiornato al nuovo standard</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/3004">Monte-Mario-Italy2</gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ROMA40/OVEST'">
            <xsl:comment>Il nome del sistema di riferimento è stato aggiornato al nuovo standard</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/3003">Monte-Mario-Italy1</gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ED50/UTM 32N'">
            <xsl:comment>Il nome del sistema di riferimento è stata aggiornato al nuovo standard</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/23032">ED50-UTM32N</gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ED50/UTM 33N'">
            <xsl:comment>Il nome del sistema di riferimento è stata aggiornato al nuovo standard</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/23033">ED50-UTM33N</gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ROMA40'">
            <xsl:comment>Il nome del sistema di riferimento è stata aggiornato al nuovo standard</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/4265">Monte-Mario</gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ROMA40/ROMA'">
            <xsl:comment>Il nome del sistema di riferimento è stata aggiornato al nuovo standard</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/4806">Monte-Mario-Rome</gmx:Anchor>
            </gmd:code>
         </xsl:when>
         <xsl:when test="translate(gco:CharacterString, $lowercase, $uppercase) = 'ED50'">
            <gmd:code>
               <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/4230">
                  <xsl:value-of select="gco:CharacterString/text()" />
               </gmx:Anchor>
            </gmd:code>
         </xsl:when>
		 <xsl:when test="contains(translate(gco:CharacterString, $lowercase, $uppercase), 'WGS84')">
            <xsl:comment>Il sistema di riferimento WGS84 non e' un CRS valido per INSPIRE</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href=""></gmx:Anchor>
            </gmd:code>
			</xsl:when>
         <xsl:otherwise>
            <xsl:comment>Sistema di riferimento mancante o non riconosciuto</xsl:comment>
            <gmd:code>
               <gmx:Anchor xlink:href=""></gmx:Anchor>
            </gmd:code>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- Temporal extent -->
   <xsl:template match="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent">
   <gmd:extent>
   <xsl:element name="gml:TimePeriod">
   <xsl:attribute name="gml:id"><xsl:value-of select="gml:TimePeriod/@gml:id"/></xsl:attribute>
    <gml:beginPosition><xsl:value-of select="gml:TimePeriod/gml:beginPosition/text()"/></gml:beginPosition>
    <xsl:choose>
    	<xsl:when test="gml:TimePeriod/gml:endPosition=''">             
      	<gml:endPosition indeterminatePosition="now"/>
      	</xsl:when>
      	<xsl:otherwise>
      	<gml:endPosition><xsl:value-of select="gml:TimePeriod/gml:endPosition"/></gml:endPosition>
      	</xsl:otherwise>
      	</xsl:choose>
	</xsl:element>
	</gmd:extent>
   </xsl:template>
   <!-- Distribution Format -->
   <xsl:template match="//gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString">
      <xsl:comment>Per il nome e la versione del formato va utilizzato il link gmx:Anchor e la lista presente all'indirizzo http://inspire.ec.europa.eu/media-types.</xsl:comment>
      <xsl:variable name="formatURI">
         <xsl:choose>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'shp') or contains(translate(., $uppercase, $lowercase), 'shape')">
               <xsl:value-of select="'http://inspire.ec.europa.eu/media-types/application/x-shapefile'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'zip')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/application/zip'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'kml')">
               <xsl:value-of select="'http://www.iana.org/assignments/media-types/application/vnd.google-earth.kml+xml'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'tif')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/image/tiff'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'jpg') or contains(translate(., $uppercase, $lowercase), 'jpeg')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/image/jp2'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'ecw')">
               <xsl:value-of select="'http://inspire.ec.europa.eu/media-types/application/x-ecw'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'csv')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/text/csv'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'gml')">
               <xsl:value-of select="'http://www.iana.org/assignments/media-types/application/gml+xml'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'geojson')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/application/geo+json'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'rdf')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/application/rdf+xml'" />
            </xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'xml')">
               <xsl:value-of select="'https://www.iana.org/assignments/media-types/application/xml'" />
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="format">
         <xsl:choose>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'shp') or contains(translate(., $uppercase, $lowercase), 'shape')">x-shapefile</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'zip')">zip</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'kml')">vnd.google-earth.kml+xml</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'tif')">tiff</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'jpg') or contains(translate(., $uppercase, $lowercase), 'jpeg')">jp2</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'ecw')">x-ecw</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'csv')">csv</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'gml')">gml+xml</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'geojson')">geo+json</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'rdf')">rdf+xml</xsl:when>
            <xsl:when test="contains(translate(., $uppercase, $lowercase), 'xml')">xml</xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="$formatURI != ''">
         <gmx:Anchor>
            <xsl:attribute name="xlink:href">
               <xsl:value-of select="$formatURI" />
            </xsl:attribute>
            <xsl:value-of select="$format" />
         </gmx:Anchor>
      </xsl:if>
      <xsl:if test="$formatURI = ''">
         <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
         </xsl:copy>
      </xsl:if>
   </xsl:template>
   <!--  Service Type -->
   <xsl:template match="//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName">
      <gco:LocalName codeSpace="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType/{$serviceType}">
         <xsl:value-of select="$serviceType" />
      </gco:LocalName>
   </xsl:template>
   <!--  Risorsa online -->
   <xsl:template match="//gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource">
      <gmd:CI_OnlineResource>
         <xsl:variable name="hierarchyLevel_loc" select="../../../../../../gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
         <xsl:if test="$hierarchyLevel_loc= 'service'">
            <gmd:linkage>
                        <gmd:URL><xsl:value-of select="gmd:linkage/gmd:URL"/></gmd:URL>
                     </gmd:linkage>
            <xsl:if test="translate(../../../../../../gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName, $uppercase, $lowercase) = 'other'">
               <gmd:description>
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/accessPoint">accessPoint</gmx:Anchor>
               </gmd:description>
               <gmd:function>
                  <gmd:CI_OnLineFunctionCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_OnLineFunctionCode" codeListValue="information">information</gmd:CI_OnLineFunctionCode>
               </gmd:function>
            </xsl:if>
         </xsl:if>
         <xsl:if test="$hierarchyLevel_loc != 'service'">
            <xsl:variable name="protocol" select="translate(gmd:protocol/*/text(), $lowercase, $uppercase)" />
            <xsl:variable name="url" select="translate(gmd:linkage/gmd:URL/text(), $lowercase, $uppercase)" />
            <xsl:variable name="protocolFound">
               <xsl:choose>
                  <xsl:when test="contains($protocol, 'WMS') or contains($url, 'WMS')">
                     <xsl:value-of select="'Web Map Service (WMS)'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'WFS') or contains($url, 'WFS')">
                     <xsl:value-of select="'Web Feature Service (WFS)'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'CSW') or contains($url, 'CSW')">
                     <xsl:value-of select="'Catalogue Service for the Web (CSW)'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'ATOM') or contains($url, 'ATOM')">
                     <xsl:value-of select="'ATOM'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'WCS') or contains($url, 'WCS')">
                     <xsl:value-of select="'Web Coverage Service (WCS)'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'SOS') or contains($url, 'SOS')">
                     <xsl:value-of select="'Sensor Observation Service (SOS)'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'WMTS') or contains($url, 'WMTS')">
                     <xsl:value-of select="'Web Map Tile Service (WMTS)'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'DOWNLOAD') or contains($url, 'DOWNLOAD') or contains($url, 'ZIP')">
                     <xsl:value-of select="'WWW:DOWNLOAD-1.0-http--download'" />
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'WWW:LINK-1.0-http--link'" />
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="linkProtocol">
               <xsl:choose>
                  <xsl:when test="contains($protocol, 'WMS') or contains($url, 'WMS')">
                     <xsl:value-of select="'http://www.opengis.net/def/serviceType/ogc/wms'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'WFS') or contains($url, 'WFS')">
                     <xsl:value-of select="'http://www.opengis.net/def/serviceType/ogc/wfs'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'CSW') or contains($url, 'CSW')">
                     <xsl:value-of select="'http://www.opengis.net/def/serviceType/ogc/csw'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'ATOM') or contains($url, 'ATOM')">
                     <xsl:value-of select="'https://tools.ietf.org/html/rfc4287'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'WCS') or contains($url, 'WCS')">
                     <xsl:value-of select="'http://www.opengis.net/def/serviceType/ogc/wcs'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'SOS') or contains($url, 'SOS')">
                     <xsl:value-of select="'http://www.opengis.net/def/serviceType/ogc/sos'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'WMTS') or contains($url, 'WMTS')">
                     <xsl:value-of select="'http://www.opengis.net/def/serviceType/ogc/wmts'" />
                  </xsl:when>
                  <xsl:when test="contains($protocol, 'DOWNLOAD') or contains($url, 'DOWNLOAD') or contains($url, 'ZIP')">
                     <xsl:value-of select="'https://registry.geodati.gov.it/metadata-codelist/ProtocolValue/www-download'" />
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'http://www.w3.org/TR/xlink/'" />
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <gmd:linkage>
               <gmd:URL>
                  <xsl:value-of select="gmd:linkage/gmd:URL" />
               </gmd:URL>
            </gmd:linkage>
            <gmd:protocol>
               <gmx:Anchor xlink:href="{$linkProtocol}">
                  <xsl:value-of select="$protocolFound" />
               </gmx:Anchor>
            </gmd:protocol>
            <!-- Application profile -->
            <xsl:variable name="applicationProfile" select="translate(gmd:applicationProfile/*/text(), $lowercase, $uppercase)" />
            <xsl:variable name="applicationProfileFound">
               <xsl:choose>
                  <xsl:when test="contains($applicationProfile, 'OTHER')">
                     <xsl:value-of select="'other'" />
                  </xsl:when>
                  <xsl:when test="contains($applicationProfile, 'DISCOVERY')">
                     <xsl:value-of select="'discovery'" />
                  </xsl:when>
                  <xsl:when test="contains($applicationProfile, 'VIEW') or contains($url, 'WMS') or contains($url, 'WMTS')">
                     <xsl:value-of select="'view'" />
                  </xsl:when>
                  <xsl:when test="contains($applicationProfile, 'DOWNLOAD') or contains($url, 'WFS') or contains($url, 'ATOM')">
                     <xsl:value-of select="'download'" />
                  </xsl:when>
                  <xsl:when test="contains($applicationProfile, 'TRANSFORMATION')">
                     <xsl:value-of select="'transformation'" />
                  </xsl:when>
                  <xsl:when test="contains($applicationProfile, 'INVOKE')">
                     <xsl:value-of select="'invoke'" />
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'other'" />
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <xsl:variable name="linkApplicationProfile" select="concat('http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType/', $applicationProfileFound)" />
            <gmd:applicationProfile>
               <gmx:Anchor xlink:href="{$linkApplicationProfile}">
                  <xsl:value-of select="$applicationProfileFound" />
               </gmx:Anchor>
            </gmd:applicationProfile>
            <!-- Description -->
            <gmd:description>
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/OnLineDescriptionCode/accessPoint">accessPoint</gmx:Anchor>
            </gmd:description>
         </xsl:if>
      </gmd:CI_OnlineResource>
   </xsl:template>
   <xsl:template match="//gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:description[../../../../../../../gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName = 'other']" />
   <!-- Quality scope  -->
   <xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
      <xsl:if test="$hierarchyLevel = 'servizio'">
               <gmd:levelDescription>
                  <gmd:MD_ScopeDescription>
                     <gmd:other>
                        <gco:CharacterString>Servizio</gco:CharacterString>
                     </gmd:other>
                  </gmd:MD_ScopeDescription>
               </gmd:levelDescription>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:levelDescription" />
   <!-- Conformance-->
   <!-- Viene specificata la conformità ai Regolamenti INSPIRE sostituendo quella già presente -->
	<xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report[./gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[contains(.,'REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE')]]">
		<!-- Va indicata l'aderenza alla normativa -->
		<xsl:comment>Viene specificata l'aderenza alle normative INSPIRE</xsl:comment>
		<gmd:report>
			<gmd:DQ_DomainConsistency>
				<gmd:result>
					<gmd:DQ_ConformanceResult>
						<gmd:specification>
							<gmd:CI_Citation>
								<gmd:title>
									<gmx:Anchor xlink:href="http://data.europa.eu/eli/reg/2010/1089">REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE del 23 novembre 2010 recante attuazione della direttiva 2007/2/CE del Parlamento europeo e del Consiglio per quanto riguarda l'interoperabilità dei set di dati territoriali e dei servizi di dati territoriali</gmx:Anchor>
								</gmd:title>
								<gmd:date>
									<gmd:CI_Date>
										<gmd:date>
											<gco:Date>2010-12-08</gco:Date>
										</gmd:date>
										<gmd:dateType>
											<gmd:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication">publication</gmd:CI_DateTypeCode>
										</gmd:dateType>
									</gmd:CI_Date>
								</gmd:date>
							</gmd:CI_Citation>
						</gmd:specification>
						<gmd:explanation>
							<gco:CharacterString>Fare riferimento alle specifiche indicate</gco:CharacterString>
						</gmd:explanation>
						<gmd:pass gco:nilReason="unknown"/>
					</gmd:DQ_ConformanceResult>
				</gmd:result>
			</gmd:DQ_DomainConsistency>
		</gmd:report>	  
	</xsl:template>
	
	<!-- Se la conformità non è specificata (nel caso di un servizio) va inserita. Si inserisce dopo l'ultimo nodo "report" -->
	<xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report[not (./gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[contains(.,'REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE')])][last()]">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
		<!-- Lo devo aggiungere solo se non c'era -->
		<xsl:if test="count(//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/*[contains(.,'REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE')]) = 0">
			<xsl:comment>Viene specificata l'aderenza alle normative INSPIRE</xsl:comment>
			<gmd:report>
				<gmd:DQ_DomainConsistency>
					<gmd:result>
						<gmd:DQ_ConformanceResult>
							<gmd:specification>
								<gmd:CI_Citation>
									<gmd:title>
										<gmx:Anchor xlink:href="http://data.europa.eu/eli/reg/2010/1089">REGOLAMENTO (UE) N. 1089/2010 DELLA COMMISSIONE del 23 novembre 2010 recante attuazione della direttiva 2007/2/CE del Parlamento europeo e del Consiglio per quanto riguarda l'interoperabilità dei set di dati territoriali e dei servizi di dati territoriali</gmx:Anchor>
									</gmd:title>
									<gmd:date>
										<gmd:CI_Date>
											<gmd:date>
												<gco:Date>2010-12-08</gco:Date>
											</gmd:date>
											<gmd:dateType>
												<gmd:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication">publication</gmd:CI_DateTypeCode>
											</gmd:dateType>
										</gmd:CI_Date>
									</gmd:date>
								</gmd:CI_Citation>
							</gmd:specification>
							<gmd:explanation>
								<gco:CharacterString>Fare riferimento alle specifiche indicate</gco:CharacterString>
							</gmd:explanation>
							<gmd:pass gco:nilReason="unknown"/>
						</gmd:DQ_ConformanceResult>
					</gmd:result>
				</gmd:DQ_DomainConsistency>
			</gmd:report>
		</xsl:if>	  
     <!-- Service category -->
      <!-- Se è un servizio e serviceType='other' si assume che sia 'invocable' -->
      <xsl:if test="$hierarchyLevel = 'servizio' and $serviceType = 'other'">
         <gmd:report>
            <gmd:DQ_DomainConsistency>
               <gmd:result>
                  <gmd:DQ_ConformanceResult>
                     <gmd:specification>
                        <gmd:CI_Citation>
                           <gmd:title>
                              <gmx:Anchor xlink:href=" http://inspire.ec.europa.eu/id/ats/metadata/2.0/sds-invocable" xlink:title="INSPIRE Invocable Spatial Data Services metadata">invocable</gmx:Anchor>
                           </gmd:title>
                           <gmd:date>
                              <gmd:CI_Date>
                                 <gmd:date>
                                    <gco:Date>2016-05-01</gco:Date>
                                 </gmd:date>
                                 <gmd:dateType>
                                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication">publication</gmd:CI_DateTypeCode>
                                 </gmd:dateType>
                              </gmd:CI_Date>
                           </gmd:date>
                        </gmd:CI_Citation>
                     </gmd:specification>
                     <gmd:explanation>
                        <gco:CharacterString>This Spatial Data Service set is conformant with the INSPIRE requirements for Invocable Spatial Data Services</gco:CharacterString>
                     </gmd:explanation>
                     <gmd:pass>
                        <gco:Boolean>true</gco:Boolean>
                     </gmd:pass>
                  </gmd:DQ_ConformanceResult>
               </gmd:result>
            </gmd:DQ_DomainConsistency>
         </gmd:report>
      </xsl:if>
   </xsl:template>
   <!-- Keywords for services -->
   <xsl:template match="//srv:SV_ServiceIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString">
      <xsl:choose>
         <xsl:when test="text() = 'Servizi geografici con interazione umana' or text() = 'humanInteractionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanInteractionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Visualizzatore del catalogo' or text() = 'humanCatalogueViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanCatalogueViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Visualizzatore geografico' or text() = 'humanGeographicViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Visualizzatore di fogli elettronici geografici' or text() = 'humanGeographicSpreadsheetViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicSpreadsheetViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Editor di servizi' or text() = 'humanServiceEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanServiceEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Editor per la definizione di catene' or text() = 'humanChainDefinitionEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanChainDefinitionEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Gestore di esecuzione del workflow' or text() = 'humanWorkflowEnactmentManager'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanWorkflowEnactmentManager">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Editor di elementi geografici (geographic feature)' or text() = 'humanGeographicFeatureEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicFeatureEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Editor di simboli geografici' or text() = 'humanGeographicSymbolEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicSymbolEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Editor di generalizzazione di elementi (feature)' or text() = 'humanFeatureGeneralizationEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanFeatureGeneralizationEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Visualizzatore della struttura dei dati geografici' or text() = 'humanGeographicDataStructureViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicDataStructureViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di gestione dei modelli/informazioni geografiche' or text() = 'infoManagementService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoManagementService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di accesso a elementi (feature)' or text() = 'infoFeatureAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoFeatureAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di accesso a mappe (map)' or text() = 'infoMapAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoMapAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di accesso a coperture (coverage)' or text() = 'infoCoverageAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoCoverageAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di descrizione dei sensori' or text() = 'infoSensorDescriptionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoSensorDescriptionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di accesso ai prodotti' or text() = 'infoProductAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoProductAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di tipi di elementi (feature type)' or text() = 'infoFeatureTypeService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoFeatureTypeService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di catalogo' or text() = 'infoCatalogueService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoCatalogueService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio toponimico' or text() = 'infoGazetteerService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoGazetteerService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di gestione degli ordini' or text() = 'infoOrderHandlingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoOrderHandlingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di ordini permanenti' or text() = 'infoStandingOrderService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoStandingOrderService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di gestione di workflow/compiti geografici' or text() = 'taskManagementService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/taskManagementService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di definizione di catene' or text() = 'chainDefinitionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/chainDefinitionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di esecuzione del workflow' or text() = 'workflowEnactmentService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/workflowEnactmentService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di abbonamento' or text() = 'subscriptionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/subscriptionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di trattamento geografico — aspetti territoriali' or text() = 'spatialProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di conversione delle coordinate' or text() = 'spatialCoordinateConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialCoordinateConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di trasformazione delle coordinate' or text() = 'spatialCoordinateTransformationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialCoordinateTransformationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di conversione di raster/vettoriale' or text() = 'spatialCoverageVectorConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialCoverageVectorConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di conversione delle coordinate delle immagini' or text() = 'spatialImageCoordinateConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialImageCoordinateConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di rettifica' or text() = 'spatialRectificationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialRectificationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di ortorettifica' or text() = 'spatialOrthorectificationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialOrthorectificationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di adeguamento dei modelli geometrici dei sensori' or text() = 'spatialSensorGeometryModelAdjustmentService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialSensorGeometryModelAdjustmentService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di conversione dei modelli geometrici delle immagini' or text() = 'spatialImageGeometryModelConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialImageGeometryModelConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di definizione dei sottoinsiemi' or text() = 'spatialSubsettingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialSubsettingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di campionamento' or text() = 'spatialSamplingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialSamplingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di modifica della mosaicatura (tiling)' or text() = 'spatialTilingChangeService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialTilingChangeService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di misura delle dimensioni' or text() = 'spatialDimensionMeasurementService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialDimensionMeasurementService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di manipolazione degli elementi geografici' or text() = 'spatialFeatureManipulationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialFeatureManipulationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di corrispondenza di elementi' or text() = 'spatialFeatureMatchingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialFeatureMatchingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di generalizzazione di elementi' or text() = 'spatialFeatureGeneralizationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialFeatureGeneralizationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di determinazione dell' + $apice + 'itinerario' or text() = 'spatialRouteDeterminationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialRouteDeterminationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di posizionamento' or text() = 'spatialPositioningService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialPositioningService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di analisi di prossimità' or text() = 'spatialProximityAnalysisService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialProximityAnalysisService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di trattamento geografico — aspetti tematici' or text() = 'thematicProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di calcolo dei geoparametri' or text() = 'thematicGoparameterCalculationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGoparameterCalculationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di classificazione tematica' or text() = 'thematicClassificationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicClassificationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di generalizzazione di elementi' or text() = 'thematicFeatureGeneralizationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicFeatureGeneralizationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di definizione dei sottoinsiemi' or text() = 'thematicSubsettingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicSubsettingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di conteggio territoriale' or text() = 'thematicSpatialCountingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicSpatialCountingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di rilevazione dei cambiamenti' or text() = 'thematicChangeDetectionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicChangeDetectionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di estrazione di informazioni geografiche' or text() = 'thematicGeographicInformationExtractionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGeographicInformationExtractionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di trattamento delle immagini' or text() = 'thematicImageProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di riduzione della risoluzione' or text() = 'thematicReducedResolutionGenerationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicReducedResolutionGenerationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di manipolazione delle immagini' or text() = 'thematicImageManipulationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageManipulationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di comprensione di immagini' or text() = 'thematicImageUnderstandingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageUnderstandingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di sintesi di immagini' or text() = 'thematicImageSynthesisService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageSynthesisService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Manipolazione di immagini multibanda' or text() = 'thematicMultibandImageManipulationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicMultibandImageManipulationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di rilevazione di oggetti' or text() = 'thematicObjectDetectionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicObjectDetectionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di analisi sintattica (geoparsing)' or text() = 'thematicGeoparsingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGeoparsingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di geocodifica' or text() = 'thematicGeocodingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGeocodingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di processamento geografico — aspetti temporali' or text() = 'temporalProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di trasformazione del sistema di riferimento temporale' or text() = 'temporalReferenceSystemTransformationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalReferenceSystemTransformationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di definizione dei sottoinsiemi' or text() = 'temporalSubsettingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalSubsettingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di campionamento' or text() = 'temporalSamplingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalSamplingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di analisi di prossimità temporale' or text() = 'temporalProximityAnalysisService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalProximityAnalysisService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di processamento geografico — metadati' or text() = 'metadataProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/metadataProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di calcolo statistico' or text() = 'metadataStatisticalCalculationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/metadataStatisticalCalculationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di annotazione geografica' or text() = 'metadataGeographicAnnotationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/metadataGeographicAnnotationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizi di comunicazione geografica' or text() = 'comService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di codifica' or text() = 'comEncodingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comEncodingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di trasferimento' or text() = 'comTransferService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comTransferService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di compressione geografica' or text() = 'comGeographicCompressionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comGeographicCompressionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di conversione di formato geografico' or text() = 'comGeographicFormatConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comGeographicFormatConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Servizio di messaggeria' or text() = 'comMessagingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comMessagingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'Gestione di file remoti e di file eseguibili' or text() = 'comRemoteFileAndExecutableManagement'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comRemoteFileAndExecutableManagement">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:value-of select="." />
            </xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
