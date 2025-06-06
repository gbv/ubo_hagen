<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
  exclude-result-prefixes="xsl xalan i18n encoder mcrver">

  <xsl:output method="xml" encoding="UTF-8" />

  <xsl:param name="CurrentLang" />
  <xsl:param name="UBO.Login.Path" />
  <xsl:param name="UBO.TestInstance" />

  <xsl:param name="UBO.Frontend.jquery.version" />
  <xsl:param name="UBO.Frontend.jquery-ui.version" />
  <xsl:param name="UBO.Frontend.bootstrap.version" />
  <xsl:param name="UBO.Frontend.bootstrap-select.version" />
  <xsl:param name="UBO.Frontend.font-awesome.version" />


  <xsl:param name="User-Agent"/>

  <!-- ==================== IMPORTS ==================== -->
  <!-- additional stylesheets -->
  <xsl:include href="coreFunctions.xsl" />
  <xsl:include href="html-layout-backend.xsl" />
  <xsl:include href="user-orcid.xsl"/>

  <!-- ==================== HTML ==================== -->

  <xsl:template match="/html">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html>

    </xsl:text>
    <html lang="{$CurrentLang}">
      <xsl:apply-templates select="head" />
      <!-- include Internet Explorer warning -->
      <xsl:call-template name="msie-note" />
      <xsl:call-template name="layout" />
    </html>
  </xsl:template>

  <xsl:template match="head">
    <head>
      <meta charset="utf-8" />

      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <meta http-equiv="x-ua-compatible" content="ie=edge" />

      <link href="{$WebApplicationBaseURL}rsc/sass/scss/bootstrap-ubo.min.css" rel="stylesheet" />
      <script type="text/javascript" src="{$WebApplicationBaseURL}webjars/jquery/{$UBO.Frontend.jquery.version}/jquery.min.js"></script>
      <script type="text/javascript" src="{$WebApplicationBaseURL}webjars/bootstrap/{$UBO.Frontend.bootstrap.version}/js/bootstrap.bundle.min.js"></script>
      <script type="text/javascript" src="{$WebApplicationBaseURL}webjars/bootstrap-select/{$UBO.Frontend.bootstrap-select.version}/js/bootstrap-select.min.js"></script>
      <link href="{$WebApplicationBaseURL}webjars/bootstrap-select/{$UBO.Frontend.bootstrap-select.version}/css/bootstrap-select.min.css" rel="stylesheet" />
      <script type="text/javascript" src="{$WebApplicationBaseURL}webjars/jquery-ui/{$UBO.Frontend.jquery-ui.version}/jquery-ui.js"></script>
      <link rel="stylesheet" href="{$WebApplicationBaseURL}webjars/jquery-ui/{$UBO.Frontend.jquery-ui.version}/jquery-ui.css" type="text/css"/>
      <link rel="stylesheet" href="{$WebApplicationBaseURL}webjars/font-awesome/{$UBO.Frontend.font-awesome.version}/css/all.css" type="text/css"/>
      <link rel="stylesheet" href="https://webfonts.gbv.de/css?family=Roboto:ital,wght@0,400;0,500;0,700;1,500" type="text/css" />
      <link rel="shortcut icon" href="{$WebApplicationBaseURL}images/favicon.ico" />

      <script type="text/javascript">var webApplicationBaseURL = '<xsl:value-of select="$WebApplicationBaseURL" />';</script>
      <script type="text/javascript">var currentLang = '<xsl:value-of select="$CurrentLang" />';</script>
      <script type="text/javascript" src="{$WebApplicationBaseURL}js/session-polling.js" />
      <script type="text/javascript" src="{$WebApplicationBaseURL}js/person-popover.js" />
      <xsl:copy-of select="node()" />
    </head>
  </xsl:template>

  <!-- html body -->

  <xsl:template name="layout">
    <body class="d-flex flex-column">
      <!-- <xsl:call-template name="layout.headerline" /> -->
      <xsl:call-template name="layout.header" />
      <xsl:call-template name="layout.navigation" />
      <xsl:call-template name="layout.breadcrumbPath"/>
      <xsl:call-template name="layout.headline"/>
      <!-- <xsl:call-template name="layout.topcontainer" /> -->
      <xsl:call-template name="layout.body" />
      <xsl:call-template name="layout.footer" />
      <xsl:if test="contains($UBO.TestInstance, 'true')">
        <div id="watermark_testenvironment">Testumgebung</div>
      </xsl:if>
    </body>
  </xsl:template>

  <xsl:template name="layout.headline">
    <div id="headlineWrapper">
      <div class="container">
        <div class="row">
          <div class="col">
            <h3 id="seitentitel">
              <xsl:value-of select="head/title" disable-output-escaping="yes" />
            </h3>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="layout.topcontainer">
    <div id="topcontainer">
      <div class="container">
        <div class="row">
          <div class="col">
            <xsl:call-template name="layout.pageTitle"/>
          </div>
        </div>
        <div class="row">
          <div class="col-lg-9">
            <xsl:call-template name="layout.breadcrumbPath"/>
          </div>
          <div class="col-lg-3 pl-0">
            <xsl:call-template name="layout.basket.info"/>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- html body -->
  <xsl:template name="layout.body">
    <div class="bodywrapper pt-4">
      <div class="container d-flex flex-column flex-grow-1">
        <div class="row">
          <div class="col-lg">
            <xsl:call-template name="layout.inhalt" />
          </div>
          <xsl:if test="body/aside[@id='sidebar']">
            <div class="col-lg-3 pl-lg-0">
              <xsl:copy-of select="body/aside[@id='sidebar']" />
            </div>
          </xsl:if>
        </div>
        <div class="row">
          <div class="col">
            <hr class="mb-0"/>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="layout.navigation">
    <div id="navigationWrapper">
      <div class="container">
        <nav class="navbar navbar-expand-xl p-0" role="navigation" id="hauptnavigation">
          <button class="navbar-toggler ml-auto" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon">
              <i class="fas fa-lg fa-bars"></i>
            </span>
          </button>

          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav" id="mainnav">
              <xsl:call-template name="layout.mainnav" />
            </ul>
          </div>
        </nav>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="layout.headerline">
    <div id="headerLine" class="d-flex align-items-center bg-white">
      <div class="container" >
        <div class="row">
          <nav class="col">
            <ul class="nav">
              <li class="">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" role="button">
                  <i class="far fa-fw fa-comments"></i>
                  <span class="icon-label">Kontakt</span>
                </a>
                <div class="dropdown-menu" x-placement="bottom-start">
                  <ul>
                    <li>
                      <a href="tel:+492011834031">
                        <i class="far fa-fw fa-phone"></i>
                        +49 201 18 34031
                      </a>
                    </li>
                    <li>
                      <a href="/">
                        <i class="far fa-fw fa-envelope"></i>
                        sekretariat.softec@paluno.uni-due.de
                      </a>
                    </li>
                    <li>
                      <a href="/kontakt/anfahrt-und-postanschrift/">
                        <i class="far fa-fw fa-map-signs"></i>
                        Anfahrt und Postanschrift
                      </a>
                    </li>
                  </ul>
                </div>
              </li>
              <li id="navigationStakeholder">
                <xsl:call-template name="layout.sub.navigation.information"/>
              </li>
            </ul>
          </nav>
          <nav class="col col-auto">
            <a href="#" class="social-toggler" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" role="button" id="socialDropDownButton">
              <i class="far fa-fw fa-share-square" aria-hidden="true"></i>
              <span class="icon-label">Social Media</span>
            </a>
            <div class="dropdown-menu dropdown-menu-right" id="navigationSocialContent" aria-labelledby="socialDropDownButton">
              <ul>
                <li>
                  <a href="https://www.uni-due.de/myude/" class="social social-myude" title="myUDE">
                    <i class="fab fa-fw fa-myude" aria-hidden="true"></i>
                  </a>
                </li>
                <li>
                  <a href="http://www.facebook.com/uni.due" class="social social-facebook" title="Facebook">
                    <i class="fab fa-fw fa-facebook-f" aria-hidden="true"></i>
                  </a>
                </li>
                <li>
                  <a href="http://twitter.com/unidue" class="social social-twitter" title="Twitter">
                    <i class="fab fa-fw fa-twitter" aria-hidden="true"></i>
                  </a>
                </li>
                <li>
                  <a href="https://www.softec.wiwi.uni-due.de/rss/" class="social social-rss" title="RSS">
                    <i class="fab fa-fw fa-rss" aria-hidden="true"></i>
                  </a>
                </li>
              </ul>
            </div>
          </nav>
          <nav class="col col-auto">
            <div class="nav nav-pills">
              <xsl:call-template name="layout.login"/>
            </div>
          </nav>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- custom navigation for additional information -->

  <xsl:template name="layout.sub.navigation.information">
    <xsl:for-each select="$navigation.tree/item[@menu='information']">
      <a href="#" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="far fa-fw fa-user"></i>
        <span class="icon-label"><xsl:call-template name="output.label.for.lang"/></span>
      </a>
    </xsl:for-each>
    <ul class="dropdown-menu">
      <xsl:for-each select="$navigation.tree/item[@menu='information']/item">
        <li>
          <xsl:call-template name="output.item.label"/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="layout.header">
    <header class="">
      <div class="container" id="">
        <div class="row justify-content-end justify-content-md-start">
          <div class="col-12 col-md header-brand order-2 order-md-1">
            <a title="Zur Startseite" class="imageLink" href="{$WebApplicationBaseURL}">
              <img
                id="wordmark"
                class=""
                src="{$WebApplicationBaseURL}images/FeU_Hochschulbibliographie.svg" />
            </a>
          </div>
          <nav class="col col-auto order-1 order-md-2">
            <div class="nav nav-pills">
              <xsl:call-template name="layout.login"/>
            </div>
          </nav>
        </div>
      </div>
    </header>
  </xsl:template>

  <xsl:template name="layout.basket.info">
    <div id="basketWrapper" class="text-right">
      <a href="{$ServletsBaseURL}MCRBasketServlet?action=show&amp;type=objects">
            <span class="fas fa-bookmark mr-1" aria-hidden="true" />
            <span class="mr-1"><xsl:value-of select="i18n:translate('basket')" />:</span>
            <span class="mr-1" id="basket-info-num">
              <xsl:value-of xmlns:basket="xalan://org.mycore.ubo.basket.BasketUtils" select="basket:size()" />
            </span>
            <span><xsl:value-of select="i18n:translate('ubo.publications')" /></span>
      </a>
    </div>
  </xsl:template>

  <!-- page content -->

  <xsl:template name="layout.inhalt">
    <section role="main" id="inhalt">

      <xsl:choose>
        <xsl:when test="$allowed.to.see.this.page = 'true'">
          <xsl:copy-of select="body/*[not(@id='sidebar')][not(@id='breadcrumb')]" />
        </xsl:when>
        <xsl:otherwise>
          <h3>
            <xsl:value-of select="i18n:translate('navigation.notAllowedToSeeThisPage')" />
          </h3>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:template>

  <!-- Brotkrumen-Navigation -->

  <xsl:template name="layout.breadcrumbPath">
    <div id="breadcrumbWrapper">
      <div class="container">
        <div class="row">
          <div class="col-12 col-lg order-2 order-lg-1">
            <nav aria-label="breadcrumb">
              <ol class="breadcrumb">
                <li class="breadcrumb-item">
                  <i class="fas fa-home pr-1"></i>
                  <a href="http://www.ub.fernuni-hagen.de/">
                    <xsl:value-of select="i18n:translate('navigation.UB')" />
                  </a>
                </li>
                <li class="breadcrumb-item">
                  <a href="{$WebApplicationBaseURL}">
                    <xsl:value-of select="i18n:translate('navigation.Home')" />
                  </a>
                </li>
                <xsl:apply-templates mode="breadcrumb"
                                     select="$CurrentItem/ancestor-or-self::item[@label|label][ancestor-or-self::*=$navigation.tree[@role='main']]" />
                <xsl:for-each select="body/ul[@id='breadcrumb']/li">
                  <li class="breadcrumb-item">
                    <xsl:choose>
                      <xsl:when test="@data-href">
                        <a href="{@data-href}">
                          <xsl:copy-of select="node()"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:copy-of select="node()"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </li>
                </xsl:for-each>
              </ol>
            </nav>
          </div>
          <div class="col-12 col-lg col-lg-auto order-1 order-lg-2">
            <xsl:call-template name="layout.basket.info"/>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="item" mode="breadcrumb">
    <li class="breadcrumb-item">
      <xsl:call-template name="output.item.label" />
    </li>
  </xsl:template>

  <!-- current user and login formular-->
  <xsl:template name="layout.login">

    <div class="nav-item mr-2">
      <xsl:choose>
        <xsl:when test="$CurrentUser = $MCR.Users.Guestuser.UserName">
          <span class="user btn p-0" style="cursor: default;">
            [<xsl:value-of select="i18n:translate('component.user2.login.guest')" />]
          </span>
        </xsl:when>
        <xsl:otherwise>
          <a aria-expanded="false" aria-haspopup="true" data-toggle="dropdown"
             role="button" id="mcrFunctionsDropdown" href="#"
             class="user nav-link dropdown-toggle p-0" style="cursor: default;">
            <xsl:choose>
              <xsl:when test="contains($CurrentUser,'@')">
                [<xsl:value-of select="substring-before($CurrentUser,'@')" />]
              </xsl:when>
              <xsl:otherwise>
                [<xsl:value-of select="$CurrentUser" />]
              </xsl:otherwise>
            </xsl:choose>
          </a>
          <div aria-labeledby="mcrFunctionsDropdown" class="dropdown-menu">
            <xsl:call-template name="layout.usernav" />
          </div>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="orcidUser" />

    </div>
    <div class="nav-item mr-2">
      <xsl:choose>
        <xsl:when test="/html/@id='login'" />
        <xsl:when test="$CurrentUser = $MCR.Users.Guestuser.UserName">
          <form action="{$WebApplicationBaseURL}{$UBO.Login.Path}" method="get">
            <input type="hidden" name="url" value="{$RequestURL}" />
            <button title="Anmelden" class="btn btn-link p-0" type="submit" name="{i18n:translate('component.user2.button.login')}" value="{i18n:translate('component.user2.button.login')}">
              <i class="nav-login fas fa-lg fa-sign-in-alt"></i>
            </button>
          </form>
        </xsl:when>
        <xsl:otherwise>
          <form action="{$ServletsBaseURL}logout" method="get">
            <input type="hidden" name="url" value="{$RequestURL}" />
            <button title="Anmelden" class="btn btn-link p-0" style="border:0;" type="submit" name="{i18n:translate('login.logOut')}" value="{i18n:translate('login.logOut')}">
              <i class="nav-login fas fa-lg fa-sign-out-alt"></i>
            </button>
          </form>
        </xsl:otherwise>
      </xsl:choose>
    </div>

  </xsl:template>

  <xsl:template name="layout.pageTitle">
    <div class="card my-3">
      <div class="card-body py-2">
        <h3 id="seitentitel">
          <xsl:copy-of select="head/title/node()" />
        </h3>
      </div>
    </div>
  </xsl:template>

  <!-- Footer -->

  <xsl:template name="layout.footer">
    <footer>
      <div class="hagen-footer-menu">
        <div class="container">
          <div class="row">
            <div class="col-xs-6 col-sm-3">
              <h4>Über uns</h4>
              <ul class="internal_links">
                <xsl:apply-templates select="$navigation.tree/item[@menu='footer']/item[@id='service']" mode="navigation" />
              </ul>
            </div>
            <div class="col-xs-6 col-sm-3">
              <h4>Rechtliches</h4>
              <ul class="internal_links">
                <xsl:apply-templates select="$navigation.tree/item[@menu='footer']/item[@id='privacy']" mode="navigation" />
                <xsl:apply-templates select="$navigation.tree/item[@menu='footer']/item[@id='accessibility']" mode="navigation" />
                <xsl:apply-templates select="$navigation.tree/item[@menu='footer']/item[@id='impressum']" mode="navigation" />
              </ul>
            </div>
            <div class="col-xs-6 col-sm-3">
              <h4>Kontakt</h4>
              <ul class="internal_links">
                <xsl:apply-templates select="$navigation.tree/item[@menu='footer']/item[@id='contact']" mode="navigation" />
              </ul>
            </div>
            <div class="col-xs-6 col-sm-3">
              <h4>Technisches</h4>
              <ul class="internal_links">
                <xsl:apply-templates select="$navigation.tree/item[@menu='footer']/item[@id='hosting']" mode="navigation" />
              </ul>
            </div>
          </div>
        </div>
      </div>
      <div class="hagen-footer-logo">
        <div class="container">
          <div class="row">
            <div class="col">
              <a href="https://www.fernuni-hagen.de/">
                <img
                  id="fuhagenlogo"
                  alt="FU Hagen"
                  class="img-responsive center-block"
                  title="FU Hagen- Logo"
                  src="{$WebApplicationBaseURL}images/FeULogo.svg" />
              </a>
            </div>
          </div>
        </div>
      </div>

      <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
      <div id="powered_by">
        <a href="http://www.mycore.de">
          <img src="{$WebApplicationBaseURL}images/mycore_logo_small_invert.png" title="{$mcr_version}" alt="powered by MyCoRe" />
        </a>
      </div>

    </footer>
  </xsl:template>

</xsl:stylesheet>
