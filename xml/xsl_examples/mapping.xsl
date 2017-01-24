<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>


  <xsl:template match="mapping">
    <h2>Mappings</h2>
    <div data-dojo-type="dijit/layout/TabContainer" style="width: 100%; height: 100%;">
      <xsl:apply-templates select="section"/>
    </div>
  </xsl:template>


  <xsl:template match="section">
    <xsl:element name="div">
      <xsl:attribute name="data-dojo-type">dijit/layout/ContentPane</xsl:attribute>
      <xsl:attribute name="title"><xsl:value-of select="@name"/></xsl:attribute>
      <xsl:attribute name="data-dojo-props">selected:true</xsl:attribute>

      
      <xsl:element name="div">
        <xsl:attribute name="id">grid<xsl:value-of select="@name"/></xsl:attribute>
      </xsl:element>

      <!-- load Dojo -->
      <script>
        require([
          'dojo/_base/declare', 'dgrid/Grid', 'dgrid/Keyboard', 'dgrid/Selection', 'dojo/domReady!'
          ], function (declare, Grid, Keyboard, Selection) {
          var data = [
              <xsl:apply-templates/>
          ];

          // Create a new constructor by mixing in the components
          var CustomGrid = declare([ Grid, Keyboard, Selection ]);

          // Now, create an instance of our custom grid which
          // have the features we added!
          var grid = new CustomGrid({
              columns: {
                  command: 'Command',
                  description: 'Action',
              },
              selectionMode: 'single', // for Selection; only select a single row at a time
              cellNavigation: false // for Keyboard; allow only row-level keyboard navigation
              }, 'grid<xsl:value-of select="@name"/>');
          grid.renderArray(data);
        });
      </script>
    </xsl:element>
  </xsl:template>

  <xsl:template match="map">
    {command:'<xsl:value-of select="keys"/>', description:'<xsl:value-of select="description"/>'},
  </xsl:template>

</xsl:stylesheet>
