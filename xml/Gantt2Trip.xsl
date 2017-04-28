<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:date="http://exslt.org/dates-and-times" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" 
xmlns:fn="http://www.w3.org/2005/xpath-functions" 
extension-element-prefixes="date xs fn">

  <xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>

  <xsl:template match="/">
    <data xmlns="http://www.ad-opt.com/2009/Altitude/data">
      <xsl:apply-templates select="//activity[type='TRP']"/>
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

    <xsl:variable name="day"  select="floor(($ref + $length ) div 1440)" />
    <xsl:variable name="hour" select="$ref + $length - $day * 1440" />

    <xsl:value-of select="concat(
      format-number($day, '0 '),
      format-number(floor($hour div 60), '00:')
      format-number(floor($hour mod 60), '00'))"/>
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
          <xsl:attribute name="ref"><xsl:value-of select="//configuration/station"/></xsl:attribute>
        </xsl:element>
        <xsl:element name="effective-report-time-utc">
          <xsl:value-of select="substring(utcStart,12)"/>
        </xsl:element>
        <xsl:element name="tafb">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="width" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="credit-total">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="credit" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="block-total">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="block" />
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="duty-total">
          <xsl:call-template name="convertInHoursMinutes">
            <xsl:with-param name="valueInMinutes" select="duty" />
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

        <xsl:variable name="refUTC" select="number(substring(utcStart,12,2)) * 60 + number(substring(utcStart,15,2))" />
        <xsl:comment><xsl:value-of select="$refUTC" /></xsl:comment>

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
                </xsl:element>
              </xsl:when>
              <xsl:when test="type='LEGA'">
                <xsl:element name="leg">
                  <xsl:element name="status">A</xsl:element>
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
                </xsl:element>
              </xsl:when>
              <xsl:when test="type='LEGD'">
                <xsl:element name="leg">
                  <xsl:element name="status">D</xsl:element>
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
                </xsl:element>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>  
        </xsl:element>


      </xsl:element>
    </xsl:element>
    <!--
    <xsl:element name="employee">
      <xsl:attribute name="ref">emp_<xsl:value-of select="pk"/></xsl:attribute>
      <xsl:variable name="varPK" select="pk"/>

      <xsl:element name="preassigned-task-list">
        <xsl:apply-templates select="//activity[fk_cm=$varPK]"/>
      </xsl:element>

    </xsl:element>
-->
  </xsl:template>



  <!--
    <trip id="20140609-Trip3">
        <start-date-utc>2014-06-09</start-date-utc>
        <template>
            <name>Trip 3</name>
            <base ref="AUH" />
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
            <effective-report-time-utc>04:00</effective-report-time-utc>
            <tafb>13h00</tafb>
            <tafb-in-period>13h00</tafb-in-period>
            <block-in-period>5h00</block-in-period>
            <block-total>5h00</block-total>
            <credit-in-period>5h00</credit-in-period>
            <credit-total>5h00</credit-total>
            <duty-in-period>5h00</duty-in-period>
            <duty-total>5h00</duty-total>
            <trip-element-list>
                <leg>
                    <status>A</status>
                    <flight-number>Trip3_1</flight-number>
                    <departure-station ref="AUH" />
                    <rstart-utc>0 04:20</rstart-utc>
                    <arrival-station ref="SEZ" />
                    <rend-utc>0 08:55</rend-utc>
                    <aircraft-variant>330</aircraft-variant>
                    <flight-carrier>EY</flight-carrier>
                    <duration>2h30</duration>
                    <credit>2h30</credit>
                </leg>
                <leg>
                    <status>A</status>
                    <flight-number>Trip3_2</flight-number>
                    <departure-station ref="SEZ" />
                    <rstart-utc>0 09:50</rstart-utc>
                    <arrival-station ref="AUH" />
                    <rend-utc>0 12:25</rend-utc>
                    <aircraft-variant>330</aircraft-variant>
                    <flight-carrier>DHD</flight-carrier>
                    <duration>2h30</duration>
                    <credit>2h30</credit>
                </leg>
            </trip-element-list>
        </template>
    </trip>
-->

</xsl:stylesheet>
