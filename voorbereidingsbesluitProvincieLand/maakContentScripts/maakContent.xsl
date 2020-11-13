<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" 
    xmlns:gml="http://www.opengis.net/gml/3.2" 
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" 
    xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen" 
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" 
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" 
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" 
    xmlns:r="http://www.geostandaarden.nl/imow/regels" 
    xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:stop="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:imop="https://standaarden.overheid.nl/stop/imop/data/"
    
    exclude-result-prefixes="xs"
version="3.0">
    
    
<xsl:output method="xml" indent="yes"/>
    
<xsl:mode use-accumulators="gebiedengroepIdentificatie gebiedIdentificatie"/>
    
    
  <!-- gebiedengroepIdentificatie voor toekomstig gebuik -->
<xsl:accumulator name="gebiedengroepIdentificatie" as="xs:integer" initial-value="0">
  <xsl:accumulator-rule match="/pad" select="$value + 1"/>
</xsl:accumulator>

<xsl:accumulator name="gebiedIdentificatie" as="xs:integer" initial-value="2019000000">
    <xsl:accumulator-rule match="//InformatieObjectVersie" select="$value + 1"/>
</xsl:accumulator>

<xsl:variable name="Gebiedengroep" select="/sl:stand/l:Gebiedengroep[1]"/>
<xsl:variable name="gebied" select="/sl:stand/l:gebied[1]"/>
  
  
<xsl:template match="/">
 <xsl:variable name="gios" select="document('GIOs.xml')"/>
  <ow-dc:owBestand>
   <xsl:attribute name="xsi:schemaLocation">http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3-RC/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd</xsl:attribute>
    <sl:standBestand>
<!-- handmatig -->
    <sl:dataset>ProvincieLand</sl:dataset>
    <sl:inhoud>
      <sl:gebied>Gemeentestad</sl:gebied>
      <sl:leveringsId>abc-20190221-0802</sl:leveringsId>
      <sl:objectTypen>
        <sl:objectType>Gebied</sl:objectType>
        <sl:objectType>Gebiedengroep</sl:objectType>
      </sl:objectTypen>
    </sl:inhoud>
    <sl:stand>
      <ow-dc:owObject>
        <l:Gebiedengroep>
          <l:identificatie>nl.imow-gm0297.gebiedengroep.2019000001</l:identificatie>
          <l:groepselement>
            <l:GebiedRef xlink:href="nl.imow-gm0297.gebied.2019000001"/>
          </l:groepselement>
        </l:Gebiedengroep>
      </ow-dc:owObject>
    </sl:stand>    
<!-- handmatig -->
     <xsl:apply-templates select="//InformatieObjectVersie"></xsl:apply-templates>

    </sl:standBestand>
  </ow-dc:owBestand>
</xsl:template>  
  
<xsl:template match="//InformatieObjectVersie"> <!--maak een gebiedsobject-->
  <sl:stand>
    <ow-dc:owObject>
      <l:Gebied>
        <l:identificatie>nl.imow-pv25.gebied.<xsl:value-of select="accumulator-before('gebiedIdentificatie')"/></l:identificatie>  <!--nl.imow-pv25.gebied.2019000001-->
        <l:noemer>
          <xsl:value-of select="./stop:InformatieObjectMetadata/stop:alternatieveTitels/stop:alternatieveTitel"/>
        </l:noemer>  <!-- Bedrijf categorie 2 -->
        <l:geometrie>
          <l:GeometrieRef xlink:href="{./imop:InformatieObjectVersieMetadata//imop:hash}"/> <!--50EA019E-3C96-4631-A76C-35BCF4D7AB6D-->
        </l:geometrie>
      </l:Gebied>
     </ow-dc:owObject>
  </sl:stand>
</xsl:template> 
  
  
  
  
<!--
    
  <xsl:for-each select="$gios//InformatieObjectVersie"> 
    <xsl:message>OK1</xsl:message>
  </xsl:for-each> 

<xsl:value-of select="accumulator-before('gebiedengroepIdentificatie')"/>
<xsl:value-of select="accumulator-before('gebied')"/>
    <xsl:param name="identificatie" select="'@@XX@@'"/>

  -->
    
    

<!-- <xsl:template match="node()[local-name()='XXproperty']/@*[local-name()='XXtype']">
   <xsl:param name="identificatie" select="'@@XX@@'"/>
    <xsl:attribute name="{name()}" namespace="{namespace-uri()}"> some new value here </xsl:attribute>
 </xsl:template> 


 <xsl:template match="@*|node()|comment()|processing-instruction()|text()"> 
    <xsl:copy>
        <xsl:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
    </xsl:copy>
 </xsl:template> 
    -->
    
    
    
    
</xsl:stylesheet>