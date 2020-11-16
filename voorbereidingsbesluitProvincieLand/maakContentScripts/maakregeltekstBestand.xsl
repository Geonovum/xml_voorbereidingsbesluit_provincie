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
	exclude-result-prefixes="xs" version="3.0">

	<!-- 
		input values.xml
		tokenize("", "\s+")
   -->
	<xsl:output method="xml" indent="yes"/>

	<xsl:mode use-accumulators="opRegel opRegel1"/>

	<!-- maakt owRegeltekst-, owGebiedsaanwijzingen-, owActiviteiten, owOmgevingsnormOmgevingswaardebestand.xml  -->

	<xsl:accumulator name="opRegel" as="xs:integer" initial-value="2019000000">
		<xsl:accumulator-rule match="//opRegel" select="$value + 1"/>
	</xsl:accumulator>

	<xsl:accumulator name="opRegel1" as="xs:integer" initial-value="2019000000">
		<xsl:accumulator-rule match="//opRegel" select="$value + 1"/>
	</xsl:accumulator>


	<xsl:template match="/">
		<ow-dc:owBestand>
			<!--regeltekst-->
			<xsl:attribute name="xsi:schemaLocation"
				>http://www.geostandaarden.nl/imow/bestanden/deelbestand
				https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3-RC/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd</xsl:attribute>
			<sl:standBestand>
				<!-- handmatig -->
				<sl:dataset>ProvincieLand</sl:dataset>
				<sl:inhoud>
					<sl:gebied>ProvincieLand</sl:gebied>
					<sl:leveringsId>abc-20190221-0805</sl:leveringsId>
					<sl:objectTypen>
						<sl:objectType>Regeltekst</sl:objectType>
						<sl:objectType>RegelVoorIedereen</sl:objectType>
						<sl:objectType/>
					</sl:objectTypen>
				</sl:inhoud>
				<!-- /handmatig -->
				<xsl:apply-templates/>
			</sl:standBestand>
		</ow-dc:owBestand>



	</xsl:template>


	<xsl:template match="opRegel">
		<xsl:variable name="bgId" select="../@bgId" as="xs:string"/>
		<sl:stand>
			<ow-dc:owObject>
				<r:Regeltekst>
					<xsl:attribute name="wId" select="@wId"/>
					<xsl:message><xsl:value-of	select="@wId"/></xsl:message>
					<r:identificatie>
						<xsl:value-of
							select="concat('nl.imow-', $bgId, '.regeltekst.', accumulator-before('opRegel'))"
						/>
					</r:identificatie>
				</r:Regeltekst>
			</ow-dc:owObject>
		</sl:stand>
		<sl:stand>
			<ow-dc:owObject>
				<xsl:if test="@type = 'regelVoorIedereen'">
					<r:RegelVoorIedereen>
						<!--alleen regeling voor iedereen geïmplementeerd-->
						<r:identificatie>
							<xsl:value-of
								select="concat('nl.imow-', $bgId, '.juridischeregel.', accumulator-before('opRegel'))"/>
						</r:identificatie>
						<r:idealisatie>http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact</r:idealisatie>
						<r:artikelOfLid>
							<r:RegeltekstRef>
								<xsl:attribute name="xlink:href">
									<xsl:value-of
										select="concat('nl.imow-', $bgId, '.regeltekst.', accumulator-before('opRegel'))"
									/>
								</xsl:attribute>
							</r:RegeltekstRef>
						</r:artikelOfLid>
						<r:locatieaanduiding>
							<l:LocatieRef>
								<xsl:choose>
									<xsl:when test="@locatieaanduidingLocRef ne ''">
										<xsl:attribute name="xlink:href" select="@locatieaanduidingLocRef"/>
									</xsl:when>
									<xsl:when test="(@gebiedsaanwijzing) and @gebiedsaanwijzing ne ''">
										<xsl:attribute name="xlink:href" select="@gebiedsaanwijzing"/>
									</xsl:when>
									<xsl:otherwise>@@XX@@ geen locatieRef voor
										regelVoorIedereen</xsl:otherwise>
								</xsl:choose>
							</l:LocatieRef>
						</r:locatieaanduiding>
						<xsl:if test="@gebiedsaanwijzing">
							<r:gebiedsaanwijzing>
								<ga:GebiedsaanwijzingRef>
									<xsl:attribute name="xlink:href">
										<xsl:value-of select="@GebiedsaanwijzingRef"/>
									</xsl:attribute>
								</ga:GebiedsaanwijzingRef>
							</r:gebiedsaanwijzing>
						</xsl:if>
						<xsl:apply-templates/>
					</r:RegelVoorIedereen>
				</xsl:if>
			</ow-dc:owObject>
		</sl:stand>
	</xsl:template>

	<xsl:template match="activiteitaanduiding">
		<xsl:variable name="bgId" select="../../@bgId" as="xs:string"/>
		<r:activiteitaanduiding>
			<rol:ActiviteitRef>
				<xsl:attribute name="xlink:href">
					<xsl:value-of select="@ActiviteitRef"/>
				</xsl:attribute>
			</rol:ActiviteitRef>
			<r:ActiviteitLocatieaanduiding>
				<r:identificatie><xsl:value-of select="concat('nl.imow-', $bgId, '.activiteitlocatieaanduiding.', accumulator-before('opRegel'))"/>
				</r:identificatie>
				<r:activiteitregelkwalificatie>
					<xsl:value-of select="@activiteitregelkwalificatie"/>
				</r:activiteitregelkwalificatie>
				<r:locatieaanduiding>
				<xsl:choose>
					<xsl:when test="@LocatieRef and @LocatieRef ne ''">
						<l:LocatieRef>
							<xsl:attribute name="xlink:href">
								<xsl:value-of select="@LocatieRef"/>
							</xsl:attribute>
						</l:LocatieRef>						
					</xsl:when>
					<xsl:when  test="../locatieaanduidingLocRef and ../locatieaanduidingLocRef ne ''">
						<l:LocatieRef>
							<xsl:attribute name="xlink:href">
								<xsl:value-of select="../locatieaanduidingLocRef"/>
							</xsl:attribute>
						</l:LocatieRef>						
					</xsl:when>
					<xsl:otherwise>geen locatie gevonden @@XX@@</xsl:otherwise>
				</xsl:choose>
				</r:locatieaanduiding>
			</r:ActiviteitLocatieaanduiding>
		</r:activiteitaanduiding>
	</xsl:template>






	<!--
     <xsl:variable name="gios" select="document('GIOs.xml')"/>

    
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
