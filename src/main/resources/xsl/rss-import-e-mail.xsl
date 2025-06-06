<?xml version="1.0" encoding="UTF-8"?>

<!-- ============================================== -->
<!-- $Revision: 34514 $ $Date: 2016-02-04 19:27:24 +0100 (Do, 04 Feb 2016) $ -->
<!-- ============================================== --> 

<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:str="http://exslt.org/strings"
  xmlns:ubo="xalan://org.mycore.ubo.DozBibEntryServlet"
  xmlns:mods="http://www.loc.gov/mods/v3"
  exclude-result-prefixes="xsl xalan str ubo mods"
>

<xsl:output method="xml" />

<xsl:include href="mods-display.xsl" />
<xsl:include href="mycoreobject-html.xsl" />
<xsl:include href="coreFunctions.xsl" />

<xsl:param name="loaded_navigation_xml" />
<xsl:param name="lastPage" />
<xsl:param name="href" />
<xsl:param name="HttpSession" />
<xsl:param name="RequestURL" />
<xsl:param name="WebApplicationBaseURL" />
<xsl:param name="ServletsBaseURL" />
<xsl:param name="MCR.Mail.Address" />
<xsl:param name="UBO.Mail.From" />
<xsl:param name="UBO.Scopus.Importer.Status" />


<xsl:variable name="br"><xsl:text>
</xsl:text></xsl:variable>

<xsl:template match="/*[contains(concat('imported ', $UBO.Scopus.Importer.Status), local-name())]">
  <email>
    <from><xsl:value-of select="$UBO.Mail.From" /></from>
    <xsl:if test="string-length($MCR.Mail.Address)&gt;0">
      <xsl:for-each select="str:tokenize($MCR.Mail.Address,',')" >
        <to> <xsl:value-of select="." /> </to>
      </xsl:for-each>
    </xsl:if>
    <subject>Hochschulbibliographie: <xsl:value-of select="@source" /> RSS Feed Import</subject>
    <body>
    <xsl:text>
Liebe Kollegin, lieber Kollege,

die folgenden </xsl:text>
  <xsl:value-of select="count(mycoreobject)" /><xsl:text> Publikationen wurden aus </xsl:text>
  <xsl:value-of select="@source" /><xsl:text> importiert:

</xsl:text>
      <xsl:for-each select="mycoreobject">
        <xsl:text>&#xa;</xsl:text>
        <xsl:value-of select="$WebApplicationBaseURL" />
        <xsl:text>servlets/DozBibEntryServlet?id=</xsl:text>
        <xsl:value-of select="@ID" />
        <xsl:text>&#xa;</xsl:text>
        <xsl:variable name="bibentry.html">
          <xsl:apply-templates select="." mode="html-export" /> 
        </xsl:variable>
        <xsl:apply-templates select="xalan:nodeset($bibentry.html)" />
        <xsl:text>&#xa;</xsl:text>
      </xsl:for-each> 
<xsl:text>

Mit freundlichen Grüßen

Ihre Hochschulbibliographie
</xsl:text>
    </body>
  </email>
</xsl:template>

<xsl:template match="div">
  <xsl:apply-templates select="*|text()" />
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<xsl:template match="a">
  <xsl:value-of select="text()" />
  <xsl:text>: </xsl:text>
  <xsl:value-of select="@href" />
</xsl:template>

<xsl:template match="text()">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="@*" />

</xsl:stylesheet>
