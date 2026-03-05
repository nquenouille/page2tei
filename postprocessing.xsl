<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:local="local"
   xmlns="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="#all"
   version="3.0">   
   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p><xd:b>Created on:</xd:b> April 30, 2025</xd:p>
         <xd:p><xd:b>Author:</xd:b> Nadine Quenouille (quenouille@bach-leipzig.de)</xd:p>
         <xd:p></xd:p>
      </xd:desc>
   </xd:doc>

   <xd:doc>
      <xd:desc>
         <xd:p>Some postprocessing steps</xd:p>
         <xd:p>Some attributes that were needed for getting elements are being removed. Also, some parts of the text will receive a structure element and attribute for structuring text.</xd:p>
      </xd:desc>
   </xd:doc>

    <xsl:template match="tei:ab[contains(@type, 'margin_') and not(contains(@type, 'margin_top')) and not(contains(@type, 'margin_bottom'))]" mode="postprocessing">
      <p>
         <!-- Copy content without type-attribute -->
         <xsl:for-each select="@*">
            <!-- Copy all attributes, except 'type' -->
            <xsl:if test="local-name() != 'type'">
               <xsl:copy />
            </xsl:if>
         </xsl:for-each>
         <xsl:copy-of select="node()"/>   
      </p>
   </xsl:template>

   <xsl:template match="tei:ab[@rend]" mode="postprocessing">
      <div>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="postprocessing"/>
      </div>
   </xsl:template>

   <xsl:template match="tei:p | tei:ab[contains(@type, 'margin_top')] | tei:ab[contains(@type, 'margin_bottom')]" mode="postprocessing">
      <xsl:variable name="hasAbWithRend" as="xs:boolean"
               select="exists(//tei:ab[@rend])"/>
      <xsl:choose>
         <xsl:when test="$hasAbWithRend and not(parent::tei:ab[@rend])">
            <div n="2">
               <xsl:text>
            </xsl:text>
               <p>
               <xsl:for-each select="@*">
                     <xsl:if test="local-name() != 'type'">
                        <xsl:copy />
                     </xsl:if>
                  </xsl:for-each>      
                  <xsl:copy-of select="node()"/>
               </p>
            <xsl:text>
         </xsl:text>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <p>
               <xsl:for-each select="@*">
                     <xsl:if test="local-name() != 'type'">
                        <xsl:copy />
                     </xsl:if>
                  </xsl:for-each>      
                  <xsl:copy-of select="node()"/>
               </p>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:pb" mode="postprocessing">
      <pb>
         <xsl:for-each select="@*">
            <xsl:if test="local-name() != 'type'">
               <xsl:copy />
            </xsl:if>
         </xsl:for-each>
         <xsl:copy-of select="node()"/>
      </pb>
   </xsl:template>

   <xsl:template match="tei:milestone" mode="postprocessing">
      <milestone>
         <xsl:for-each select="@*">
            <xsl:if test="local-name() != 'type' or (local-name() = 'type' and . = 'unedited')">
               <xsl:copy />
            </xsl:if>
         </xsl:for-each>
         <xsl:copy-of select="node()"/>
      </milestone>
   </xsl:template>
   <xsl:template match="tei:*" mode="postprocessing">
      <xsl:copy-of select="."/>
   </xsl:template>

</xsl:stylesheet>