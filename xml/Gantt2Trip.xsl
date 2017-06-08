<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/xpath-functions" 
extension-element-prefixes="xs fn">

  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <data xmlns="http://www.ad-opt.com/2009/Altitude/data">
      <xsl:apply-templates select="//activity[type='TRP' and fk_cm=0]"/>
    </data>
  </xsl:template>


  <xsl:template name="convertInHoursMinutes">
    <xsl:param name="valueInMinutes" />
    <xsl:value-of select="concat(
      format-number(floor($valueInMinutes div 60), '0h'),
      format-number(floor($valueInMinutes mod 60), '00'))"/>
  </xsl:template>


  <xsl:template name="relativeUTC">
    <xsl:param name="ref" />
    <xsl:param name="length" />

    <xsl:variable name="relative_day"  select="floor(($length - $ref ) div 1440)" />
    <xsl:variable name="hour" select="$length - $ref - $relative_day * 1440" />

    <xsl:value-of select="concat(
      format-number($relative_day, '0 '),
      format-number(floor($hour div 60), '00:'),
      format-number(floor($hour mod 60), '00'))"/>
  </xsl:template>


  <xsl:template name="leg">
    <xsl:param name="status" />
    <xsl:param name="ref" />

    <xsl:element name="status"><xsl:value-of select="$status" /></xsl:element>
    <xsl:element name="flight-number"><xsl:value-of select="name"></xsl:value-of></xsl:element>
    <xsl:element name="departure-station">
      <xsl:attribute name="ref"><xsl:value-of select="preceding-sibling::activity[1]/station"/></xsl:attribute>
    </xsl:element>
    <xsl:element name="arrival-station">
      <xsl:attribute name="ref"><xsl:value-of select="following-sibling::activity[1]/station"/></xsl:attribute>
    </xsl:element>
    <xsl:element name="duration">
      <xsl:call-template name="convertInHoursMinutes">
        <xsl:with-param name="valueInMinutes" select="width" />
      </xsl:call-template>
    </xsl:element>
    <xsl:element name="credit">
      <xsl:call-template name="convertInHoursMinutes">
        <xsl:with-param name="valueInMinutes" select="width" />
      </xsl:call-template>
    </xsl:element>
    <xsl:element name="rstart-utc">
      <xsl:call-template name="relativeUTC">
        <xsl:with-param name="ref"    select="$ref" />
        <xsl:with-param name="length" select="x" />
      </xsl:call-template>
    </xsl:element>
    <xsl:element name="rend-utc">
      <xsl:call-template name="relativeUTC">
        <xsl:with-param name="ref"    select="$ref" />
        <xsl:with-param name="length" select="x + width" />
      </xsl:call-template>
    </xsl:element>
    <!-- ================== -->
    <!-- hard coded section -->
    <!-- ================== -->
    <xsl:comment>Hard coded section</xsl:comment>
    <aircraft-variant>330</aircraft-variant>
    <flight-carrier>EY</flight-carrier>
    <xsl:comment>End of hard coded section</xsl:comment>
    <!-- ========================= -->
    <!-- End of hard coded section -->
    <!-- ========================= -->
  </xsl:template>
  
  <xsl:template match="activity">
    <xsl:element name="trip">
      <xsl:attribute name="id">trp_<xsl:value-of select="pk"/></xsl:attribute>
      <xsl:element name="start-date-utc">
        <xsl:value-of select="substring(utcStart,1,10)"/>
      </xsl:element>

      <xsl:element name="template">
        <xsl:element name="name">
          <xsl:value-of select="name"/>
        </xsl:element>
        <xsl:element name="base">
          <xsl:attribute name="ref"><xsl:value-of select="//configuration/CalendarStation"/></xsl:attribute>
        </xsl:element>
        <xsl:element name="effective-report-time-utc">
          <xsl:value-of select="substring(utcStart,12)"/>
        </xsl:element>
        <xsl:element name="tafb">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="width" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="tafb-in-period">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="tafbInPeriod" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="credit-total">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="credit" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="credit-in-period">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="creditInPeriod" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="block-total">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="block" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="block-in-period">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="blockInPeriod" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="duty-total">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="duty" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="duty-in-period">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="dutyInPeriod" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="pre-rest">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="resta" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="post-rest">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="restb" />
          </xsl:call-template>
        </xsl:element>

        <!-- refBeginDayUTC contains x position of the begin day of the trip. This is used to compute relative start/end of legs or lays. -->
        <xsl:variable name="refBeginDayUTC" select="x - number(substring(utcStart,12,2)) * 60 + number(substring(utcStart,15,2))" />

        <xsl:element name="trip-element-list">
          <xsl:for-each select="//activity[fk_parent=current()/pk]">
            <xsl:sort select="x" data-type="number" />
              
            <xsl:choose>
              <xsl:when test="type='STA'">
              </xsl:when>
              <xsl:when test="type='LAY'">
                <xsl:element name="lay">
                  <xsl:element name="station">
                    <xsl:attribute name="ref"><xsl:value-of select="preceding-sibling::activity[1]/station"/></xsl:attribute>
                  </xsl:element>
                  <xsl:element name="duration">
                    <xsl:call-template name="convertInHoursMinutes">
                      <xsl:with-param name="valueInMinutes" select="width" />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="rstart-utc">
                    <xsl:call-template name="relativeUTC">
                      <xsl:with-param name="ref"    select="$refBeginDayUTC" />
                      <xsl:with-param name="length" select="x" />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:element>
              </xsl:when>
              <xsl:when test="type='LEGA'">
                <xsl:element name="leg">
                  <xsl:call-template name="leg">
                    <xsl:with-param name="status">A</xsl:with-param>
                    <xsl:with-param name="ref" select="$refBeginDayUTC" />
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
              <xsl:when test="type='LEGD'">
                <xsl:element name="leg">
                  <xsl:call-template name="leg">
                    <xsl:with-param name="status">D</xsl:with-param>
                    <xsl:with-param name="ref" select="$refBeginDayUTC" />
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>  
        </xsl:element>
      
        <!-- ================== -->
        <!-- hard coded section -->
        <!-- ================== -->
        <xsl:comment>Hard coded section</xsl:comment>
        <crew-composition>
          <seat-role-requirement>
            <seat-role ref="CM" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="CP" />
            <count>1</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="CS" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="FA" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="FB" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="FJ" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="FO" />
            <count>1</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="IC" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="LM" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="PM" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="SI" />
            <count>0</count>
          </seat-role-requirement>
          <seat-role-requirement>
            <seat-role ref="SO" />
            <count>0</count>
          </seat-role-requirement>
        </crew-composition>
        <xsl:comment>End of hard coded section</xsl:comment>
        <!-- ========================= -->
        <!-- End of hard coded section -->
        <!-- ========================= -->

      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
