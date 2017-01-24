<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <xsl:include href="mapping.xsl"/>

  <xsl:template match="/bundles">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>Installed bundles</title>

        <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/dojo/1.10.3/dijit/themes/claro/claro.css"/>
        <style>
          .key {font-style:italic}
          .dojoxGrid table {margin: 0;}
        </style>
        <script type="text/javascript">dojoConfig = {parseOnLoad: true}</script>
        <script>
        var baseUrl = "http://dgrid.io/js/";
        var dojoConfig = {
          parseOnLoad: true,
          has: {
            "dojo-firebug": true,
            "dojo-debug-messages": true
            },
          packages: [ 
                            { name: 'dgrid', location: baseUrl + 'dgrid' },
                            { name: 'xstyle', location: baseUrl + 'xstyle' },
                            { name: 'put-selector', location: baseUrl + 'put-selector' }
             ]
        };
        </script>

        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/dojo/1.10.3/dojo/dojo.js"></script>
        <script>
        require(["dojo/parser", "dijit/layout/TabContainer", "dijit/layout/ContentPane", "dgrid/Grid", "dojo/domReady!"]);
      </script>

      <style>
.dgrid-column-command{
    width:15em;
}
/*
.dgrid {
    height: auto;
}

.dgrid .dgrid-scroller {
    position: relative;
    overflow: visible;
}        
*/       
      </style>
      </head>

      <body class="claro">
        <h2>List of bundles</h2>
        <div data-dojo-type="dijit/layout/TabContainer" tabPosition="left-h" style="width: 1024px; height: 800px;">
          <xsl:apply-templates>
            <xsl:sort select="@name"></xsl:sort>
          </xsl:apply-templates>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="bundle">
    <xsl:element name="div">
      <xsl:attribute name="data-dojo-type">dijit/layout/ContentPane</xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>
      <xsl:attribute name="selected">true</xsl:attribute>
      <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute>Reference</xsl:element><br/>
      
      <xsl:apply-templates select= "document(concat(concat('../', @name),'.xml'))"/>
      
    </xsl:element>
  </xsl:template>

  <xsl:template match="note">
    <xsl:value-of select='.' disable-output-escaping="yes"/>
  </xsl:template>
</xsl:stylesheet>
