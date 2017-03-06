<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <data xmlns="http://www.ad-opt.com/2009/Altitude/data">

    <!-- <xsl:element name="station"><xsl:value-of select="//configuration/station"/></xsl:element> -->
    <!-- <xsl:element name="station"><xsl:value-of select="//station[name=//configuration/station]/code"/></xsl:element> -->
      

      <xsl:for-each select="//crew">
        <xsl:element name="employee">
          <xsl:attribute name="id">emp_<xsl:value-of select="position"/></xsl:attribute>
          <xsl:element name="name"><xsl:value-of select="name"/></xsl:element>
          <xsl:element name="birth-date-lbt"><xsl:value-of select="birthdate"/></xsl:element>
          <xsl:element name="seniority"><xsl:value-of select="position"/></xsl:element>
          <xsl:element name="base">
            <xsl:attribute name="ref"><xsl:value-of select="//station[name=//configuration/station]/code"/></xsl:attribute>
          </xsl:element>

          <!-- hard coded section -->
          <xsl:element name="primary-seat-qual">
            <xsl:attribute name="ref">CP</xsl:attribute>
          </xsl:element>

        </xsl:element>
      </xsl:for-each>
    </data>
  </xsl:template>


</xsl:stylesheet>
