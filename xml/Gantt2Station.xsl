<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <data xmlns="http://www.ad-opt.com/2009/Altitude/data">
      <xsl:for-each select="//station">
        <!-- test to exclude station node in node configuration of ConfigurationStore -->
        <xsl:if test="not(parent::configuration)">
          <xsl:element name="station">
            <xsl:attribute name="id"><xsl:value-of select="id"/></xsl:attribute>
            <xsl:element name="code"><xsl:value-of select="code"/></xsl:element>
            <xsl:element name="name"><xsl:value-of select="name"/></xsl:element>
            <xsl:element name="dst-shift"><xsl:value-of select="dstShift"/></xsl:element>
            <xsl:element name="dst-start-lst"><xsl:value-of select="dstStartLst"/></xsl:element>
            <xsl:element name="dst-end-lst"><xsl:value-of select="dstEndLst"/></xsl:element>
            <xsl:element name="utc-offset"><xsl:value-of select="utcOffset"/></xsl:element>
            <region-list>
              <xsl:for-each select="regionList/item">
               <xsl:element name="region"> <xsl:value-of select="."/> </xsl:element>
              </xsl:for-each>
            </region-list>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </data>
  </xsl:template>
</xsl:stylesheet>
