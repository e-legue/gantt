<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="GanttTools.xsl"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <data>
      <xsl:variable name="StartPeriodX" select="//calendar[relative=0]/x"/>

      <xsl:apply-templates select="//activity[type='TRP' and not(x &lt; $StartPeriodX)]"/>
    </data>
  </xsl:template>

</xsl:stylesheet>
