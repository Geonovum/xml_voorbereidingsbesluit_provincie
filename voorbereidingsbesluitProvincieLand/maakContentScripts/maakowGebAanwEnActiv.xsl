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
		input owData.xml
		te maken bestanden
   owActiviteitenNew.xml
   owGebiedsaanwijzingenNew.xml
   -->

	<xsl:output method="xml" indent="yes"/>

	<xsl:mode use-accumulators="gebiedsaanwijzingC activiteitaanduidingC"/>

	<!-- maakt owRegeltekst-, owGebiedsaanwijzingen-, owActiviteiten, owOmgevingsnormOmgevingswaardebestand.xml  -->

	<xsl:accumulator name="gebiedsaanwijzingC" as="xs:integer"
		initial-value="2019000000">
		<xsl:accumulator-rule match="//gebiedsaanwijzing" select="$value + 1"/>
	</xsl:accumulator>

	<xsl:accumulator name="activiteitaanduidingC" as="xs:integer"
		initial-value="2019000000">
		<xsl:accumulator-rule match="//activiteitaanduiding" select="$value + 1"/>
	</xsl:accumulator>


	<xsl:template match="/">
		<xsl:result-document href="owGebiedsaanwijzingenNew.xml" method="xml">
			<ow-dc:owBestand>
				<xsl:attribute name="xsi:schemaLocation"
					>http://www.geostandaarden.nl/imow/bestanden/deelbestand
					https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3-RC/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd</xsl:attribute>
				<sl:standBestand>
					<!-- handmatig -->
					<sl:dataset>ProvincieLand</sl:dataset>
					<sl:inhoud>
						<sl:gebied>ProvincieLand</sl:gebied>
						<sl:leveringsId>abc-20190221-0806</sl:leveringsId>
						<sl:objectTypen>
							<sl:objectType>Gebiedsaanwijzing</sl:objectType>
						</sl:objectTypen>
					</sl:inhoud>
					<!-- /handmatig -->
					<xsl:apply-templates
						select="./owData/gebiedsaanwijzingen/gebiedsaanwijzing"/>
				</sl:standBestand>
			</ow-dc:owBestand>
		</xsl:result-document>

		<xsl:result-document href="owActiviteitenNew.xml" method="xml">
			<ow-dc:owBestand>
				<xsl:attribute name="xsi:schemaLocation"
					>http://www.geostandaarden.nl/imow/bestanden/deelbestand
					https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3-RC/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd</xsl:attribute>
				<sl:standBestand>
					<!-- handmatig -->
					<sl:dataset>ProvincieLand</sl:dataset>
					<sl:inhoud>
						<sl:gebied>ProvincieLand</sl:gebied>
						<sl:leveringsId>abc-20190221-0806</sl:leveringsId>
						<sl:objectTypen>
							<sl:objectType>Activiteit</sl:objectType>
						</sl:objectTypen>
					</sl:inhoud>
					<!-- /handmatig -->
					<xsl:apply-templates
						select="./owData/activiteitaanduidingen/activiteitaanduiding"/>
				</sl:standBestand>
			</ow-dc:owBestand>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="gebiedsaanwijzing">
		<xsl:variable name="bgID" select="../@bgID" as="xs:string"/>
		<sl:stand>
			<ow-dc:owObject>
				<ga:Gebiedsaanwijzing>
					<ga:identificatie>
						<xsl:value-of
							select="concat('nl.imow-', $bgID, '.gebiedsaanwijzing.', accumulator-before('gebiedsaanwijzingC'))"
						/>
					</ga:identificatie>
					<ga:type>http://standaarden.omgevingswet.overheid.nl/typegebiedsaanwijzing/id/concept/Functie</ga:type>
					<ga:naam>
						<xsl:value-of select="@naam"/>
					</ga:naam>
					<ga:groep>
						<xsl:value-of select="@groep"/>
					</ga:groep>
					<ga:locatieaanduiding>
						<l:LocatieRef>
							<xsl:attribute name="xlink:href" select="@GebiedsaanwijzingRef"/>
						</l:LocatieRef>
					</ga:locatieaanduiding>
				</ga:Gebiedsaanwijzing>
			</ow-dc:owObject>
		</sl:stand>
	</xsl:template>

	<xsl:template match="activiteitaanduiding">
		<xsl:variable name="bgID" select="../@bgID" as="xs:string"/>
		<sl:stand>
			<ow-dc:owObject>
				<rol:Activiteit>
					<rol:identificatie>
						<xsl:value-of
							select="concat('nl.imow-', $bgID, '.activiteit.', accumulator-before('activiteitaanduidingC'))"
						/>
					</rol:identificatie>
					<rol:naam>
						<xsl:value-of select="@naam"/>
					</rol:naam>
					<rol:groep>
						<xsl:value-of select="@groep"/>
					</rol:groep>
					<rol:bovenliggendeActiviteit>
						<rol:ActiviteitRef>
							<xsl:attribute name="xlink:href">
								<xsl:value-of
									select="concat('nl.imow-', $bgID, '.activiteit.', accumulator-before('activiteitaanduidingC'))"
								/>
							</xsl:attribute>
						</rol:ActiviteitRef>
					</rol:bovenliggendeActiviteit>
				</rol:Activiteit>
			</ow-dc:owObject>
		</sl:stand>
	</xsl:template>

</xsl:stylesheet>
