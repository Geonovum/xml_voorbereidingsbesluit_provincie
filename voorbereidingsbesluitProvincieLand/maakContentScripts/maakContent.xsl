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
    exclude-result-prefixes="xs"
version="3.0">
    
    
<xsl:output method="xml" indent="yes"/>
    
<xsl:mode use-accumulators="gebiedengroepIdentificatie gebiedIdentificatie"/>
    
<xsl:accumulator name="gebiedengroepIdentificatie" as="xs:integer" initial-value="0" streamable="yes">
  <xsl:accumulator-rule match="//Artikel/Lid | //Artikel[count(Lid)=0]" select="$value + 1"/>
</xsl:accumulator>

<xsl:accumulator name="gebiedIdentificatie" as="xs:integer" initial-value="0" streamable="yes">
  <xsl:accumulator-rule match="//Artikel/Lid | //Artikel[count(Lid)=0]" select="$value + 1"/>
</xsl:accumulator>

<!--
<xsl:value-of select="accumulator-before('gebiedengroepIdentificatie')"/>
<xsl:value-of select="accumulator-before('gebied')"/>
    -->
    
    

 <xsl:template match="node()[local-name()='XXproperty']/@*[local-name()='XXtype']">
    <xsl:attribute name="{name()}" namespace="{namespace-uri()}"> some new value here </xsl:attribute>
 </xsl:template> 


 <xsl:template match="@*|node()|comment()|processing-instruction()|text()"> 
    <xsl:copy>
        <xsl:apply-templates select="@*|node()|comment()|processing-instruction()|text()"/>
    </xsl:copy>
 </xsl:template> 
    
    
    
    
    
</xsl:stylesheet>