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
         <xd:p><xd:b>Created on:</xd:b> August 19, 2025</xd:p>
         <xd:p><xd:b>Author:</xd:b> Nadine Quenouille (quenouille@bach-leipzig.de)</xd:p>
         <xd:p></xd:p>
      </xd:desc>
   </xd:doc>

   <xd:doc>
      <xd:desc>
         <xd:p>Some postprocessing steps</xd:p>
         <xd:p>Some attributes from textual tags are removed hence not needed further.</xd:p>
      </xd:desc>
   </xd:doc>
   
   <xd:doc>
      <xd:desc>Remove attributes from textual tags</xd:desc>
   </xd:doc>
   <!-- remove attribute 'n' from rdg tag -->
   <xsl:template match="tei:rdg" mode="remove-attributes">
      <rdg>
         <xsl:for-each select="@*">
            <xsl:if test="local-name() != 'n'">
               <xsl:copy />
            </xsl:if>
         </xsl:for-each>
         <xsl:copy-of select="node()"/>   
      </rdg>
   </xsl:template>

    <xd:doc>
      <xd:desc>Standard for all other elements</xd:desc>
   </xd:doc>
   <xsl:template match="*" mode="remove-attributes">
   <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="remove-attributes"/>
   </xsl:copy>
   </xsl:template>
   
   <xsl:template match="@*" mode="remove-attributes">
       <xsl:copy>
      <xsl:apply-templates select="." mode="remove-attributes"/>
   </xsl:copy>
   </xsl:template>
</xsl:stylesheet>