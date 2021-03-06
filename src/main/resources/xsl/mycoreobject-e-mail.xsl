<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- ============================================== -->
<!-- $Revision$ $Date$ -->
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

<xsl:template match="/mycoreobject">
  <email>
    <from><xsl:value-of select="$UBO.Mail.From" /></from>
    <xsl:if test="string-length($MCR.Mail.Address) &gt; 0">
      <xsl:for-each select="str:tokenize($MCR.Mail.Address,',')" >
        <to> <xsl:value-of select="." /> </to>
      </xsl:for-each>
    </xsl:if>
    <xsl:for-each select="metadata/def.modsContainer/modsContainer/mods:mods">
      <xsl:call-template name="build.to" />
      <xsl:call-template name="build.subject" />
      <xsl:call-template name="build.body" />
    </xsl:for-each>
  </email>
</xsl:template>

<xsl:template name="build.to">
  <xsl:for-each select="mods:classification[contains(@authorityURI,'fachreferate')]">
    <xsl:variable name="subject" select="substring-after(@valueURI,'#')" />
    <xsl:variable name="uri" select="concat('classification:metadata:0:parents:fachreferate:',$subject)" />
    <xsl:for-each select="document($uri)//category[@ID=$subject]/label[@xml:lang='x-e-mail']">
      <xsl:for-each select="xalan:tokenize(@text)">
        <to><xsl:value-of select="." /></to>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template name="build.subject">
  <subject>
    <xsl:text>Hochschulbibliographie: </xsl:text>
    <xsl:value-of select="number(substring-after(/mycoreobject/@ID,'_mods_'))" />
    <xsl:text> / </xsl:text>
    <xsl:for-each select="mods:name[mods:role/mods:roleTerm='aut'][1]">
      <xsl:value-of select="mods:namePart[@type='family']" />
      <xsl:if test="position() != last()">; </xsl:if>
    </xsl:for-each>
    <xsl:text> / </xsl:text>
    <xsl:apply-templates select="mods:titleInfo[1]" />
  </subject>
</xsl:template>

<xsl:template name="build.body">
  <body>
    <xsl:text>
Liebe Kollegin, lieber Kollege,

der folgende Eintrag ist per Selbsteingabe an die Hochschulbibliographie gemeldet worden:

</xsl:text>

  <xsl:for-each select="mods:classification[contains(@authorityURI,'fachreferate')]">
    <xsl:text>Fach: </xsl:text>
    <xsl:call-template name="output.category">
      <xsl:with-param name="classID" select="'fachreferate'" />
      <xsl:with-param name="categID" select="substring-after(@valueURI,'#')" />
    </xsl:call-template>
    <xsl:text>&#xa;</xsl:text>
  </xsl:for-each>
  <xsl:for-each select="mods:classification[contains(@authorityURI,'ORIGIN')]">
    <xsl:text>Fakult�t: </xsl:text>
    <xsl:call-template name="output.category">
      <xsl:with-param name="classID" select="'ORIGIN'" />
      <xsl:with-param name="categID" select="substring-after(@valueURI,'#')" />
    </xsl:call-template>
    <xsl:text>&#xa;</xsl:text>
  </xsl:for-each>
  <xsl:text>&#xa;</xsl:text>
    
  <xsl:variable name="bibentry.html">
    <xsl:apply-templates select="." mode="html-export" /> 
  </xsl:variable>
  <xsl:apply-templates select="xalan:nodeset($bibentry.html)" />
    
<xsl:text>
Bitte folgen Sie diesem Link:

</xsl:text>
<xsl:value-of select="$WebApplicationBaseURL" />
<xsl:text>servlets/DozBibEntryServlet?id=</xsl:text>
<xsl:value-of select="/mycoreobject/@ID" />
<xsl:text>

Mit freundlichen Gr��en

Ihre Hochschulbibliographie
</xsl:text>
  </body>
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
