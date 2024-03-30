<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:local="local"
   xmlns="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="#all"
   version="3.0">
   

   <!-- Create ulx, uly, lrx and lry by getting the coordinates's points, sort them and take the max and min values -->
    <xsl:template name="coordinates">
      <xsl:variable name="x-string">
         <xsl:for-each select="tokenize(p:Coords/@points, ' ')">
            <xsl:if test="position() > 1">,</xsl:if>
            <xsl:value-of select="substring-before(current(), ',')" />
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="y-string">
         <xsl:for-each select="tokenize(p:Coords/@points, ' ')">
            <xsl:if test="position() > 1">,</xsl:if>
            <xsl:value-of select="substring-after(current(), ',')" />
         </xsl:for-each>
      </xsl:variable>

       <xsl:variable name="sortx">
      <xsl:perform-sort select="tokenize($x-string, ',')">
         <xsl:sort select="number(.)" order="descending"/>         
      </xsl:perform-sort>
      </xsl:variable>

      <xsl:variable name="sorty">
      <xsl:perform-sort select="tokenize($y-string, ',')">
         <xsl:sort select="number(.)" order="descending"/>         
      </xsl:perform-sort>
      </xsl:variable>

      <xsl:variable name="maxx">
            <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
        </xsl:if>        
      </xsl:for-each>        
      </xsl:variable>

      <xsl:variable name="minx">
            <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
        </xsl:if>        
      </xsl:for-each>        
      </xsl:variable>
      
      <xsl:variable name="maxy">
         <xsl:for-each select="tokenize($sorty, ' ')">
         <xsl:if test="position() = 1">
            <xsl:value-of select="." />
         </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="miny">
      <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
        </xsl:if>        
      </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="ulx">
            <xsl:value-of select="$minx" />
      </xsl:variable>

      <xsl:variable name="uly">
            <xsl:value-of select="$miny" />
      </xsl:variable>

      <xsl:variable name="lrx">
            <xsl:value-of select="$maxx" />
      </xsl:variable>
      
      <xsl:variable name="lry">
            <xsl:value-of select="$maxy" />
      </xsl:variable>
    </xsl:template>
</xsl:stylesheet>