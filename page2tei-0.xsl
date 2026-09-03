<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:p="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
   xmlns:mets="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
   xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:local="local"
   xmlns:xstring="https://github.com/dariok/XStringUtils" exclude-result-prefixes="#all"
   version="3.0">

   <xsl:output indent="0"/>
   
   <xsl:variable name="langs" select="map { 'French': 'fr', 'German': 'de', 'English': 'en', 'Latin': 'la',
      'Spanish': 'es', 'Ancient Greek': 'grc' }"/>

   <xsl:include href="combine-hi.xsl" />

   <xd:doc>
      <xd:desc>Whether to create `rs type="..."` for person/place/org (default) or `persName` etc.
         (false())</xd:desc>
   </xd:doc>
   <xsl:param name="rs" select="true()"/>

   <xd:doc>
      <xd:desc>Whether to run white space tokenization</xd:desc>
   </xd:doc>
   <xsl:param name="tokenize" select="false()"/>
   <xsl:include href="tokenize.xsl" />
   
   <xd:doc>
      <xd:desc>Whether to combine entities over line breaks</xd:desc>
   </xd:doc>
   <xsl:param name="combine" select="false()"/>
   <xsl:include href="combine-continued.xsl" />

      <xd:doc>
      <xd:desc>Whether to run attribute removing</xd:desc>
   </xd:doc>
   <xsl:param name="remove-attributes" select="false()"/>
   <xsl:include href="remove-attributes.xsl" />

   <xd:doc>
      <xd:desc>Whether to run postprocessing</xd:desc>
   </xd:doc>
   <xsl:param name="postprocessing" select="false()"/>
   <xsl:include href="postprocessing.xsl" />


   <xd:doc>
      <xd:desc>If false(), region types that correspond to valid TEI elements will be returned as
         this element; types that do not correspond to a TEI element will be returned as
         tei:ab[@type]. If set to true(), all region types (except for paragraph, heading) will be
         returned as tei:ab.</xd:desc>
   </xd:doc>
   <xsl:param name="ab" select="false()"/>

   <xd:doc>
      <xd:desc>If true(), export the (estimated) word coordinates to the facsimile section. Default:
         false().</xd:desc>
   </xd:doc>
   <xsl:param name="word-coordinates" select="false()"/>

   <xd:doc>
      <xd:desc>Whether to create bounding rectangles from polygons (default: true())</xd:desc>
   </xd:doc>
   <xsl:param name="bounding-rectangles" select="true()"/>
   <xsl:include href="simplify-coordinates.xsl" />

   <xd:doc>
      <xd:desc>Whether to export lines without baseline (true()) or not (false(), default)</xd:desc>
   </xd:doc>
   <xsl:param name="withoutBaseline" select="false()"/>

   <xd:doc>
      <xd:desc>Whether to export regions without text lines (true()) or not (false(),
         default)</xd:desc>
   </xd:doc>
   <xsl:param name="withoutTextline" select="false()"/>
   
   <xd:doc>
      <xd:desc>Whether to export custom attributes from tags that we do not know how to convert to valid TEI (true(),
         default) or whether to discard them (false()).</xd:desc>
   </xd:doc>
   <xsl:param name="unknownAttributes" select="true()" />

   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p><xd:b>Author:</xd:b> Dario Kampkaspar, dario.kampkaspar@oeaw.ac.at |
            dario.kampkaspar@tu-darmstadt.de</xd:p>
         <xd:p>Austrian Centre for Digital Humanities http://acdh.oeaw.ac.at | University and State
            Library Darmstadt https://ulb.tu-darmstadt.de</xd:p>
         <xd:p/>
         <xd:p>This stylesheet, when applied to mets.xml of the PAGE output, will create (valid)
            TEI</xd:p>
         <xd:p>While this XSLT is designed to run on many different flavours of PAGE-XMLs described
            by a common mets.xml file, some special care was taken to include meta data provided by
            Transkribus; other meta data providers may be included if examples are provided.</xd:p>
         <xd:p/>
         <xd:p><xd:b>Contributor</xd:b> Matthias Boenig, github:@tboenig</xd:p>
         <xd:p>OCR-D, Berlin-Brandenburg Academy of Sciences and Humanities
            http://ocr-d.de/eng</xd:p>
         <xd:p>extend the original XSL-Stylesheet by specific elements based on the @typing of the
            text region</xd:p>
         <xd:p/>
         <xd:p><xd:b>Contributor</xd:b> Peter Stadler, github:@peterstadler</xd:p>
         <xd:p>Carl-Maria-von-Weber-Gesamtausgabe</xd:p>
         <xd:p>Added corrections to tei:sic/tei:corr</xd:p>
         <xd:p/>
         <xd:p><xd:b>Contributor</xd:b> Till Grallert, github:@tillgrallert</xd:p>
         <xd:p>Orient-Institut Beirut</xd:p>
         <xd:p>Use tei:ab as fallback instead of tei:p</xd:p>
         <xd:p><xd:b>Contributor for Customized Adaptions</xd:b> Nadine Quenouille, quenouille@bach-leipzig.de</xd:p>
         <xd:p>Forschungsportal BACH, Sächsische Akademie der Wissenschaften zu Leipzig</xd:p>
         <xd:p>Adaptions for TEI Publisher: Replace seriesStmt with PublicationStmt, add treat for tags add, del, missing, note, supplied, anchor and unclear, added div types 'original' and 'commentary', 
            insert &lt;span type='hyphen'&gt;, add mimeType to graphic, encoding iiif coordinates for TextLines and Table cells, gave the table cells a head, add some tags 
            and attributes, fix continued tags, split facsimilia, add treatment of structural tags (front, back, marginalia, heading, subheading, textblock, unedited, curly brackets), etc.</xd:p>
         <xd:p/>
      </xd:desc>
   </xd:doc>

   <!-- use extended string functions from https://github.com/dariok/XStringUtils -->
   <xsl:include href="string-pack.xsl"/>

   <xsl:param name="debug" select="false()"/>

   <xd:doc>
      <xd:desc>Entry</xd:desc>
   </xd:doc>
   <xsl:template match="/">
      <xsl:apply-templates select="mets:mets" />
   </xsl:template>

   <xd:doc>
      <xd:desc>helper: gather page contents</xd:desc>
   </xd:doc>

   <!-- create div for the front, body and back -->
   <xsl:variable name="make_div">
      <div>
         <xsl:apply-templates select="//mets:fileSec//mets:fileGrp[@ID = 'IMG']/mets:file" mode="text" />
      </div>
   </xsl:variable>
   
   <xd:doc>
      <xd:desc>Entry point: start at the top of METS.xml</xd:desc>
   </xd:doc>
   <xsl:template match="/mets:mets">
         <xsl:text>
   </xsl:text>
      <TEI>
         <xsl:text>
   </xsl:text>
         <teiHeader>
            <xsl:text>
      </xsl:text>
            <fileDesc>
               <xsl:text>
         </xsl:text>
               <titleStmt>
                  <xsl:text>
         </xsl:text>
                  <xsl:apply-templates select="mets:amdSec" mode="titleStmt"/>
                  <xsl:text>
         </xsl:text>
               </titleStmt>
               <xsl:text>
         </xsl:text>
               <publicationStmt>
                  <xsl:apply-templates select="mets:amdSec" mode="publicationStmt"/>
               </publicationStmt>
               <xsl:text>
         </xsl:text>
               <sourceDesc>
                  <xsl:text>
            </xsl:text>
                  <bibl>
                     <xsl:text>
                  </xsl:text>
                     <xsl:apply-templates select="mets:amdSec" mode="sourceDesc"/>
                  </bibl>
                  <xsl:text>
         </xsl:text>
               </sourceDesc>
               <xsl:text>
      </xsl:text>
            </fileDesc>
            <xsl:text>
      </xsl:text>
            <profileDesc>
               <xsl:apply-templates select="descendant::*:trpDocMetadata/*:language" />
               <xsl:text>
      </xsl:text>
            </profileDesc>
            <xsl:text>
   </xsl:text>
         </teiHeader>        
            <xsl:apply-templates select="mets:fileSec//mets:fileGrp[@ID = 'IMG']/mets:file" mode="facsimile"/>  
         <xsl:text>
   </xsl:text>
         <text>
            <xsl:text>
      </xsl:text>
      <xsl:if test="$make_div//*[local-name() = 'div']/*[contains(@type, 'front')]">
      <front>
         <xsl:for-each-group
                     select="$make_div//*[local-name() = 'div']/*[contains(@type, 'front')][not(contains(@type, 'margin_front'))]"
                     group-starting-with="*[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                        | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]"
               >
                  <xsl:text>
         </xsl:text>
              <div xmlns="http://www.tei-c.org/ns/1.0" n='1' type='original_front'>
                     <xsl:variable name="combined">
                        <xsl:choose>
                           <xsl:when test="$combine">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combines">
                        <xsl:choose>
                           <xsl:when test="$combined">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combining">
                        <xsl:apply-templates select="$combines" mode="continued" />
                     </xsl:variable>                     
                     <xsl:variable name="dedup">
                        <xsl:apply-templates select="$combining" mode="dedup-lb" />
                     </xsl:variable>          
                     <xsl:variable name="rmv-attr">
                        <xsl:apply-templates select="$dedup" mode="remove-attributes" />
                     </xsl:variable>         
                     <xsl:variable name="tokenized">
                        <xsl:choose>
                           <xsl:when test="$tokenize">
                              <xsl:apply-templates select="$rmv-attr" mode="tokenize" />                             
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$rmv-attr" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:for-each select="$tokenized/*">
                        <xsl:text>
            </xsl:text>
                        <xsl:apply-templates select="." mode="postprocessing" />
            </xsl:for-each>
                        <xsl:text>
         </xsl:text>
                  </div>
               </xsl:for-each-group>
                  <xsl:text>
         </xsl:text>
                  <div n='1' type='commentary_front'>
                     <xsl:text>
         </xsl:text>
                     <p/>
                  <xsl:text>
         </xsl:text>
                  </div>
            <xsl:if test="$make_div//*[local-name() = 'div']/*[contains(@type, 'margin_front')]">
                  <xsl:for-each-group
                     select="$make_div//*[local-name() = 'div']/*[contains(@type, 'margin_front')][not(contains(@type, 'margin_bottom_back'))][not(contains(@type, 'margin_top_back'))]"
                     group-starting-with="*[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                        | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]"
               >
                  <xsl:text>
         </xsl:text>
                  <div xmlns="http://www.tei-c.org/ns/1.0" n='1' type='marginalia_front'>
                     <xsl:variable name="combined">
                        <xsl:choose>
                           <xsl:when test="$combine">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combines">
                        <xsl:choose>
                           <xsl:when test="$combined">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combining">
                        <xsl:apply-templates select="$combines" mode="continued" />
                     </xsl:variable>                     
                     <xsl:variable name="dedup">
                        <xsl:apply-templates select="$combining" mode="dedup-lb" />
                     </xsl:variable>          
                     <xsl:variable name="rmv-attr">
                        <xsl:apply-templates select="$dedup" mode="remove-attributes" />
                     </xsl:variable>         
                     <xsl:variable name="tokenized">
                        <xsl:choose>
                           <xsl:when test="$tokenize">
                              <xsl:apply-templates select="$rmv-attr" mode="tokenize" />                             
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$rmv-attr" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:for-each select="$tokenized/*">
                        <xsl:text>
            </xsl:text>
                        <xsl:apply-templates select="." mode="postprocessing" />
            </xsl:for-each>
                        <xsl:text>
         </xsl:text>
                  </div>
               </xsl:for-each-group>
            </xsl:if>
         <xsl:text>
      </xsl:text>
      </front>
      <xsl:text>
      </xsl:text>
      </xsl:if>       
            <body>
               <xsl:for-each-group
                     select="$make_div//*[local-name() = 'div']/*[not(contains(@type, 'front'))][not(contains(@type, 'back'))][not(contains(@type, 'margin_body'))]"
                     group-starting-with="*[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                        | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]"
               >
                  <xsl:text>
         </xsl:text>
                  <div xmlns="http://www.tei-c.org/ns/1.0" n='1' type='original'>
                     <xsl:variable name="combined">
                        <xsl:choose>
                           <xsl:when test="$combine">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combines">
                        <xsl:choose>
                           <xsl:when test="$combined">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combining">
                        <xsl:apply-templates select="$combines" mode="continued" />
                     </xsl:variable>  
                     <xsl:variable name="dedup">
                        <xsl:apply-templates select="$combining" mode="dedup-lb" />
                     </xsl:variable>  
                     <xsl:variable name="rmv-attr">
                        <xsl:apply-templates select="$dedup" mode="remove-attributes" />
                     </xsl:variable>         
                     <xsl:variable name="tokenized">
                        <xsl:choose>
                           <xsl:when test="$tokenize">
                              <xsl:apply-templates select="$rmv-attr" mode="tokenize" />                             
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$rmv-attr" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:for-each select="$tokenized/*">
                        <xsl:text>
         </xsl:text>
                        <xsl:apply-templates select="." mode="postprocessing" />
            </xsl:for-each>
                        <xsl:text>
         </xsl:text>
                  </div>
               </xsl:for-each-group>
                  <xsl:text>
         </xsl:text>
                  <div n='1' type='commentary'>
                     <xsl:text>
         </xsl:text>
                     <p/>
                  <xsl:text>
         </xsl:text>
                  </div>
         <xsl:if test="$make_div//*[local-name() = 'div']/*[contains(@type, 'margin_body')]">
                  <xsl:for-each-group
                     select="$make_div//*[local-name() = 'div']/*[contains(@type, 'margin_body')]"
                     group-starting-with="*[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                        | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]"
               >
                  <xsl:text>
         </xsl:text>
                  <div xmlns="http://www.tei-c.org/ns/1.0" n='1' type='marginalia'>
                     <xsl:variable name="combined">
                        <xsl:choose>
                           <xsl:when test="$combine">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combines">
                        <xsl:choose>
                           <xsl:when test="$combined">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combining">
                        <xsl:apply-templates select="$combines" mode="continued" />
                     </xsl:variable>                     
                     <xsl:variable name="dedup">
                        <xsl:apply-templates select="$combining" mode="dedup-lb" />
                     </xsl:variable>          
                     <xsl:variable name="rmv-attr">
                        <xsl:apply-templates select="$dedup" mode="remove-attributes" />
                     </xsl:variable>         
                     <xsl:variable name="tokenized">
                        <xsl:choose>
                           <xsl:when test="$tokenize">
                              <xsl:apply-templates select="$rmv-attr" mode="tokenize" />                             
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$rmv-attr" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     
                     <xsl:for-each select="$tokenized/*">
                        <xsl:text>
            </xsl:text>
                        <xsl:apply-templates select="." mode="postprocessing" />
            </xsl:for-each>
                        <xsl:text>
         </xsl:text>
                  </div>
               </xsl:for-each-group>
            </xsl:if>
         <xsl:text>
      </xsl:text>
      </body>
      <xsl:if test="$make_div//*[local-name() = 'div']/*[contains(@type, 'back')]">
      <xsl:text>
         </xsl:text>
      <back>
         <xsl:for-each-group
                     select="$make_div//*[local-name() = 'div']/*[contains(@type, 'back')][not(contains(@type, 'margin_back'))]"
                     group-starting-with="*[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                        | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]"
               >
                  <xsl:text>
         </xsl:text>
                  <div xmlns="http://www.tei-c.org/ns/1.0" n='1' type='original_back'>
                     <xsl:variable name="combined">
                        <xsl:choose>
                           <xsl:when test="$combine">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combines">
                        <xsl:choose>
                           <xsl:when test="$combined">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combining">
                        <xsl:apply-templates select="$combines" mode="continued" />
                     </xsl:variable>                     
                     <xsl:variable name="dedup">
                        <xsl:apply-templates select="$combining" mode="dedup-lb" />
                     </xsl:variable>          
                     <xsl:variable name="rmv-attr">
                        <xsl:apply-templates select="$dedup" mode="remove-attributes" />
                     </xsl:variable>         
                     <xsl:variable name="tokenized">
                        <xsl:choose>
                           <xsl:when test="$tokenize">
                              <xsl:apply-templates select="$rmv-attr" mode="tokenize" />                             
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$rmv-attr" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:for-each select="$tokenized/*">
                        <xsl:text>
            </xsl:text>
                         <xsl:apply-templates select="." mode="postprocessing" />
            </xsl:for-each>
                        <xsl:text>
         </xsl:text>
                  </div>
               </xsl:for-each-group>
                  <xsl:text>
         </xsl:text>
                  <div n='1' type='commentary_back'>
                     <xsl:text>
         </xsl:text>
                     <p/>
                  <xsl:text>
         </xsl:text>
                  </div>
         <xsl:if test="$make_div//*[local-name() = 'div']/*[contains(@type, 'margin_back')]">
                  <xsl:for-each-group
                     select="$make_div//*[local-name() = 'div']/*[contains(@type, 'margin_back')]"
                     group-starting-with="*[local-name() = 'pb' and following-sibling::*[1][local-name() = 'head']]
                        | *[local-name() = 'head' and not(preceding-sibling::*[1][local-name() = 'pb'])]"
               >
                  <xsl:text>
         </xsl:text>
                  <div xmlns="http://www.tei-c.org/ns/1.0" n='1' type='marginalia_back'>
                     <xsl:variable name="combined">
                        <xsl:choose>
                           <xsl:when test="$combine">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combines">
                        <xsl:choose>
                           <xsl:when test="$combined">
                              <xsl:apply-templates select="current-group()" mode="continued" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="current-group()" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:variable name="combining">
                        <xsl:apply-templates select="$combines" mode="continued" />
                     </xsl:variable>                     
                     <xsl:variable name="dedup">
                        <xsl:apply-templates select="$combining" mode="dedup-lb" />
                     </xsl:variable>          
                     <xsl:variable name="rmv-attr">
                        <xsl:apply-templates select="$dedup" mode="remove-attributes" />
                     </xsl:variable>         
                     <xsl:variable name="tokenized">
                        <xsl:choose>
                           <xsl:when test="$tokenize">
                              <xsl:apply-templates select="$rmv-attr" mode="tokenize" />                             
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:copy-of select="$rmv-attr" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:variable>
                     <xsl:for-each select="$tokenized/*">
                        <xsl:text>
            </xsl:text>
                        <xsl:apply-templates select="." mode="postprocessing" />
            </xsl:for-each>
                        <xsl:text>
         </xsl:text>
                  </div>
               </xsl:for-each-group>
            </xsl:if>
         <xsl:text>
      </xsl:text>
      </back>
      </xsl:if>
      <xsl:text>
   </xsl:text>
         </text>
         <xsl:text>
</xsl:text>
      </TEI>
   </xsl:template>

   <!-- create teiHeader from METS and (if present) included Transkribus Meta data -->
   <xd:doc>
      <xd:desc>Contents for titleStmt</xd:desc>
   </xd:doc>
   <xsl:template match="mets:amdSec" mode="titleStmt">
      <xsl:apply-templates select="descendant::trpDocMetadata/title"/>
      <xsl:apply-templates select="descendant::trpDocMetadata/author"/>
   </xsl:template>

   <xd:doc>
      <xd:desc>Contents for publicationStmt</xd:desc>
   </xd:doc>
   <xsl:template match="mets:amdSec" mode="publicationStmt">
      <xsl:apply-templates select="descendant::trpDocMetadata//colList[1]/colName"/>
   </xsl:template>

   <xd:doc>
      <xd:desc>Contents for sourceDesc</xd:desc>
   </xd:doc>
   <xsl:template match="mets:amdSec" mode="sourceDesc">
      <xsl:apply-templates select="descendant::trpDocMetadata/title"/>
      <xsl:apply-templates
         select="descendant::trpDocMetadata/author | descendant::trpDocMetadata/writer"/>
      <!-- <idno type="Transkribus">
         <xsl:value-of select="descendant::trpDocMetadata/docId"/>
      </idno> -->
      <xsl:apply-templates select="descendant::trpDocMetadata/externalId"/>
      <xsl:apply-templates select="descendant::trpDocMetadata/desc"/>
   </xsl:template>

   <xd:doc>
      <xd:desc>Contents for editionStmt</xd:desc>
   </xd:doc>
   <xsl:template match="mets:amdSec" mode="editionStmt">
      <p>TRP document creator: <xsl:value-of select="descendant::trpDocMetadata/uploader"/></p>
      <xsl:apply-templates select="mets:amdSec//trpDocMetadata/desc"/>
   </xsl:template>

   <!-- Templates for trpMetaData -->
   <xd:doc>
      <xd:desc>
         <xd:p>The title within the Transkribus meta data</xd:p>
      </xd:desc>
   </xd:doc>
   <xsl:template match="title">
      <title>
         <xsl:if test="position() = 1">
            <xsl:attribute name="type">main</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates/>
      </title>
   </xsl:template>

   <xd:doc>
      <xd:desc>The author as stated in Transkribus meta data. Will be used in the teiHeader as
         titleStmt/author</xd:desc>
   </xd:doc>
   <xsl:template match="author">
      <author>
         <xsl:apply-templates/>
      </author>
   </xsl:template>

   <xd:doc>
      <xd:desc>The author as stated in Transkribus meta data. Will be used in the teiHeader as
         titleStmt/respStmt</xd:desc>
   </xd:doc>
   <xsl:template match="writer">
      <respStmt>
         <resp>Writer</resp>
         <name>
            <xsl:apply-templates/>
         </name>
      </respStmt>
   </xsl:template>

   <xd:doc>
      <xd:desc>The description as given in Transkribus meta data. Will be used in
         sourceDesc</xd:desc>
   </xd:doc>
   <xsl:template match="desc">
      <note>
         <xsl:apply-templates/>
      </note>
   </xsl:template>

   <xd:doc>
      <xd:desc>The name of the collection from which this document was exported. Will be used as
         publicationStmt/publisher</xd:desc>
   </xd:doc>
   <xsl:template match="colName">
      <publisher>Forschungsportal BACH</publisher>
   </xsl:template>

   <xd:doc>
      <xd:desc>Transkribus meta data: external ID</xd:desc>
   </xd:doc>
   <xsl:template match="externalId">
      <idno type="pid">
         <xsl:value-of select="."/>
      </idno>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Transkribus meta data: languages</xd:desc>
   </xd:doc>
   <xsl:template match="language">
      <xsl:text>
         </xsl:text>
      <langUsage>
         <xsl:for-each select="tokenize(., ', ')">
            <xsl:text>
            </xsl:text>
            <language>
               <xsl:attribute name="ident">
                  <xsl:value-of select="map:get($langs, .)" />
               </xsl:attribute>
               <xsl:value-of select="." />
            </language>
         </xsl:for-each>
         <xsl:text>
         </xsl:text>
      </langUsage>
   </xsl:template>

   <!-- Templates for METS -->
   <xd:doc>
      <xd:desc>Create tei:facsimile with @xml:id</xd:desc>
   </xd:doc>
   <xsl:template match="mets:file" mode="facsimile">
      <xsl:variable name="file" select="document(ancestor::mets:fileGrp[@ID='MASTER']/mets:fileGrp[@ID='PAGEXML']/mets:file[@SEQ = current()/@SEQ]/mets:FLocat/@xlink:href)"/>
      <xsl:variable name="numCurr" select="@SEQ"/>
      <xsl:variable name="imageurl" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>

      <xsl:apply-templates select="$file//p:Page" mode="facsimile">
         <xsl:with-param name="imageName" select="substring-after(mets:FLocat/@xlink:href, '/')" tunnel="true"/>
         <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
         <xsl:with-param name="imageurl" select="$imageurl" tunnel="true"/>
      </xsl:apply-templates>
   </xsl:template>

   <xd:doc>
      <xd:desc>Apply by-page</xd:desc>
   </xd:doc>
   <xsl:template match="mets:file" mode="text">
      <xsl:variable name="file" select="document(ancestor::mets:fileGrp[@ID='MASTER']/mets:fileGrp[@ID='PAGEXML']/mets:file[@SEQ = current()/@SEQ]/mets:FLocat/@xlink:href)"/>
      <xsl:variable name="numCurr" select="@SEQ"/>
      <xsl:variable name="imgurl" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>

      <xsl:apply-templates select="$file//p:Page" mode="text">
         <xsl:with-param name="numCurr" select="$numCurr" tunnel="true"/>
         <xsl:with-param name="imgurl" select="$imgurl" tunnel="true"/>
      </xsl:apply-templates>
   </xsl:template>

   <!-- Templates for PAGE, facsimile -->
   <xd:doc>
      <xd:desc>
         <xd:p>Create tei:facsimile/tei:surface</xd:p>
      </xd:desc>
      <xd:param name="imageName">
         <xd:p>the file name of the image</xd:p>
      </xd:param>
      <xd:param name="numCurr">
         <xd:p>Numerus currens of the parent facsimile</xd:p>
      </xd:param>
   </xd:doc>
   <xsl:template match="p:Page" mode="facsimile">
      <xsl:param name="numCurr" tunnel="true"/>
      <xsl:param name="imageurl" tunnel="true"/>

      <xsl:variable name="coords" select="tokenize(p:PrintSpace/p:Coords/@points, ' ')"/>
      <xsl:variable name="type" select="substring-after(@imageFilename, '.')"/>

      <xsl:text>
   </xsl:text>
      <facsimile xml:id="facs_{$numCurr}">
   <xsl:text>
      </xsl:text>
      <surface ulx="0" uly="0" lrx="{@imageWidth}" lry="{@imageHeight}">
      <xsl:text>
         </xsl:text>
         <graphic url="{$imageurl}" width="{@imageWidth}px"
            height="{@imageHeight}px" rend="facstab"/>
         <!-- include Transkribus image link as second graphic element for later evaluation -->
            <xsl:apply-templates select="preceding-sibling::p:Metadata/*:TranskribusMetadata"/>
            <xsl:apply-templates
            select="p:PrintSpace | p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TableRegion"
            mode="facsimile"/>
         <xsl:text>
      </xsl:text>
      </surface>
      <xsl:text>
   </xsl:text>
      </facsimile>
   </xsl:template>

   <xd:doc>
      <xd:desc>create the zones within facsimile/surface</xd:desc>
      <xd:param name="numCurr">Numerus currens of the current page</xd:param>
   </xd:doc>
   <xsl:template
      match="p:PrintSpace | p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TextLine"
      mode="facsimile">
      <xsl:param name="numCurr" tunnel="true"/>

   <!-- Create ulx, uly, lrx and lry by getting the coordinates's points, format and sort them and take the max and min values -->
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

      <xsl:variable name="lrxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>

      <xsl:variable name="lrx">
         <xsl:choose>
            <xsl:when test="$lrxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lrxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>
      
      <xsl:variable name="ulx">
         <xsl:choose>
            <xsl:when test="$ulxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="lryb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="lry">
         <xsl:choose>
            <xsl:when test="$lryb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lryb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulyb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="uly">
         <xsl:choose>
            <xsl:when test="$ulyb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulyb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="renditionValue">
         <xsl:choose>
            <xsl:when test="local-name(parent::*) = 'TableCell'">TableCell</xsl:when>
            <xsl:when test="local-name() = 'TextRegion'">TextRegion</xsl:when>
            <xsl:when test="local-name() = 'SeparatorRegion'">Separator</xsl:when>
            <xsl:when test="local-name() = 'GraphicRegion'">Graphic</xsl:when>
            <xsl:when test="local-name() = 'TextLine'">Line</xsl:when>
            <xsl:otherwise>printspace</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="custom" as="map(xs:string, xs:string)">
         <xsl:map>
            <xsl:for-each-group select="tokenize(@custom || ' lfd {' || $numCurr, '\} ')"
               group-by="substring-before(., ' ')">
               <xsl:map-entry key="substring-before(., ' ')"
                  select="string-join(substring-after(., '{'), '–')"/>
            </xsl:for-each-group>
         </xsl:map>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="self::p:TextLine">
            <xsl:text>
            </xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>
         </xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <zone ulx="{$ulx}" uly="{$uly}" lrx="{$lrx}" lry="{$lry}" rendition="{$renditionValue}">
         <xsl:if test="$renditionValue != 'printspace'">
            <xsl:attribute name="xml:id">
               <xsl:value-of select="'facs_' || $numCurr || '_' || @id"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="@type">
            <xsl:attribute name="subtype">
               <xsl:value-of select="@type"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="map:contains($custom, 'structure') and not(@type)">
            <xsl:attribute name="subtype"
               select="substring-after(substring-before(map:get($custom, 'structure'), ';'), ':')"/>
         </xsl:if>
         <xsl:apply-templates select="p:TextLine" mode="facsimile"/>
         <xsl:if test="$word-coordinates">
            <xsl:apply-templates select="p:Word" mode="facsimile" />
         </xsl:if>
         <xsl:choose>
            <xsl:when test="self::p:TextLine and p:Word and $word-coordinates">
               <xsl:text>
            </xsl:text>
            </xsl:when>
            <xsl:when test="self::p:TextRegion">
               <xsl:text>
         </xsl:text>
            </xsl:when>
         </xsl:choose>
      </zone>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>create a zone for each word within facsimile/surface</xd:desc>
      <xd:param name="numCurr">Numerus currens of the current page</xd:param>
   </xd:doc>
   <xsl:template match="p:Word" mode="facsimile">
      <xsl:param name="numCurr" tunnel="true"/>

   <!-- Create ulx, uly, lrx and lry by getting the coordinates's points, format and sort them and take the max and min values -->
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

      <xsl:variable name="lrxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>

      <xsl:variable name="lrx">
         <xsl:choose>
            <xsl:when test="$lrxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lrxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>
      
      <xsl:variable name="ulx">
         <xsl:choose>
            <xsl:when test="$ulxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="lryb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="lry">
         <xsl:choose>
            <xsl:when test="$lryb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lryb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulyb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="uly">
         <xsl:choose>
            <xsl:when test="$ulyb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulyb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      
      <xsl:text>
               </xsl:text>
      <zone ulx="{$ulx}" uly="{$uly}" lrx="{$lrx}" lry="{$lry}" type="word">
         <xsl:attribute name="xml:id">
            <xsl:value-of select="'facs_' || $numCurr || '_' || @id"/>
         </xsl:attribute>
      </zone>
   </xsl:template>

   <xd:doc>
      <xd:desc>Create the zone for a table</xd:desc>
      <xd:param name="numCurr">Numerus currens of the current page</xd:param>
   </xd:doc>
   <xsl:template match="p:TableRegion" mode="facsimile">
      <xsl:param name="numCurr" tunnel="true"/>

   <!-- Create ulx, uly, lrx and lry by getting the coordinates's points, format and sort them and take the max and min values -->
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

      <xsl:variable name="lrxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>

      <xsl:variable name="lrx">
         <xsl:choose>
            <xsl:when test="$lrxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lrxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>
      
      <xsl:variable name="ulx">
         <xsl:choose>
            <xsl:when test="$ulxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="lryb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="lry">
         <xsl:choose>
            <xsl:when test="$lryb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lryb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulyb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="uly">
         <xsl:choose>
            <xsl:when test="$ulyb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulyb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:text>
         </xsl:text>
      <zone ulx="{$ulx}" uly="{$uly}" lrx="{$lrx}" lry="{$lry}" rendition="Table">
         <xsl:attribute name="xml:id">
            <xsl:value-of select="'facs_' || $numCurr || '_' || @id"/>
         </xsl:attribute>
         <xsl:apply-templates select="p:TableCell//p:TextLine" mode="facsimile"/>
      <xsl:text>
         </xsl:text>
      </zone>
   </xsl:template>

   <xd:doc>
      <xd:desc>create the page content</xd:desc>
      <xd:param name="numCurr">Numerus currens of the current page</xd:param>
   </xd:doc>
   <!-- Templates for PAGE, text -->
   <xsl:template match="p:Page" mode="text">
      <xsl:param name="numCurr" tunnel="true"/>
      <xsl:choose>
      <xsl:when test="//p:TextRegion[contains(@custom, 'front')]">
      <xsl:apply-templates
         select="p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TableRegion" mode="text">
         <xsl:with-param name="center" tunnel="true" select="number(@imageWidth) div 2"
            as="xs:double"/>
      </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="//p:TextRegion[contains(@custom, 'back')]">
      <xsl:apply-templates
         select="p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TableRegion" mode="text">
         <xsl:with-param name="center" tunnel="true" select="number(@imageWidth) div 2"
            as="xs:double"/>
      </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
      <pb facs="#facs_{$numCurr}" n="{$numCurr}"/>
      <xsl:apply-templates
         select="p:TextRegion | p:SeparatorRegion | p:GraphicRegion | p:TableRegion" mode="text">
         <xsl:with-param name="center" tunnel="true" select="number(@imageWidth) div 2"
            as="xs:double"/>
      </xsl:apply-templates>
      </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xd:doc>
      <xd:desc>
         <xd:p>create specific elements based on the @typing of the text region</xd:p>
         <xd:p>PAGE labels for text region see: https://www.primaresearch.org/tools/PAGELibraries
            caption observed header observed footer observed page-number observed drop-capital
            ignored credit ignored floating ignored signature-mark observed catch-word observed
            marginalia observed footnote observed footnote-continued observed endnote ignored
            TOC-entry ignored list-label ignored other observed </xd:p>
         <xd:p>milestone with attribute "unit='section'" and "facs='...'" indicates the text regions</xd:p>
      </xd:desc>
      <xd:param name="numCurr"/>
      <xd:param name="imgurl"/>
      <xd:param name="center"/>
   </xd:doc>
   <xsl:template match="p:TextRegion" mode="text">
      <xsl:param name="numCurr" tunnel="true"/>
      <xsl:param name="imgurl" tunnel="true"/>
      <xsl:param name="center" tunnel="true" as="xs:double"/>
      <xsl:variable name="points" as="xs:string*">
                  <xsl:for-each select="./p:Coords/@points">
                     <xsl:sequence select="tokenize(., '\s+')" />
                  </xsl:for-each>
               </xsl:variable>
               <xsl:variable name="xs" select="for $p in $points return number(substring-before($p, ','))"/>
               <xsl:variable name="ys" select="for $p in $points return number(substring-after($p, ','))"/>
               <xsl:variable name="ulx" select="min($xs)"/>
               <xsl:variable name="uly" select="min($ys)"/>
               <xsl:variable name="lrx" select="max($xs)"/>
               <xsl:variable name="lry" select="max($ys)"/>
               <xsl:variable name="w" select="$lrx - $ulx"/>
               <xsl:variable name="h" select="$lry - $uly"/>
      
      <xsl:variable name="custom" as="map(*)">
         <xsl:apply-templates select="@custom"/>
      </xsl:variable>
      <xsl:variable name="regionType" as="xs:string*" select="(@type, $custom?structure?type)" />
      <xsl:variable name="target" select="(@target, $custom?structure?target)"/>
      <xsl:variable name="number" select="//ancestor::p:Metadata//p:TranskribusMetadata/@pageNr"/>
      <xsl:choose>
         <xsl:when test="not(p:TextLine or $withoutTextline)"/>
         <xsl:when test="'heading' = $regionType">
            <head facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </head>
         </xsl:when>
         <xsl:when test="'caption' = $regionType and not($ab)">
            <figure>
               <head facs="#facs_{$numCurr}_{@id}">
                  <xsl:apply-templates select="p:TextLine"/>
               </head>
            </figure>
         </xsl:when>
         <xsl:when test="'header' = $regionType and not($ab)">
            <fw type="header" place="top" facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </fw>
         </xsl:when>
         <xsl:when test="'music' = $regionType and not($ab)">
             <xsl:text>
               </xsl:text>
            <p>
         <xsl:text>
            </xsl:text>
            <notatedMusic>
         <xsl:text>
               </xsl:text>
               <ptr target="{$target}"/>
            <xsl:text>
               </xsl:text>
               <label facs="#facs_{$numCurr}_{@id}">
                  <xsl:apply-templates select="p:TextLine"/>
               </label>
         <xsl:text>
            </xsl:text>
            </notatedMusic>
         <xsl:text>
         </xsl:text>
            </p>
         </xsl:when>
         <xsl:when test="'catch-word' = $regionType and not($ab)">
            <fw type="catch" place="bottom" facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </fw>
         </xsl:when>
         <xsl:when test="'signature-mark' = $regionType and not($ab)">
            <fw place="bottom" type="sig" facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </fw>
         </xsl:when>
         <xsl:when test="'marginalia_front' = $regionType and not($ab) and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:bottom')]">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_bottom_front"/>
            <ab type='margin_bottom_front'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia_front' = $regionType and not($ab) and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')]">
           <xsl:text>
            </xsl:text>
            <pb facs="#facs_{$number}" n="{$number}" type="front"/>
           <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_top_front"/>
            <ab type='margin_top_front'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia_front' = $regionType and not($ab) and not(p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:bottom')]) and not(p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')])">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_front"/>
            <ab type='margin_front'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia' = $regionType and not($ab) and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:bottom')]">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_bottom"/>
            <ab type='margin_bottom'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia' = $regionType and not($ab) and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')]">
            <xsl:text>
            </xsl:text>
            <pb facs="#facs_{$number}" n="{$number}" type="body"/>
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_top"/>
            <ab type='margin_top'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia' = $regionType and not($ab) and not(p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:bottom')]) and not(p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')])">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_body"/>
            <ab type='margin_body'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia_back' = $regionType and not($ab) and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:bottom')]">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_bottom_back"/>
            <ab type='margin_bottom_back'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia_back' = $regionType and not($ab) and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')]">
            <xsl:text>
            </xsl:text>
            <pb facs="#facs_{$number}" n="{$number}" type="back"/>
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_top_back"/>
            <ab type='margin_top_back'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'marginalia_back' = $regionType and not($ab) and not(p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:bottom')]) and not(p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')])">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="margin_back"/>
            <ab type='margin_back'>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'footnote-continued' = $regionType and not($ab)">
            <note place="foot" n="[footnote-continued reference]" facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </note>
         </xsl:when>
         <xsl:when test="'endnote' = $regionType and not($ab)">
            <note type="endnote" n="[footnote reference]" facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </note>
         </xsl:when>
         <xsl:when test="'footer' = $regionType and not($ab)">
            <fw type="footer" place="bottom" facs="#facs_{$numCurr}_{@id}">
               <xsl:apply-templates select="p:TextLine"/>
            </fw>
         </xsl:when>
         <xsl:when test="'additions_corrections' = $regionType and not($ab)">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <ab type='add-tags'>
               <xsl:apply-templates select="p:TextLine"/>
            <xsl:text>
         </xsl:text>
            </ab>
         </xsl:when>
         <xsl:when test="'page-number' = $regionType and not($ab)">
            <fw type="page-number" facs="#facs_{$numCurr}_{@id}">
               <xsl:attribute name="place">
                  <xsl:variable name="verticalPosition"
                     select="p:Coords/@points => substring-before(' ') => substring-after(',') => number()"/>
                  <xsl:choose>
                     <xsl:when
                        test="$verticalPosition div number(parent::p:Page/@imageHeight) lt .33">
                        <xsl:text>top</xsl:text>
                     </xsl:when>
                     <xsl:when
                        test="$verticalPosition div number(parent::p:Page/@imageHeight) lt .66">
                        <xsl:text>centre</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>bottom</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               <xsl:apply-templates select="p:TextLine"/>
            </fw>
         </xsl:when>
         <xsl:when test="'unedited' = $regionType">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" type="unedited" />
            <xsl:text>
         </xsl:text>
            <lb facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" type="unedited"/><note type="unedited">Nicht edierter Text.</note>
         </xsl:when>
         <!-- text block with another one side by side containing a curly bracket that should be displayed as grid -->
         <xsl:when test="'textblock' = $regionType or 'curly-bracket-left-in' = $regionType or 'curly-bracket-left-out' = $regionType or 'curly-bracket-right-in' = $regionType or 'curly-bracket-right-out' = $regionType or 'curly-bracket-top-in' = $regionType or 'curly-bracket-top-out' = $regionType or 'curly-bracket-bottom-in' = $regionType or 'curly-bracket-bottom-out' = $regionType">
            <xsl:variable name="customAttr" select="following::p:TextRegion[1]/@custom" />
            <xsl:variable name="preCustomAttr" select="preceding::p:TextRegion[1]/@custom" />
            <xsl:text>
            </xsl:text>
            <xsl:choose>            
            <xsl:when test="'textblock' = $regionType and contains($customAttr, 'curly-bracket-left-in')">
            <ab n="2" rend="container">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />            
            <xsl:text>
            </xsl:text>            
            <ab n="3" rend="textblock">
            <xsl:text>
            </xsl:text>
               <p>
                 <xsl:apply-templates select="p:TextLine"/>
                 <xsl:text>
            </xsl:text>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            <xsl:choose>            
            <xsl:when test="contains($customAttr, 'curly-bracket-left-in')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-li">  
            <xsl:text>
            </xsl:text>
               <p>      
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-left-out')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-lo"> 
            <xsl:text>
            </xsl:text>   
               <p>   
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-right-in')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-ri">
            <xsl:text>
            </xsl:text>
               <p>
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-right-out')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-ro">
            <xsl:text>
            </xsl:text>
               <p>
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-top-in')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-ti">
            <xsl:text>
            </xsl:text>
               <p>
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-top-out')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-to">
            <xsl:text>
            </xsl:text>
               <p>
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-bottom-in')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-bi">
            <xsl:text>
            </xsl:text>
               <p>
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($customAttr, 'curly-bracket-bottom-out')">
            <xsl:for-each select="following::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-bo">
            <xsl:text>
            </xsl:text>
               <p>
                  <xsl:apply-templates select="p:TextLine"/>
               </p>
               <xsl:text>
            </xsl:text>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            
            </xsl:choose>            
            </ab>            
         </xsl:when>
          <xsl:when test="'textblock' = $regionType and preceding::p:TextRegion[1][contains($preCustomAttr, 'curly-bracket-')]">
            <ab n="2" rend="container">
            <xsl:text>
            </xsl:text>
            <xsl:choose>            
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-left-in')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-li">        
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-left-out')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-lo">       
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-right-in')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-ri">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-right-out')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-ro">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-top-in')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-ti">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-top-out')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-to">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-bottom-in')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-bi">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            <xsl:when test="contains($preCustomAttr, 'curly-bracket-bottom-out')">
            <xsl:for-each select="preceding::p:TextRegion[1]">
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <xsl:text>
            </xsl:text>
            <ab n="3" rend="tb cbr-bo">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
               <xsl:text>
            </xsl:text>
            </xsl:for-each>
            </xsl:when>
            
            </xsl:choose> 
            <xsl:text> 
            </xsl:text>         
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />            
            <xsl:text>
            </xsl:text>            
            <ab n="3" rend="textblock">
               <xsl:apply-templates select="p:TextLine"/>
            </ab>
            <xsl:text>
            </xsl:text>
            </ab>
            <xsl:text>
            </xsl:text>
          </xsl:when> 
          <xsl:when test="$regionType = 'textblock' and not('curly-bracket-left-in' = $regionType or 'curly-bracket-left-out' = $regionType or 'curly-bracket-right-in' = $regionType or 'curly-bracket-right-out' = $regionType or 'curly-bracket-top-in' = $regionType or 'curly-bracket-top-out' = $regionType or 'curly-bracket-bottom-in' = $regionType or 'curly-bracket-bottom-out' = $regionType)">  
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />            
            <xsl:text>
            </xsl:text>            
            <ab n="2" rend="textblock">
            <xsl:text>
            </xsl:text> 
            <p>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text> 
            </p>
         <xsl:text>
         </xsl:text> 
            </ab>
            <xsl:text>
            </xsl:text>
          </xsl:when>          
         </xsl:choose>
         </xsl:when>    
         <xsl:when test="'paragraph' = $regionType and (not($regionType = 'textblock') or not(contains($regionType, 'curly-bracket')))">
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <p>
               <xsl:apply-templates select="p:TextLine"/>
            </p>
         </xsl:when>    
         <xsl:when test="'front' = $regionType">
          <xsl:if test="not(preceding-sibling::p:TextRegion[contains(@custom, 'type:marginalia_front') and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')]])">
            <xsl:text>
            </xsl:text>
            <pb facs="#facs_{$number}" n="{$number}" type="front"/>
         </xsl:if>
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$number}_{@id}" type="front"/>
            <p type="front">
               <xsl:apply-templates select="p:TextLine"/>
            </p>
         </xsl:when>
         <xsl:when test="'back' = $regionType">
          <xsl:if test="not(preceding-sibling::p:TextRegion[contains(@custom, 'type:marginalia_back') and p:TextLine[contains(@custom, 'note {') and contains(@custom, 'place:top')]])">
            <xsl:text>
            </xsl:text>
            <pb facs="#facs_{$number}" n="{$number}" type="back"/>
         </xsl:if>
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$number}_{@id}" type="back"/>
            <p type="back">
               <xsl:apply-templates select="p:TextLine"/>
            </p>
         </xsl:when>
         <!-- the fallback option should be a semantically open element such as <ab> -->
         <xsl:otherwise>
            <xsl:text>
            </xsl:text>
            <milestone unit="section" facs="#facs_{$numCurr}_{@id}" />
            <p>
               <xsl:apply-templates select="p:TextLine"/>
               <xsl:text>
            </xsl:text>
            </p>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xd:doc>
      <xd:desc>create a table</xd:desc>
      <xd:param name="numCurr"/>
      <xd:param name="imgurl"/>
   </xd:doc>
   <xsl:template match="p:TableRegion" mode="text">
   <xsl:param name="numCurr" tunnel="true"/>
   <xsl:param name="imgurl" tunnel="true"/>

   <table facs="#facs_{$numCurr}_{@id}">

      <!-- Group cells by rows -->
      <xsl:variable name="rows" as="element()*">
         <xsl:for-each-group select="p:TableCell" group-by="@row">
            <xsl:sort select="@row" data-type="number"/>
            <row-group row="{current-grouping-key()}" unedited="{every $cell in current-group() satisfies contains($cell/@custom, 'unedited')}">
               <xsl:copy-of select="current-group()"/>
            </row-group>
         </xsl:for-each-group>
      </xsl:variable>

      <!-- Group blocks (on basis of unedited / not-unedited) -->
      <xsl:for-each-group select="$rows" group-adjacent="@unedited">
         <xsl:variable name="unedited" select="current-grouping-key()"/>
         <xsl:variable name="block" select="current-group()"/>

         <xsl:choose>
            <!-- Group all unedited rows -->
            <xsl:when test="$unedited = true()">
               <!-- group all cells of this block -->
               <xsl:variable name="allCells" select="$block/*"/>
               <!-- Give back row start and end numbers -->
               <xsl:variable name="rowStart" select="min($block/@row)"/>
               <xsl:variable name="rowEnd" select="max($block/@row)"/>
               <xsl:variable name="rowRange">
                  <xsl:choose>
                     <xsl:when test="$rowStart = $rowEnd">
                        <xsl:value-of select="$rowStart"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="concat($rowStart, '–', $rowEnd)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>

               <!-- calculate coordinates of the bounding box -->
               <xsl:variable name="points" as="xs:string*">
                  <xsl:for-each select="$allCells/p:Coords/@points">
                     <xsl:sequence select="tokenize(., '\s+')" />
                  </xsl:for-each>
               </xsl:variable>
               <xsl:variable name="xs" select="for $p in $points return number(substring-before($p, ','))"/>
               <xsl:variable name="ys" select="for $p in $points return number(substring-after($p, ','))"/>
               <xsl:variable name="ulx" select="min($xs)"/>
               <xsl:variable name="uly" select="min($ys)"/>
               <xsl:variable name="lrx" select="max($xs)"/>
               <xsl:variable name="lry" select="max($ys)"/>
               <xsl:variable name="w" select="$lrx - $ulx"/>
               <xsl:variable name="h" select="$lry - $uly"/>
               <xsl:variable name="maxCols" select="max($allCells/@col) + 1"/>

                  <!-- Output -->
                     <xsl:text>
            </xsl:text>
                     <row n="{$rowRange}" role="unedited" rows="{count($block)}">
                     <xsl:text>
            </xsl:text>
                     <cell role="unedited" cols="{$maxCols}">
                     <xsl:text>
            </xsl:text>
                        <lb facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}"/><note type="unedited">Nicht edierter Text.</note>
                     </cell>
                  </row>
            </xsl:when>

            <!-- Normal Rows -->
            <xsl:otherwise>
               <xsl:for-each select="$block">
                  <xsl:text>
            </xsl:text>
                  <row n="{@row}">
                     <xsl:apply-templates select="*"/>
                  </row>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each-group>
   </table>
</xsl:template>

   <xd:doc>
      <xd:desc>create table cells</xd:desc>
      <xd:param name="numCurr"/>
      <xd:param name="imgurl"/>
   </xd:doc>
   <xsl:template match="p:TableCell">
      <xsl:param name="numCurr" tunnel="true"/>
      <xsl:param name="imgurl" tunnel="true"/>

      <!-- Create ulx, uly, w and h by getting the coordinates's points, format and sort them and take the max and min values -->
      <xsl:variable name="x-string">
         <xsl:for-each select="tokenize(./p:Coords/@points, ' ')">
            <xsl:if test="position() > 1">,</xsl:if>
            <xsl:value-of select="substring-before(current(), ',')" />
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="y-string">
         <xsl:for-each select="tokenize(./p:Coords/@points, ' ')">
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

      <xsl:variable name="lrxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>

      <xsl:variable name="lrx">
         <xsl:choose>
            <xsl:when test="$lrxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lrxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>
      
      <xsl:variable name="ulx">
         <xsl:choose>
            <xsl:when test="$ulxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="lryb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="lry">
         <xsl:choose>
            <xsl:when test="$lryb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lryb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulyb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="uly">
         <xsl:choose>
            <xsl:when test="$ulyb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulyb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="w">
         <xsl:choose>
            <xsl:when test="($lrx - $ulx) &lt; 0">
               <xsl:value-of select="0" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="($lrx - $ulx)" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="h">
         <xsl:choose>
            <xsl:when test="($lry - $uly) &lt; 0">
               <xsl:value-of select="0" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="($lry - $uly)" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
         <xsl:text>
            </xsl:text>
      <xsl:choose>
         <xsl:when test="contains(@custom, 'unedited')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'unedited'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="number((xs:boolean(@leftBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@topBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@rightBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@bottomBorderVisible), false())[1])"/>
            </xsl:attribute>
            <lb facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}"/><note type="unedited">Nicht edierter Text.</note>            
            </cell>
        </xsl:when>
         <xsl:when test="contains(@custom, 'subheading')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'subheading'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="number((xs:boolean(@leftBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@topBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@rightBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@bottomBorderVisible), false())[1])"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'heading')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'heading'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="number((xs:boolean(@leftBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@topBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@rightBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@bottomBorderVisible), false())[1])"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-left-in')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-left-in'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-li'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-left-out')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-left-out'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-lo'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-right-in')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-right-in'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-ri'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-right-out')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-right-out'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-ro'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-top-in')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-top-in'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-ti'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-top-out')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-top-out'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-to'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-bottom-in')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-bottom-in'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-bi'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:when test="contains(@custom, 'curly-bracket-bottom-out')">
            <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="role">
               <xsl:value-of select="'curly-bracket-bottom-out'"/>
            </xsl:attribute>
            <xsl:attribute name="rend">
               <xsl:value-of select="'cbr-bo'"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
            </cell>
         </xsl:when>
         <xsl:otherwise>
         <cell facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}" n="{@col}">
            <xsl:apply-templates select="@rowSpan | @colSpan"/>
            <xsl:attribute name="rend">
               <xsl:value-of select="number((xs:boolean(@leftBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@topBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@rightBorderVisible), false())[1])"/>
               <xsl:value-of select="number((xs:boolean(@bottomBorderVisible), false())[1])"/>
            </xsl:attribute>
            <xsl:apply-templates select="p:TextLine"/>
         </cell>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xd:doc>
      <xd:desc>rowspan -> rows</xd:desc>
   </xd:doc>
   <xsl:template match="@rowSpan">
      <xsl:choose>
         <xsl:when test=". &gt; 1">
            <xsl:attribute name="rows" select="."/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xd:doc>
      <xd:desc>colspan -> cols</xd:desc>
   </xd:doc>
   <xsl:template match="@colSpan">
      <xsl:choose>
         <xsl:when test=". &gt; 1">
            <xsl:attribute name="cols" select="."/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xd:doc>
      <xd:desc>Converts one line of PAGE to one line of TEI</xd:desc>
      <xd:param name="numCurr">Numerus currens, to be tunneled through from the page
         level</xd:param>
   </xd:doc>
   <xsl:template match="p:TextLine">
      <xsl:param name="numCurr" tunnel="true"/>
      <xsl:param name="imgurl" tunnel="true"/>

      <xsl:if test="p:Baseline or $withoutBaseline">
         <xsl:variable name="text" select="p:TextEquiv/p:Unicode"/>
         <xsl:variable name="custom" as="text()*">
            <xsl:for-each select="tokenize(@custom, '\}')">
               <xsl:variable name="content" select="substring-after(., '{') => normalize-space()"/>
               <xsl:variable name="name" select="substring-before(., ' {') => normalize-space()"/>
               <xsl:choose>
                  <xsl:when test="not(contains(., 'offset:'))" />
                  <xsl:otherwise>
                     <xsl:value-of select="normalize-space()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:variable>
         <xsl:variable name="starts" as="map(*)">
            <xsl:map>
               <xsl:if test="count($custom) &gt; 0">
                  <xsl:for-each-group select="$custom"
                     group-by="substring-before(substring-after(., 'offset:'), ';')">
                     <xsl:map-entry key="xs:int(current-grouping-key())" select="current-group()"/>
                  </xsl:for-each-group>
               </xsl:if>
            </xsl:map>
         </xsl:variable>
         <xsl:variable name="ends" as="map(*)">
            <xsl:map>
               <xsl:if test="count($custom) &gt; 0">
                  <xsl:for-each-group select="$custom" group-by="
                        xs:int(substring-before(substring-after(., 'offset:'), ';'))
                        + xs:int(substring-before(substring-after(., 'length:'), ';'))">
                     <xsl:map-entry key="current-grouping-key()" select="current-group()"/>
                  </xsl:for-each-group>
               </xsl:if>
            </xsl:map>
         </xsl:variable>
         <xsl:variable name="prepped">
            <xsl:for-each select="0 to string-length($text)">
               <xsl:if test=".">
                  <xsl:value-of select="substring($text, ., 1)"/>
               </xsl:if>
               <!-- place end marker for all non-void elements that end here; we must not place void elements here
                  as this would mean closing a tei:gap before it was opened -->
               <xsl:for-each select="map:get($ends, .)">
                  <xsl:sort select="contains(., 'continued:true;')" order="ascending"/>
                  <xsl:sort select="substring-before(substring-after(., 'change:'), ';')"
                     order="descending"/>
                  <xsl:sort select="substring-before(substring-after(., 'offset:'), ';')"
                     order="descending"/>
                  
                  <xsl:sort select="substring(., 1, 3)" order="descending"/>
                  <xsl:if test="substring-after(., 'length:') => substring-before(';') != '0'">
                     <xsl:element name="local:m">
                        <xsl:attribute name="type" select="normalize-space(substring-before(., ' '))"/>
                        <xsl:attribute name="o" select="substring-after(., 'offset:')"/>
                        <xsl:attribute name="pos">e</xsl:attribute>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="map:get($starts, .)">
                  <xsl:sort select="contains(., 'continued:true;')" order="descending"/>
                  <xsl:sort select="
                        xs:int(substring-before(substring-after(., 'offset:'), ';'))
                        + xs:int(substring-before(substring-after(., 'length:'), ';'))"
                     order="descending"/>
                  
                  <xsl:sort select="substring(., 1, 3)" order="ascending"/>
                  <xsl:element name="local:m">
                     <xsl:attribute name="type" select="normalize-space(substring-before(., ' '))"/>
                     <xsl:attribute name="o" select="substring-after(., 'offset:')"/>
                     <xsl:attribute name="pos">s</xsl:attribute>
                  </xsl:element>
               </xsl:for-each>
               <!-- place end marker for void elements such as tei:gap -->
               <xsl:for-each select="map:get($ends, .)">
                  <xsl:sort select="contains(., 'continued:true;')" order="ascending"/>
                  <xsl:sort select="substring-before(substring-after(., 'change:'), ';')"
                     order="descending"/>
                  <xsl:sort select="substring-before(substring-after(., 'offset:'), ';')"
                     order="descending"/>
                  
                  <xsl:sort select="substring(., 1, 3)" order="descending"/>
                  <xsl:if test="substring-after(., 'length:') => substring-before(';') = '0'">
                     <xsl:element name="local:m">
                        <xsl:attribute name="type" select="normalize-space(substring-before(., ' '))"/>
                        <xsl:attribute name="o" select="substring-after(., 'offset:')"/>
                        <xsl:attribute name="pos">e</xsl:attribute>
                     </xsl:element>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:variable>
         <xsl:variable name="prepared">
            <xsl:for-each select="$prepped/node()">
               <xsl:choose>
                  <xsl:when test="@pos = 'e'">
                     <xsl:variable name="position" select="count(preceding-sibling::node())"/>
                     <xsl:variable name="o" select="@o"/>
                     <xsl:variable name="id" select="@type"/>
                     <xsl:variable name="precs"
                        select="preceding-sibling::local:m[@pos = 's' and preceding-sibling::local:m[@o = $o]]"/>

                     <xsl:for-each select="$precs">
                        <xsl:variable name="so" select="@o"/>
                        <xsl:variable name="myP"
                           select="count(following-sibling::local:m[@pos = 'e' and @o = $so]/preceding-sibling::node())"/>
                        <xsl:if test="
                              following-sibling::local:m[@pos = 'e' and @o = $so
                              and $myP &gt; $position] and not(@type = $id)">
                           <local:m type="{@type}" pos="e" o="{@o}"
                              prev="{$myP||'.'||$position||($myP > $position)}"/>
                        </xsl:if>
                     </xsl:for-each>
                     <xsl:sequence select="."/>
                     <xsl:for-each select="$precs">
                        <xsl:variable name="so" select="@o"/>
                        <xsl:variable name="myP"
                           select="count(following-sibling::local:m[@pos = 'e' and @o = $so]/preceding-sibling::node())"/>
                        <xsl:if test="
                              following-sibling::local:m[@pos = 'e' and @o = $so
                              and $myP &gt; $position] and not(@type = $id)">
                           <local:m type="{@type}" pos="s" o="{@o}"
                              prev="{$myP||'.'||$position||($myP > $position)}"/>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:sequence select="."/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:variable>

         <!-- TODO parameter to create <l>...</l> - #1 -->
         <!-- Create ulx, uly, w and h by getting the coordinates's points, format and sort them and take the max and min values -->
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

      <xsl:variable name="lrxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>

      <xsl:variable name="lrx">
         <xsl:choose>
            <xsl:when test="$lrxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lrxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulxb">
         <xsl:for-each select="tokenize($sortx, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>        
      </xsl:variable>
      
      <xsl:variable name="ulx">
         <xsl:choose>
            <xsl:when test="$ulxb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulxb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="lryb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = 1">
               <xsl:value-of select="." />
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="lry">
         <xsl:choose>
            <xsl:when test="$lryb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$lryb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="ulyb">
         <xsl:for-each select="tokenize($sorty, ' ')">
            <xsl:if test="position() = last()">
               <xsl:value-of select="." />
            </xsl:if>        
         </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="uly">
         <xsl:choose>
            <xsl:when test="$ulyb &lt; 0">
               <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$ulyb"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="w">
         <xsl:choose>
            <xsl:when test="($lrx - $ulx) &lt; 0">
               <xsl:value-of select="0" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="($lrx - $ulx)" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <xsl:variable name="h">
         <xsl:choose>
            <xsl:when test="($lry - $uly) &lt; 0">
               <xsl:value-of select="0" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="($lry - $uly)" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

         <xsl:text>
               </xsl:text>
         <!-- Encode iiif coords for TEI Publisher -->
         <lb facs="iiif:{replace($imgurl, 'https://iiif.saw-leipzig.de/iiif/3/', '')}/{$ulx},{$uly},{$w},{$h}">
            <xsl:if test="@custom">
               <xsl:variable name="pos"
                  select="xs:integer(substring-before(substring-after(@custom, 'index:'), ';')) + 1"/>
               <xsl:attribute name="n">
                  <xsl:text>N</xsl:text>
                  <xsl:value-of select="format-number($pos, '000')"/>
               </xsl:attribute>
            </xsl:if>
         </lb>
         <xsl:apply-templates select="$prepared/text()[not(preceding-sibling::local:m)]"/>
         <xsl:apply-templates select="
               $prepared/local:m[@pos = 's']
               [count(preceding-sibling::local:m[@pos = 's']) = count(preceding-sibling::local:m[@pos = 'e'])]"/>
         <!--[not(preceding-sibling::local:m[1][@pos='s'])]" />-->         
      </xsl:if>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Starting milestones for (possibly nested) elements</xd:desc>
   </xd:doc>
   <xsl:template match="local:m[@pos = 's']">
      <xsl:variable name="o" select="@o"/>
      <xsl:variable name="custom" as="map(*)">
         <xsl:map>
            <xsl:variable name="t" select="tokenize(@o, ';')"/>
            <xsl:if test="count($t) &gt; 1">
               <xsl:for-each select="$t[. != '']">
                  <xsl:map-entry
                     key="normalize-space(substring-before(., ':'))"
                     select="normalize-space(substring-after(., ':'))"/>
               </xsl:for-each>
            </xsl:if>
         </xsl:map>
      </xsl:variable>

      <xsl:variable name="elem">
         <local:t>
            <xsl:sequence select="
                  following-sibling::node()
                  intersect following-sibling::local:m[@o = $o]/preceding-sibling::node()"
            />
         </local:t>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="@type = 'textStyle'">
            <xsl:variable name="rend" as="xs:string*">
               <xsl:if test="$custom?italic = 'true'">
                  <xsl:text>font-style: italic;</xsl:text>
               </xsl:if>
               <xsl:if test="$custom?underlined = 'true'">
                  <xsl:text>text-decoration: underline;</xsl:text>
               </xsl:if>
               <xsl:if test="$custom?strikethrough = 'true'">
                  <xsl:text>text-decoration: line-through;</xsl:text>
               </xsl:if>
               <xsl:if test="number($custom?fontSize) gt 0">
                  <xsl:value-of select="'font-size: ' || $custom?fontSize || 'px;'"/>
               </xsl:if>
               <xsl:if test="number($custom?kerning) gt 0">
                  <xsl:value-of select="'letter-spacing: ' || $custom?fontSize || 'px;'"/>
               </xsl:if>
               <xsl:if test="$custom?fontFamily != ''">
                  <xsl:value-of select="'font-family: ' || $custom?fontFamily || ';'"/>
               </xsl:if>
               <xsl:if test="$custom?superscript = 'true'">
                  <xsl:text>vertical-align: superscript;</xsl:text>
               </xsl:if>
               <xsl:if test="$custom?smallCaps = 'true'">
                  <xsl:text>font-variant-caps: small-caps;</xsl:text>
               </xsl:if>
               <xsl:if test="$custom?letterSpaced = 'true'">
                  <xsl:text>letter-spacing: 5px;</xsl:text>
               </xsl:if>
            </xsl:variable>
            <hi>
               <xsl:if test="count($rend) gt 0">
                  <xsl:attribute name="style" select="string-join($rend, ' ')"/>
               </xsl:if>
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </hi>
         </xsl:when>
         <xsl:when test="@type = 'add'">
            <xsl:variable name="elName" select="'add'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="map:keys($custom) = 'xmlid'">
                  <xsl:attribute name="xml:id"><xsl:value-of select="map:get($custom, 'xmlid')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'place'">
                  <xsl:attribute name="place"><xsl:value-of select="map:get($custom, 'place')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'hand'">
                  <xsl:attribute name="hand"><xsl:value-of select="map:get($custom, 'hand')"/></xsl:attribute>
               </xsl:if>
                <xsl:if test="map:keys($custom) = 'type'">
                  <xsl:attribute name="type"><xsl:value-of select="map:get($custom, 'type')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>             
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'supplied'">
            <xsl:variable name="elName" select="'supplied'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="map:keys($custom) = 'resp'">
                  <xsl:attribute name="resp"><xsl:value-of select="map:get($custom, 'resp')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'reason'">
                  <xsl:attribute name="reason"><xsl:value-of select="map:get($custom, 'reason')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>            
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'unclear'">
         <xsl:variable name="elName" select="'unclear'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="map:keys($custom) = 'reason'">
                  <xsl:attribute name="reason"><xsl:value-of select="map:get($custom, 'reason')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>           
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>               
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'del'">
            <xsl:variable name="elName" select="'del'"/>
            <xsl:element name="{$elName}">
               <xsl:attribute name="rend"><xsl:value-of select="'strikethrough'"/></xsl:attribute>
               <xsl:if test="map:keys($custom) = 'cause'">
                  <xsl:attribute name="cause"><xsl:value-of select="map:get($custom, 'cause')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'hand'">
                  <xsl:attribute name="hand"><xsl:value-of select="map:get($custom, 'hand')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>                
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>               
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'Del'">
            <xsl:variable name="elName" select="'del'"/>
            <xsl:element name="{$elName}">
               <xsl:attribute name="rend"><xsl:value-of select="'strikethrough'"/></xsl:attribute>
               <xsl:if test="map:keys($custom) = 'cause'">
                  <xsl:attribute name="cause"><xsl:value-of select="map:get($custom, 'cause')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'hand'">
                  <xsl:attribute name="hand"><xsl:value-of select="map:get($custom, 'hand')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>              
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'anchor'"> 
           <xsl:variable name="elName" select="'anchor'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="map:keys($custom) = 'xmlid'">
                  <xsl:attribute name="xml:id"><xsl:value-of select="map:get($custom, 'xmlid')"/></xsl:attribute>
               </xsl:if>
                <xsl:if test="map:keys($custom) = 'type'">
                  <xsl:attribute name="type">
                     <xsl:choose>
                        <xsl:when test="contains($custom('xmlid'), 'a')"><xsl:value-of select="'add'"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="'marginalia'"/></xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
               </xsl:if>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'note'">
         <xsl:variable name="elName" select="'note'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="map:keys($custom) = 'target'">
                  <xsl:attribute name="target"><xsl:value-of select="map:get($custom, 'target')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'place'">
                  <xsl:attribute name="place"><xsl:value-of select="map:get($custom, 'place')"/></xsl:attribute>
               </xsl:if>
                  <xsl:attribute name="type"><xsl:value-of select="'marginalia'"/></xsl:attribute>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>           
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>               
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'missing'">
            <xsl:choose>
               <xsl:when test="$custom?reason = 'intentional'">
                  <ellipsis><metamark/></ellipsis>
               </xsl:when>
               <xsl:otherwise>
               <xsl:variable name="elName" select="'gap'"/>
               <xsl:element name="{$elName}">
                  <xsl:if test="map:keys($custom) = 'reason'">
                     <xsl:attribute name="reason"><xsl:value-of select="map:get($custom, 'reason')"/></xsl:attribute>
                  </xsl:if>              
               </xsl:element>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
          <xsl:when test="@type = 'rdg'">
            <xsl:variable name="elName" select="'rdg'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="map:keys($custom) = 'n'">
                  <xsl:attribute name="n"><xsl:value-of select="map:get($custom, 'n')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'hand'">
                  <xsl:attribute name="hand"><xsl:value-of select="map:get($custom, 'hand')"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="map:keys($custom) = 'change'"> <!-- @varSeq is deprecated and replaced by @change -->
                  <xsl:attribute name="change"><xsl:value-of select="concat('#version', map:get($custom, 'change'))"/></xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                     <xsl:attribute name="continued" select="true()"/>
               </xsl:if>             
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'sic'">
            <choice>
               <corr>
                  <xsl:value-of select="replace(map:get($custom, 'correction'), '\\u0020', ' ')"/>
               </corr>
               <sic>
                  <xsl:call-template name="elem">
                     <xsl:with-param name="elem" select="$elem"/>
                  </xsl:call-template>
               </sic>
            </choice>
         </xsl:when>
         <xsl:when test="@type = 'date'">
            <date>
               <!--<xsl:variable name="year" select="if(map:keys($custom) = 'year') then format-number(xs:integer(map:get($custom, 'year')), '0000') else '00'"/>
          <xsl:variable name="month" select=" if(map:keys($custom) = 'month') then format-number(xs:integer(map:get($custom, 'month')), '00') else '00'"/>
          <xsl:variable name="day" select=" if(map:keys($custom) = 'day') then format-number(xs:integer(map:get($custom, 'day')), '00') else '00'"/>
          <xsl:variable name="when" select="$year||'-'||$month||'-'||$day" />
          <xsl:if test="$when != '0000-00-00'">
            <xsl:attribute name="when" select="$when" />
          </xsl:if>-->
               <xsl:for-each select="map:keys($custom)">
                  <xsl:if test=". != 'length' and . != ''">
                     <xsl:attribute name="{.}" select="map:get($custom, .)"/>
                  </xsl:if>
               </xsl:for-each>
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </date>
         </xsl:when>
         <xsl:when test="@type = 'person'">
            <xsl:variable name="elName" select="
                  if ($rs) then
                     'rs'
                  else
                     'persName'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="$rs">
                  <xsl:attribute name="type">person</xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom('lastname') != '' or $custom('firstname') != ''">
                  <xsl:attribute name="key"
                     select="replace($custom('lastname'), '\\u0020', ' ') || ', ' || replace($custom('firstname'), '\\u0020', ' ')"
                  />
               </xsl:if>
               <xsl:if test="$custom('continued')">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>
               <xsl:if test="$unknownAttributes">
                  <xsl:for-each select="map:keys($custom)">
                     <xsl:if test="not(. = ('', 'length', 'lastname', 'firstname'))">
                        <xsl:attribute name="{.}" select="$custom(.)"/>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:if>
               
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'place'">
            <xsl:variable name="elName" select="
                  if ($rs) then
                     'rs'
                  else
                     'placeName'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="$rs">
                  <xsl:attribute name="type">place</xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom('placeName') != ''">
                  <xsl:attribute name="key" select="replace($custom('placeName'), '\\u0020', ' ')"/>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>

               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:when test="@type = 'organization'">
            <xsl:variable name="elName" select="
                  if ($rs) then
                     'rs'
                  else
                     'orgName'"/>
            <xsl:element name="{$elName}">
               <xsl:if test="$rs">
                  <xsl:attribute name="type">org</xsl:attribute>
               </xsl:if>
               <xsl:if test="$custom?continued">
                  <xsl:attribute name="continued" select="true()"/>
               </xsl:if>
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="{@type}">
               <xsl:for-each select="map:keys($custom)">
                  <xsl:if test="not(. = ('', 'length'))">
                     <xsl:attribute name="{.}" select="$custom(.)"/>
                  </xsl:if>
               </xsl:for-each>
               <xsl:call-template name="elem">
                  <xsl:with-param name="elem" select="$elem"/>
               </xsl:call-template>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates
         select="following-sibling::local:m[@pos = 'e' and @o = $o]/following-sibling::node()[1][self::text()]"
      />
   </xsl:template>

   <xd:doc>
      <xd:desc>Process what's between a pair of local:m</xd:desc>
      <xd:param name="elem"/>
   </xd:doc>
   <xsl:template name="elem">
      <xsl:param name="elem"/>

      <xsl:choose>
         <xsl:when test="$elem//local:m">
            <xsl:apply-templates select="$elem/local:t/text()[not(preceding-sibling::local:m)]"/>
            <xsl:apply-templates select="
                  $elem/local:t/local:m[@pos = 's']
                  [not(preceding-sibling::local:m[1][@pos = 's'])]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="$elem/local:t/node()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xd:doc>
      <xd:desc>Leave out possibly unwanted parts</xd:desc>
   </xd:doc>
   <xsl:template match="p:Metadata" mode="text"/>

   <!-- Der Übersichtlichkeit halber wird folgender Code weggelassen -->
   <!--
   <xd:doc>
      <xd:desc>TranskribusMetadata contains the link to the image on Transkribus’ servers; return a
         tei:graphic element with this URL so it can be evaluated during postprocessing</xd:desc>
   </xd:doc>
   <xsl:template match="*:TranskribusMetadata">
      <xsl:text>
         </xsl:text>
      <graphic url="{@imgUrl}" width="{following::p:Page/@imageWidth}px"
         height="{following::p:Page/@imageHeight}px"/>
   </xsl:template>
   -->

   <xd:doc>
      <xd:desc>Parse the content of an attribute such as @custom into a map.</xd:desc>
   </xd:doc>
   <xsl:template match="@custom" as="map(*)">
      <xsl:map>
         <xsl:for-each select="tokenize(., '\}')[normalize-space() != '']">
            <xsl:map-entry key="substring-before(normalize-space(), ' ')">
               <xsl:map>
                  <xsl:for-each
                     select="tokenize(substring-after(., '{'), ';')[normalize-space() != '']">
                     <xsl:map-entry key="substring-before(., ':')" select="substring-after(., ':')"
                     />
                  </xsl:for-each>
               </xsl:map>
            </xsl:map-entry>
         </xsl:for-each>
      </xsl:map>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Text nodes to be copied without the hyphens that are taken care of in a span-tag; regex for getting word with hyphen and new line: (\S*[¬](\r\n|\r|\n)*)(\S*[a-zA-Z¬]+)</xd:desc>
   </xd:doc>
   <xsl:template match="text()">
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
</xsl:stylesheet>