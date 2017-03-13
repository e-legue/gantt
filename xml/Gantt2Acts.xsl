<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <data xmlns="http://www.ad-opt.com/2009/Altitude/data">

      <xsl:for-each select="//crew">
        <xsl:element name="employee">
          <xsl:attribute name="ref">emp_<xsl:value-of select="position"/></xsl:attribute>

          <xsl:variable name="varCurrentPosition" select="position"/>
          <xsl:element name="pos"><xsl:value-of select="$varCurrentPosition"/></xsl:element>

          <xsl:element name="preassigned-task-list">
            <xsl:for-each select="//activity[cmPosition=$varCurrentPosition]">
              <xsl:element name="task">
                <xsl:element name="activity-type">
                  <xsl:attribute name="ref"><xsl:value-of select="name"/></xsl:attribute>
                </xsl:element> 
                <xsl:element name="start-utc"><xsl:value-of select="x"/></xsl:element>
                <xsl:element name="end-utc"><xsl:value-of select="x"/></xsl:element>

              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </data>
  </xsl:template>


</xsl:stylesheet>
