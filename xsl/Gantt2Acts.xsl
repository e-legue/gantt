<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <data>
      <xsl:apply-templates select="//crew"/>
    </data>
  </xsl:template>

  <xsl:template match="crew">
    <xsl:element name="employee">
      <xsl:attribute name="ref"><xsl:value-of select="pk"/></xsl:attribute>
      <xsl:variable name="varPK" select="pk"/>

      <xsl:element name="preassigned-task-list">
        <xsl:apply-templates select="//activity[fk_cm=$varPK]"/>
      </xsl:element>

    </xsl:element>
  </xsl:template>

  <xsl:template match="activity">

    <xsl:choose>
      <xsl:when test="type='LAY' or type='LEGA' or type='LEGD' or type='STA'">
        <!-- nothing to do with this activity -->
      </xsl:when>
      <xsl:when test="type='LVE' or type='DO'">
        <xsl:element name="task">
          <xsl:element name="activity-type">
            <xsl:attribute name="ref"><xsl:value-of select="activityType"/></xsl:attribute>
          </xsl:element> 
          <xsl:element name="start-date-lbt"><xsl:value-of select="substring(lbtStart,1,10)"/></xsl:element>
          <xsl:element name="end-date-lbt"><xsl:value-of select="substring(lbtEnd,1,10)"/></xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="type='TRN'">
        <xsl:element name="task">
          <xsl:element name="activity-type">
            <xsl:attribute name="ref"><xsl:value-of select="type"/></xsl:attribute>
          </xsl:element> 
          <xsl:element name="start-utc"><xsl:value-of select="utcStart"/></xsl:element>
          <xsl:element name="end-utc"><xsl:value-of select="utcEnd"/></xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="type='RSV'">
        <xsl:element name="task">
          <xsl:element name="activity-type">
            <xsl:attribute name="ref"><xsl:value-of select="activityType"/></xsl:attribute>
          </xsl:element> 
          <xsl:element name="start-utc"><xsl:value-of select="utcStart"/></xsl:element>
          <xsl:element name="end-utc"><xsl:value-of select="utcEnd"/></xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="type='TRP'">
        <xsl:element name="task">
          <xsl:element name="seat-role">
            <xsl:attribute name="ref">CP</xsl:attribute>
          </xsl:element> 
          <xsl:element name="trip">
            <xsl:attribute name="ref">trp_<xsl:value-of select="pk"/></xsl:attribute>
          </xsl:element> 
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment><xsl:value-of select="type"/> is not yet supported.</xsl:comment>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
