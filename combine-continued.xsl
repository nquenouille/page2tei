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
         <xd:p><xd:b>Created on:</xd:b> 2022-08-03</xd:p>
         <xd:p><xd:b>Author:</xd:b> dario.kampkaspar@tu-darmstadt.de</xd:p>
         <xd:p>combine neighbouring tei:rs[@continued] separated by a tei:lb</xd:p>
      </xd:desc>
   </xd:doc>
   <xsl:strip-space elements="*"/>
   <xsl:key name="lb-by-facs" match="tei:lb" use="@facs"/>
   <!--<xsl:template match="/">
      <xsl:apply-templates mode="continued" />
   </xsl:template>-->
   
   <xd:doc>
      <xd:desc>
         <xd:p>Combine continued elements (e.g. rs)</xd:p>
         <xd:p>This works on an element that contains (more than one) continued element (there may be just one element
            if the continuation happens across region borders).</xd:p>
      </xd:desc>
   </xd:doc>

   <xsl:template match="tei:*[count(tei:*[@continued = 'true']) gt 1]" mode="continued">
     <xsl:copy>
         <xsl:apply-templates select="@*" mode="continued" />
         <xsl:for-each-group select="node()"
               group-starting-with="tei:*[
                  @continued eq 'true'
                  and normalize-space() != ''
                  and not(
                           name() = name(preceding-sibling::tei:*[not(self::tei:lb)][1])
                           and preceding-sibling::tei:*[not(self::tei:lb)][1][@continued = 'true']
                        )
               ]">

            <xsl:choose>
               <xsl:when test="current-group()[1][@continued eq 'true' and tei:abbr]">
                  <!-- we assume there is exactly 2 choice with one lb in between, so no multi-line abbreviations:
                     1=choice, 2=text(), 3=lb, 4=text(), 5=choice -->
                  <choice>
                     <expan>
                        <xsl:sequence select="current-group()[1]/tei:expan/node()" />
                     </expan>
                     <abbr>
                        <xsl:sequence select="current-group()[1]/tei:abbr/node()" />
                        <xsl:sequence select="current-group()[3]" />
                        <xsl:sequence select="current-group()[4]/tei:abbr/node()" />
                     </abbr>
                  </choice>
                  <xsl:apply-templates select="current-group()[position() gt 4]" mode="continued" />
               </xsl:when>
               <xsl:when test="current-group()[1][@continued eq 'true'] and count(current-group()[@continued = 'true']) gt 1">
                  <xsl:variable
                     name="final"
                     select="
                        (
                           current-group()[
                                 position() gt 1
                                 and @continued = 'true'
                                 and node()
                              ][last()],
                           current-group()[position() = 4]
                        )[1]"
                  />
                  <xsl:try>
                     <xsl:variable name="last" select="index-of(current-group(), $final)[last()]"/>
                     
                  <xsl:element name="{local-name()}">
                     <xsl:apply-templates select="@*[name() != 'continued']" mode="continued" />
                     <xsl:apply-templates select="current-group()[position() le $last]" mode="rs-continued" />
                  </xsl:element>
                  <xsl:apply-templates select="current-group()[position() gt $last]" mode="continued" />
                     <xsl:catch>
                        <xsl:message select="current-group()" />
                     </xsl:catch>
                  </xsl:try>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates select="current-group()" mode="continued" />
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each-group>
      </xsl:copy>
   </xsl:template>

   <xd:doc>
      <xd:desc>lb will be returned unaltered</xd:desc>
   </xd:doc>
   <xsl:template match="tei:lb" mode="rs-continued">
      <lb>
         <xsl:sequence select="@*" />
      </lb>
   </xsl:template>

   <xd:doc>
      <xd:description>If there is a hyphen (¬) at the end of the line, replace with <span type='hyphen'>-</span>'</xd:description>
   </xd:doc>
   <xsl:template match="*/text()" mode="continued">
            <xsl:choose>
         <xsl:when test="substring(., string-length(.)) = '¬'">
            <xsl:value-of select="replace(., '.$', '')"/>
            <span type="hyphen">-</span>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="." />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>For continued rs, only return the content</xd:desc>
   </xd:doc>
   <xsl:template match="*" mode="rs-continued">
      <xsl:apply-templates select="node()" mode="continued" />
   </xsl:template>

   <xd:doc>
      <xd:desc>Default</xd:desc>
   </xd:doc>
   <xsl:template match="@* | node()" mode="continued">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" mode="#current" />
      </xsl:copy>
   </xsl:template>


<xd:doc>
      <xd:desc>put rdg tags together and wrap them with app; do not forget to get lb tags into the rdg, if applying</xd:desc>
   </xd:doc>
   <xsl:template match="tei:*" mode="continued">
   <xsl:copy>
      <xsl:apply-templates select="@*" mode="continued"/>
      <xsl:for-each select="node()">
         <xsl:choose>
         <xsl:when test="self::tei:rdg">
            <xsl:variable name="currentN" select="@n"/>
            <xsl:variable name="precedingSameN" select="preceding-sibling::tei:rdg[@n = $currentN]"/>
            <xsl:if test="not($precedingSameN)">
               <app>
               <xsl:for-each select="../*">
                  <xsl:choose>
                     <!-- lb directly in front of the rdg[varSeq > 1] has to be remain -->
                     <xsl:when test="
                     self::tei:lb 
                     and following-sibling::*[1][self::tei:rdg[@n=$currentN and @varSeq and @varSeq != '1']]
                     ">
                     <!-- do not show – lb is already processed in rdg -->
                     </xsl:when>

                     <!-- rdg with current n and varSeq=1 (and no lb in front of it!) -->
                     <xsl:when test="self::tei:rdg[@n=$currentN]">
                        <xsl:apply-templates select="." mode="continued"/>
                     </xsl:when>

                     <!-- otherwise do nothing -->
                  </xsl:choose>
               </xsl:for-each>
               </app>
            </xsl:if>
         </xsl:when>

         <!-- everything else -->
         <xsl:otherwise>
            <xsl:apply-templates select="." mode="continued"/>
         </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:copy>
   </xsl:template>

   <xsl:template match="tei:rdg" mode="continued">
   <xsl:variable name="prev-lb" select="preceding-sibling::*[1][self::tei:lb]"/>  
   <xsl:copy>
      <xsl:apply-templates select="@*" mode="continued"/>    
      <!-- if lb directly in front of rdg, draw it inside -->
      <xsl:if test="$prev-lb">
         <xsl:apply-templates select="$prev-lb" mode="continued"/>
      </xsl:if>
      <xsl:apply-templates select="node()" mode="continued"/>
   </xsl:copy>
   </xsl:template>

   <xd:doc>
      <xd:desc>For double lb remove duplicates</xd:desc>
   </xd:doc>
   <xsl:template match="tei:lb" mode="dedup-lb">   
      <xsl:choose>
         <!-- if lb with attribute facs is the first in the document, copy node, if not ignore; if lb is the first lb after rdg, then put line break before -->          
         <xsl:when test="generate-id() = generate-id(key('lb-by-facs', @facs)[1]) and ancestor::tei:rdg and (generate-id() = generate-id(ancestor::tei:rdg/descendant::tei:lb[1]))">
           <xsl:text>
               </xsl:text>
            <xsl:copy>
               <xsl:apply-templates select="@* | node()" mode="dedup-lb"/>
            </xsl:copy>
         </xsl:when>
         <!-- if lb with attribute facs is the first in the document, copy node, if not ignore -->
         <xsl:when test="generate-id() = generate-id(key('lb-by-facs', @facs)[1])">
            <xsl:copy>
               <xsl:apply-templates select="@* | node()" mode="dedup-lb"/>
            </xsl:copy>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xd:doc>
      <xd:desc>Kill empty lines between lbs</xd:desc>
   </xd:doc>
   <xsl:template match="text()[
      not(normalize-space()) and
      preceding-sibling::*[1][self::tei:lb] and
      (following-sibling::*[1][self::tei:lb] or following-sibling::text()[1][matches(., '^\s+')])
      ]" mode="dedup-lb"/>

   <xd:doc>
      <xd:desc>Standard for all other elements</xd:desc>
   </xd:doc>
   <xsl:template match="*" mode="dedup-lb">
   <xsl:copy>
      <xsl:apply-templates select="@* | node()" mode="dedup-lb"/>
   </xsl:copy>
   </xsl:template>
   
   <xsl:template match="@*" mode="dedup-lb">
       <xsl:copy>
      <xsl:apply-templates select="." mode="dedup-lb"/>
   </xsl:copy>
   </xsl:template>
</xsl:stylesheet>