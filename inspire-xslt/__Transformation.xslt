<?xml version="1.0" encoding="UTF-8"?>
<!--
/* Licensed under the EUPL, Version 1.2 (the "Licence");
 You may not use this work except in compliance with the Licence.
 You may obtain a copy of the Licence at:
 
  https://joinup.ec.europa.eu/sites/default/files/custom-page/attachment/eupl_v1.2_it.pdf
 
  Date: 21/05/2020
  AgID - Agenzia per l'Italia Digitale (Agency for Digital Italy)
  ESRI Italy under the contract of National Common Infrastructures
  info@rndt.gov.it

*/ 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation=" http://www.isotc211.org/2005/gmd http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd">
   <xsl:output method="xml" encoding="UTF-8" indent="yes" />
   <!--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		General variables
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-->

   <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
   <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
   <!-- hierarchyLevel -->
   <xsl:variable name="hierarchyLevel">
      <xsl:if test="//gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'service'">
         <xsl:value-of select="'service'" />
      </xsl:if>
   </xsl:variable>
   <!-- useLimitation -->
   <xsl:variable name="useLimitation">
      <xsl:value-of select="//gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation" />
   </xsl:variable>
   <!-- serviceType -->
   <xsl:variable name="serviceType">
   	<xsl:value-of select="//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName/text()"/>
   </xsl:variable>
   <!-- +++++++++++++++++++++++++++++++++ -->
   <!-- +++++++++++++++++++++++++++++++++++++
		Templates
		+++++++++++++++++++++++++++++++++++++-->

   <xsl:template name="HeaderTemplate" match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   </xsl:template>
   <xsl:template name="Namespaces" match="gmd:MD_Metadata">
      
      <xsl:choose>
         <xsl:when test="$hierarchyLevel = 'service'">
            <gmd:MD_Metadata xsi:schemaLocation="http://www.isotc211.org/2005/srv http://inspire.ec.europa.eu/draft-schemas/inspire-md-schemas/apiso-inspire/apiso-inspire.xsd">
               <xsl:apply-templates select="@* | node()" />
            </gmd:MD_Metadata>
         </xsl:when>
         <xsl:otherwise>
            <gmd:MD_Metadata xsi:schemaLocation="http://www.isotc211.org/2005/gmd http://schemas.opengis.net/iso/19139/20070417/gmd/gmd.xsd http://www.isotc211.org/2005/gmx http://schemas.opengis.net/iso/19139/20070417/gmx/gmx.xsd">
               <xsl:apply-templates select="@* | node()" />
            </gmd:MD_Metadata>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- Character set -->
   <xsl:template match="//gmd:characterSet">
      <xsl:comment>
         <xsl:value-of select="'If the metadata characterSet element is UTF8 it can be avoided'" />
      </xsl:comment>
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   </xsl:template>
   
   <!-- Hierarchy level  -->
   <xsl:template match="//gmd:hierarchyLevel">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
      <!-- Hierarchy level name -->
      <xsl:if test="gmd:MD_ScopeCode/@codeListValue='service'">
         <gmd:hierarchyLevelName>
            <gco:CharacterString>Service</gco:CharacterString>
         </gmd:hierarchyLevelName>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//gmd:hierarchyLevelName"/>
   
   <!-- INSPIRE themes -->
   <xsl:template match="//gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString[text() = 'GEMET - INSPIRE themes, version 1.0']]">
      <gmd:MD_Keywords>
         <xsl:for-each select="gmd:keyword">
            <gmd:keyword>
               <xsl:if test="gco:CharacterString = 'Atmospheric conditions'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ac">Atmospheric conditions</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Production and industrial facilities'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/pf">Production and industrial facilities</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Land cover'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/lc">Land cover</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Bio-geographical regions'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/br">Bio-geographical regions</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Population distribution — demography'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/br">Population distribution — demography</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Sea regions'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/sr">Sea regions</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Species distribution'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/sd">Species distribution</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Transport networks'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/tn">Transport networks</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Buildings'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/bu">Buildings</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Energy resources'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/er">Energy resources</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Meteorological geographical features'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/mf">Meteorological geographical features</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Mineral resources'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/mr">Mineral resources</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Oceanographic geographical features'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/of">Oceanographic geographical features</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Human health and safety'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/hh">Human health and safety</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Elevation'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/el">Elevation</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Utility and governmental services'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/us">Utility and governmental services</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Geology'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ge">Geology</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Coordinate reference systems'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/rs">Coordinate reference systems</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Habitats and biotopes'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/hb">Habitats and biotopes</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Geographical grid systems'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/gg">Geographical grid systems</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Hydrography'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/hy">Hydrography</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Protected sites'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ps">Protected sites</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Agricultural and aquaculture facilities'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/af">Agricultural and aquaculture facilities</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Soil'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/so">Soil</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Environmental monitoring facilities'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ef">Environmental monitoring facilities</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Administrative units'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/au">Administrative units</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Addresses'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/ad">Addresses</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Statistical units'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/su">Statistical units</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Geographical names'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/gn">Geographical names</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Land use'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/lu">Land use</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Orthoimagery'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/oi">Orthoimagery</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Natural risk zones'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/nz">Natural risk zones</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Cadastral parcels'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/cp">Cadastral parcels</gmx:Anchor>
               </xsl:if>
               <xsl:if test="gco:CharacterString = 'Area management/restriction/regulation zones and reporting units'">
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/theme/am">Area management/restriction/regulation zones and reporting units</gmx:Anchor>
               </xsl:if>
            </gmd:keyword>
         </xsl:for-each>
         <gmd:thesaurusName>
            <gmd:CI_Citation>
               <gmd:title>
                  <gmx:Anchor xlink:href="https://www.eionet.europa.eu/gemet/it/inspire-themes/">GEMET - INSPIRE themes, version 1.0</gmx:Anchor>
               </gmd:title>
               <gmd:date>
                  <gmd:CI_Date>
                     <gmd:date>
                        <gco:Date>2008-06-01</gco:Date>
                     </gmd:date>
                     <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication"/>
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
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication"/>
                     </gmd:dateType>
                  </gmd:CI_Date>
               </gmd:date>
            </gmd:CI_Citation>
         </gmd:thesaurusName>
      </gmd:MD_Keywords>
   </xsl:template>
   <!-- Resource constraints -->
   <xsl:template match="//gmd:resourceConstraints[gmd:MD_Constraints/gmd:useLimitation]">
      <gmd:resourceConstraints>
         <gmd:MD_LegalConstraints>
            <gmd:accessConstraints>
               <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions"/>
            </gmd:accessConstraints>
            <gmd:otherConstraints>
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">No limitations to public access</gmx:Anchor>
            </gmd:otherConstraints>
         </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
      <gmd:resourceConstraints>
         <gmd:MD_LegalConstraints>
            <gmd:useConstraints>
               <gmd:MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions"/>
            </gmd:useConstraints>
            <xsl:choose>
            <xsl:when test="translate(gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString, $uppercase, $lowercase) ='no conditions apply'">
            <gmd:otherConstraints>
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/noConditionsApply">No conditions apply to access and use</gmx:Anchor>
            </gmd:otherConstraints>
            </xsl:when>
            <xsl:when test="translate(gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString, $uppercase, $lowercase) = 'conditions unknown'">
            <gmd:otherConstraints>
               <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/ConditionsApplyingToAccessAndUse/conditionsUnknown">Conditions to access and use unknown</gmx:Anchor>
            </gmd:otherConstraints>
            </xsl:when>
            <xsl:otherwise>
            <gmd:otherConstraints>
               <gco:CharacterString>
                  <xsl:value-of select="gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString" />
               </gco:CharacterString>
            </gmd:otherConstraints>
            </xsl:otherwise>
            </xsl:choose>
         </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
   </xsl:template>
   <xsl:template match="//gmd:resourceConstraints[gmd:MD_LegalConstraints]">
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
   <!--  Service type -->
   <xsl:template match="//gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName">
      <gco:LocalName codeSpace="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType/{$serviceType}">
         <xsl:value-of select="$serviceType" />
      </gco:LocalName>
   </xsl:template>
   <!--  Online resource -->
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
            
            <gmd:linkage>
               <gmd:URL>
                  <xsl:value-of select="gmd:linkage/gmd:URL" />
               </gmd:URL>
            </gmd:linkage>
         </xsl:if>
      </gmd:CI_OnlineResource>
   </xsl:template>
   <xsl:template match="//gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:description[../../../../../../../gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName = 'other']" />
   <!-- Quality scope  -->
   <xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:level">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
  
      <xsl:if test="$hierarchyLevel = 'service'">
               <gmd:levelDescription>
                  <gmd:MD_ScopeDescription>
                     <gmd:other>
                        <gco:CharacterString>Service</gco:CharacterString>
                     </gmd:other>
                  </gmd:MD_ScopeDescription>
               </gmd:levelDescription>
      </xsl:if>
   </xsl:template>
   <xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:scope/gmd:DQ_Scope/gmd:levelDescription" />
   <!-- Category, quality of services, criteria -->
   <xsl:template match="//gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report">
     <xsl:copy>
         <xsl:apply-templates select="@* | node()" />
      </xsl:copy>
   
  <xsl:if test="$hierarchyLevel = 'service' and $serviceType = 'other'">
         <gmd:report>
            <gmd:DQ_DomainConsistency>
               <gmd:result>
                  <gmd:DQ_ConformanceResult>
                     <gmd:specification>
                        <gmd:CI_Citation>
                           <gmd:title>
                              <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/id/ats/metadata/2.0/sds-invocable" xlink:title="INSPIRE Invocable Spatial Data Services metadata">invocable</gmx:Anchor>
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
         <xsl:when test="text() = 'humanInteractionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanInteractionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanCatalogueViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanCatalogueViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanGeographicViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanGeographicSpreadsheetViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicSpreadsheetViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanServiceEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanServiceEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanChainDefinitionEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanChainDefinitionEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanWorkflowEnactmentManager'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanWorkflowEnactmentManager">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanGeographicFeatureEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicFeatureEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanGeographicSymbolEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicSymbolEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanFeatureGeneralizationEditor'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanFeatureGeneralizationEditor">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'humanGeographicDataStructureViewer'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/humanGeographicDataStructureViewer">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoManagementService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoManagementService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoFeatureAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoFeatureAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoMapAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoMapAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoCoverageAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoCoverageAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoSensorDescriptionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoSensorDescriptionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoProductAccessService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoProductAccessService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoFeatureTypeService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoFeatureTypeService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoCatalogueService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoCatalogueService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoGazetteerService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoGazetteerService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoOrderHandlingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoOrderHandlingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'infoStandingOrderService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/infoStandingOrderService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'taskManagementService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/taskManagementService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'chainDefinitionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/chainDefinitionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'workflowEnactmentService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/workflowEnactmentService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'subscriptionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/subscriptionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialCoordinateConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialCoordinateConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialCoordinateTransformationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialCoordinateTransformationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialCoverageVectorConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialCoverageVectorConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialImageCoordinateConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialImageCoordinateConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialRectificationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialRectificationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialOrthorectificationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialOrthorectificationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialSensorGeometryModelAdjustmentService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialSensorGeometryModelAdjustmentService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialImageGeometryModelConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialImageGeometryModelConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialSubsettingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialSubsettingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialSamplingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialSamplingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialTilingChangeService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialTilingChangeService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialDimensionMeasurementService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialDimensionMeasurementService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialFeatureManipulationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialFeatureManipulationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialFeatureMatchingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialFeatureMatchingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialFeatureGeneralizationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialFeatureGeneralizationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialRouteDeterminationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialRouteDeterminationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialPositioningService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialPositioningService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'spatialProximityAnalysisService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/spatialProximityAnalysisService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicGoparameterCalculationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGoparameterCalculationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicClassificationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicClassificationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicFeatureGeneralizationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicFeatureGeneralizationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicSubsettingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicSubsettingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicSpatialCountingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicSpatialCountingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicChangeDetectionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicChangeDetectionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicGeographicInformationExtractionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGeographicInformationExtractionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicImageProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicReducedResolutionGenerationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicReducedResolutionGenerationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicImageManipulationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageManipulationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicImageUnderstandingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageUnderstandingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicImageSynthesisService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicImageSynthesisService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicMultibandImageManipulationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicMultibandImageManipulationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicObjectDetectionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicObjectDetectionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicGeoparsingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGeoparsingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'thematicGeocodingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/thematicGeocodingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'temporalProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'temporalReferenceSystemTransformationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalReferenceSystemTransformationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'temporalSubsettingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalSubsettingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'temporalSamplingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalSamplingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'temporalProximityAnalysisService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/temporalProximityAnalysisService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'metadataProcessingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/metadataProcessingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'metadataStatisticalCalculationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/metadataStatisticalCalculationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'metadataGeographicAnnotationService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/metadataGeographicAnnotationService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comEncodingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comEncodingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comTransferService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comTransferService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comGeographicCompressionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comGeographicCompressionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comGeographicFormatConversionService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comGeographicFormatConversionService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comMessagingService'">
            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory/comMessagingService">
               <xsl:value-of select="text()" />
            </gmx:Anchor>
         </xsl:when>
         <xsl:when test="text() = 'comRemoteFileAndExecutableManagement'">
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