<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   xmlns="http://www.tei-c.org/ns/1.0"
   exclude-result-prefixes="#all"
   version="3.0">
   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p><xd:b>Created on:</xd:b> Jan 11, 2023</xd:p>
         <xd:p><xd:b>Author:</xd:b> Dario Kampkaspar (dario.kampkaspar@tu-darmstadt.de)</xd:p>
         <xd:p></xd:p>
      </xd:desc>
   </xd:doc>
   
   <xsl:variable name="hyphens" select="('=', '-', '¬', '⸗', '⌜', '⌝')" />
   <xsl:variable name="quotationMarks" select="('„', '“', '”', '‚', '‘', '’', '»', '«', '›', '‹')" />
   <xsl:variable name="romanNumeralCharacters"
      select="'[ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫⅬⅭⅮⅯⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⅺⅻⅼⅽⅾⅿↀↁↂↅↆↇↈ]+'" />
   <xsl:variable name="numberCharacters" select="'\d+|[Ⅰ-ↈ]+'" />
   <xsl:variable name="punctuationCharacters"
      select="'[' || $hyphens => string-join() => replace('\-', '\\-') || string-join($quotationMarks) || '\.,;:–—\?!\[\]\(\)\*/〈〉¿…]'"/>

   <xsl:function name="tei:is-unicode-roman-numeral" as="xs:boolean">
      <xsl:param name="token" as="xs:string" />
      <xsl:sequence select="matches($token, '^' || $romanNumeralCharacters || '$')" />
   </xsl:function>

   <xsl:function name="tei:roman-numeral-value" as="xs:integer">
      <xsl:param name="token" as="xs:string" />
      <xsl:sequence
         select="sum(for $character in string-to-codepoints($token)
            return tei:roman-numeral-character-value(codepoints-to-string($character)))" />
   </xsl:function>

   <xsl:function name="tei:roman-numeral-character-value" as="xs:integer">
      <xsl:param name="character" as="xs:string" />
      <xsl:choose>
         <xsl:when test="$character = ('Ⅰ', 'ⅰ')">
            <xsl:sequence select="1" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅱ', 'ⅱ')">
            <xsl:sequence select="2" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅲ', 'ⅲ')">
            <xsl:sequence select="3" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅳ', 'ⅳ')">
            <xsl:sequence select="4" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅴ', 'ⅴ')">
            <xsl:sequence select="5" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅵ', 'ⅵ', 'ↅ')">
            <xsl:sequence select="6" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅶ', 'ⅶ')">
            <xsl:sequence select="7" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅷ', 'ⅷ')">
            <xsl:sequence select="8" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅸ', 'ⅸ')">
            <xsl:sequence select="9" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅹ', 'ⅹ')">
            <xsl:sequence select="10" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅺ', 'ⅺ')">
            <xsl:sequence select="11" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅻ', 'ⅻ')">
            <xsl:sequence select="12" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅼ', 'ⅼ', 'ↆ')">
            <xsl:sequence select="50" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅽ', 'ⅽ')">
            <xsl:sequence select="100" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅾ', 'ⅾ')">
            <xsl:sequence select="500" />
         </xsl:when>
         <xsl:when test="$character = ('Ⅿ', 'ⅿ', 'ↀ')">
            <xsl:sequence select="1000" />
         </xsl:when>
         <xsl:when test="$character = 'ↁ'">
            <xsl:sequence select="5000" />
         </xsl:when>
         <xsl:when test="$character = 'ↂ'">
            <xsl:sequence select="10000" />
         </xsl:when>
         <xsl:when test="$character = 'ↇ'">
            <xsl:sequence select="50000" />
         </xsl:when>
         <xsl:when test="$character = 'ↈ'">
            <xsl:sequence select="100000" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="0" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>

   <xsl:function name="tei:is-uppercase-word" as="xs:boolean">
      <xsl:param name="token" as="element()" />
      <xsl:sequence select="matches(string-join($token//text(), ''), '^\p{Lu}+$')" />
   </xsl:function>
   
   <xd:doc>
      <xd:desc>Tokenize elements within a div if they contain text</xd:desc>
   </xd:doc>
   <xsl:template match="*" mode="tokenize">
      <xsl:copy>
         <xsl:sequence select="@*" />
         <xsl:variable name="content">
            <xsl:apply-templates mode="doTokenize" />
         </xsl:variable>
         
         <xsl:apply-templates select="$content" mode="combine-tokens"/>
      </xsl:copy>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Basic white space tokenisation: it’s a word if it’s not a pc or a num</xd:desc>
   </xd:doc>
   <xsl:template match="text()[normalize-space() != '']" mode="doTokenize" priority="2">
      <xsl:analyze-string select="." regex="\s+">
         <xsl:matching-substring>
            <xsl:sequence select="." />
         </xsl:matching-substring>
         <xsl:non-matching-substring>
            <xsl:analyze-string select="." regex="{$punctuationCharacters}">
               <xsl:matching-substring>
                  <pc><xsl:sequence select="." /></pc>
               </xsl:matching-substring>
               <xsl:non-matching-substring>
                  <xsl:analyze-string select="." regex="{$numberCharacters}">
                     <xsl:matching-substring>
                        <num>
                           <xsl:if test="tei:is-unicode-roman-numeral(.)">
                              <xsl:attribute name="value" select="tei:roman-numeral-value(.)" />
                           </xsl:if>
                           <xsl:sequence select="." />
                        </num>
                     </xsl:matching-substring>
                     <xsl:non-matching-substring>
                        <w><xsl:sequence select="." /></w>
                     </xsl:non-matching-substring>
                  </xsl:analyze-string>
               </xsl:non-matching-substring>
            </xsl:analyze-string>
         </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:template>
   <xd:doc>
      <xd:desc>Exception: content of tei:ref, it is a URL</xd:desc>
   </xd:doc>
   <xsl:template match="tei:ref/text()[starts-with(normalize-space(), 'http')]" mode="doTokenize" priority="3">
      <w>
         <xsl:value-of select="."/>
      </w>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>evaluate tei:w and its surroundings to see whether there is hyphenation</xd:desc>
   </xd:doc>
   <xsl:template match="tei:w" mode="combine-tokens" priority="2">
      <!-- collect the nodes between this and the preceding word; will be used later to “restore” the content between
         words as the calling template only evaluates tei:w. -->
      <xsl:variable name="previous-token"
         select="../*[self::tei:w or self::tei:num][. &lt;&lt; current()][last()]" />
      <xsl:variable name="previous-non-inline"
         select="preceding-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1]" />
      <xsl:variable name="head-inline-parts"
         select="../node()[self::tei:supplied or self::tei:unclear]
            [. &lt;&lt; current()
             and (if ($previous-non-inline) then . >> $previous-non-inline else true())]" />
      <xsl:variable name="preceding">
         <xsl:choose>
            <xsl:when test="$previous-token">
               <xsl:variable name="first-after-previous-token"
                  select="$previous-token/following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1]" />
               <xsl:apply-templates
                  select="(preceding-sibling::node()[. is $first-after-previous-token or . >> $first-after-previous-token])
                     except $head-inline-parts"
                  mode="combine-tokens-hi" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates select="preceding-sibling::node() except $head-inline-parts" mode="combine-tokens-hi" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="next-delimiter"
         select="following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1]" />
      <xsl:variable name="tail-inline-parts"
         select="following-sibling::*[self::tei:supplied or self::tei:unclear]
            [if ($next-delimiter) then . &lt;&lt; $next-delimiter else true()]" />
      <xsl:variable name="next-word" select="following-sibling::tei:w[1]" />
      <xsl:variable name="between-this-and-next-word"
         select="$next-word/preceding-sibling::*[if (exists($tail-inline-parts))
            then . >> $tail-inline-parts[last()]
            else . >> current()]" />
      <xsl:variable name="following-after-tail"
         select="following-sibling::node()[if (exists($tail-inline-parts))
            then . >> $tail-inline-parts[last()]
            else true()]" />
      <xsl:variable name="next-line-lb" select="$between-this-and-next-word[self::tei:lb][1]" />
      <xsl:variable name="current-line-start-lb" select="preceding-sibling::tei:lb[1]" />
      <xsl:variable name="next-line-end-lb" select="$next-line-lb/following-sibling::tei:lb[1]" />
      <xsl:variable name="current-line-words"
         select="if ($current-line-start-lb)
            then $current-line-start-lb/following-sibling::tei:w[. &lt;&lt; $next-line-lb]
            else preceding-sibling::tei:w[. &lt;&lt; $next-line-lb] | ." />
      <xsl:variable name="next-line-words"
         select="if ($next-line-end-lb)
            then $next-line-lb/following-sibling::tei:w[. &lt;&lt; $next-line-end-lb]
            else $next-line-lb/following-sibling::tei:w" />
      <xsl:variable name="all-uppercase-hyphenation"
         select="exists($next-line-lb)
            and $next-word[tei:is-uppercase-word(.)]
            and (every $token in $current-line-words satisfies tei:is-uppercase-word($token))
            and (every $token in $next-line-words satisfies tei:is-uppercase-word($token))" />
      
      <xsl:choose>
         <!-- Hyphenation: exactly one hyphen follows immediately, and after the breaks, there is a hi followed immediately by tei:w which starts with a
            lower case letter; to avoid errors with a German speciality, this word must not be “und” or “oder” -->
         <xsl:when test="$next-delimiter = $hyphens
               and $next-delimiter/following-sibling::*[1][local-name() = ('pb', 'cb', 'lb')]
               and $next-word[matches(., '^[a-zäöüßſ]') and . != 'und' and . != 'oder']
               and $next-word/preceding-sibling::node()[1][self::tei:hi]">
            <xsl:sequence select="$preceding" />
            <xsl:if test="preceding-sibling::node()[1][self::text()]">
               <xsl:text>
               </xsl:text>
            </xsl:if>
            <w>
               <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
               <xsl:sequence select="node()" />
               <xsl:apply-templates select="$tail-inline-parts" mode="word-part-content" />
               <xsl:apply-templates
                  select="$between-this-and-next-word except $next-word/preceding-sibling::tei:hi[1]"
                  mode="break" />
               <hi>
                  <xsl:sequence select="$next-word/preceding-sibling::tei:hi[1]/@*" />
                  <xsl:apply-templates select="$next-word/preceding-sibling::tei:hi[1]/node()" mode="word-part-content" />
               </hi>
               <xsl:sequence select="$next-word/node()" />
            </w>
         </xsl:when>
         <!-- Hyphenation: exactly one hyphen follows immediately, and after the breaks, the next tei:w starts with a
            lower case letter; to avoid errors with a German speciality, this word must not be “und” or “oder” -->
         <xsl:when test="$next-delimiter = $hyphens
               and $next-delimiter/following-sibling::*[1][local-name() = ('pb', 'cb', 'lb')]
               and $next-word[matches(., '^[a-zäöüßſ]') and . != 'und' and . != 'oder']">
            <xsl:sequence select="$preceding" />
            <xsl:if test="preceding-sibling::node()[1][self::text()]">
               <xsl:text>
               </xsl:text>
            </xsl:if>
            <w>
               <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
               <xsl:sequence select="node()" />
               <xsl:apply-templates select="$tail-inline-parts" mode="word-part-content" />
               <xsl:apply-templates select="$between-this-and-next-word" mode="break" />
               <xsl:sequence select="$next-word/node()" />
            </w>
         </xsl:when>
         <!-- Hyphenation in all-uppercase lines: conservative mode, only merge when both involved lines contain
            uppercase-only words. -->
         <xsl:when test="$next-delimiter = $hyphens
               and $next-delimiter/following-sibling::*[1][local-name() = ('pb', 'cb', 'lb')]
               and $all-uppercase-hyphenation">
            <xsl:sequence select="$preceding" />
            <xsl:if test="preceding-sibling::node()[1][self::text()]">
               <xsl:text>
               </xsl:text>
            </xsl:if>
            <w>
               <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
               <xsl:sequence select="node()" />
               <xsl:apply-templates select="$tail-inline-parts" mode="word-part-content" />
               <xsl:apply-templates select="$between-this-and-next-word" mode="break" />
               <xsl:sequence select="$next-word/node()" />
            </w>
         </xsl:when>
         <!-- after the breaks, the next tei:w starts with an upper case letter. This is not hyphenation but a long word
            with hyphens (e.g. German “Durchkoppelung”). We handle this separately so we can add some formatting. -->
         <xsl:when test="$next-delimiter = $hyphens
               and $next-delimiter/following-sibling::*[1][local-name() = ('pb', 'cb', 'lb')]
               and $next-word[matches(., '^[A-ZÄÖÜ]')]">
            <xsl:sequence select="$preceding" />
            <xsl:if test="preceding-sibling::node()[1][self::text()]">
               <xsl:text>
               </xsl:text>
            </xsl:if>
            <w>
               <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
               <xsl:sequence select="node()" />
               <xsl:apply-templates select="$tail-inline-parts" mode="word-part-content" />
            </w>
            <xsl:sequence select="$between-this-and-next-word" />
            <xsl:sequence select="$next-word" />
         </xsl:when>
         <!-- after the breaks, the next tei:w is „und“ or „oder“ -->
         <xsl:when test="$next-delimiter = $hyphens
               and $next-delimiter/following-sibling::*[1][local-name() = ('pb', 'cb', 'lb')]
               and $next-word = ('und', 'oder')">
            <xsl:sequence select="$preceding" />
            <w>
               <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
               <xsl:sequence select="node()" />
               <xsl:apply-templates select="$tail-inline-parts" mode="word-part-content" />
            </w>
            <xsl:sequence select="$next-delimiter" />
            <xsl:text>
               </xsl:text>
            <xsl:sequence select="$between-this-and-next-word[. >> $next-delimiter]" />
            <xsl:sequence select="$next-word" />
         </xsl:when>
         <!-- second part of a hyphenated word. If this is the last word in its parent, restore the following nodes, if
            any (so as to not lose punctuation) -->
         <xsl:when test="$previous-non-inline[self::tei:lb]
               and preceding-sibling::tei:w[1]/following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1] = $hyphens
               and count(preceding-sibling::tei:pc intersect preceding-sibling::tei:w[1]/following-sibling::*) = 1">
            <xsl:if test="not(following-sibling::tei:w or following-sibling::tei:num)">
               <xsl:sequence select="following-sibling::node()" />
            </xsl:if>
         </xsl:when>
         <!-- second part of a hyphenated word with a highlight within the word. If this is the last word in its parent, restore the following nodes, if
            any (so as to not lose punctuation) -->
         <xsl:when test="preceding-sibling::node()[1][self::tei:hi]
               and preceding-sibling::node()[2][self::tei:lb]
               and preceding-sibling::tei:w[1]/following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1] = $hyphens
               and count(preceding-sibling::tei:pc intersect preceding-sibling::tei:w[1]/following-sibling::*) = 1">
            <xsl:if test="not(following-sibling::tei:w or following-sibling::tei:num)">
               <xsl:sequence select="following-sibling::node()" />
            </xsl:if>
         </xsl:when>
         <!-- second part of a hyphenated word with a sign of a continued quote. If this is the last word in its parent, restore the following nodes, if
            any (so as to not lose punctuation) -->
         <xsl:when test="preceding-sibling::*[1][self::tei:pc[. = '„']]
               and preceding-sibling::*[2][self::tei:lb]
               and preceding-sibling::tei:w[1]/following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1] = $hyphens
               and count(preceding-sibling::tei:pc intersect preceding-sibling::tei:w[1]/following-sibling::*) = 2">
            <xsl:if test="not(following-sibling::tei:w or following-sibling::tei:num)">
               <xsl:sequence select="following-sibling::node()" />
            </xsl:if>
         </xsl:when>
         <!-- second part of a hyphenated word after a page/column break where the new page repeats the continuation sign -->
         <xsl:when test="preceding-sibling::*[1][self::tei:pc[. = $hyphens]]
               and preceding-sibling::*[2][self::tei:lb]
               and preceding-sibling::*[3][self::tei:pb or self::tei:cb]
               and preceding-sibling::tei:w[1]/following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1] = $hyphens
               and count(preceding-sibling::tei:pc intersect preceding-sibling::tei:w[1]/following-sibling::*) = 2">
            <xsl:if test="not(following-sibling::tei:w or following-sibling::tei:num)">
               <xsl:sequence select="following-sibling::node()" />
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="$preceding" />
            <w>
               <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
               <xsl:sequence select="node()" />
               <xsl:apply-templates select="$tail-inline-parts" mode="word-part-content" />
            </w>
            <xsl:if test="not(following-sibling::tei:w or following-sibling::tei:num)">
               <xsl:apply-templates select="$following-after-tail" mode="combine-tokens-hi" />
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:num" mode="combine-tokens" priority="2">
      <xsl:variable name="previous-token"
         select="../*[self::tei:w or self::tei:num][. &lt;&lt; current()][last()]" />
      <xsl:variable name="previous-non-inline"
         select="preceding-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1]" />
      <xsl:variable name="head-inline-parts"
         select="../node()[self::tei:supplied or self::tei:unclear]
            [. &lt;&lt; current()
             and (if ($previous-non-inline) then . >> $previous-non-inline else true())]" />
      <xsl:variable name="preceding">
         <xsl:choose>
            <xsl:when test="$previous-token">
               <xsl:variable name="first-after-previous-token"
                  select="$previous-token/following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1]" />
               <xsl:apply-templates
                  select="(preceding-sibling::node()[. is $first-after-previous-token or . >> $first-after-previous-token])
                     except $head-inline-parts"
                  mode="combine-tokens-hi" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates select="preceding-sibling::node() except $head-inline-parts" mode="combine-tokens-hi" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:sequence select="$preceding" />
      <num>
         <xsl:sequence select="@*" />
         <xsl:apply-templates select="$head-inline-parts" mode="word-part-content" />
         <xsl:sequence select="node()" />
      </num>
      <xsl:if test="not(following-sibling::tei:w or following-sibling::tei:num)">
         <xsl:apply-templates select="following-sibling::node()" mode="combine-tokens-hi" />
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:supplied | tei:unclear" mode="combine-tokens" priority="2.5">
      <xsl:choose>
         <xsl:when test="preceding-sibling::node()[1][self::tei:supplied or self::tei:unclear]" />
         <xsl:when test="preceding-sibling::node()[1][self::text()[normalize-space() = '']]
               and preceding-sibling::tei:w[1]
               and empty(following-sibling::node()[not(self::tei:supplied or self::tei:unclear)])" />
         <xsl:when test="preceding-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1][self::tei:w or self::tei:num]" />
         <xsl:when test="following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1][self::tei:w or self::tei:num]" />
         <xsl:when test="count(descendant::*[self::tei:w or self::tei:num]) = 1
               and empty(descendant::*[self::tei:w or self::tei:num][1]/preceding-sibling::node())
               and empty(descendant::*[self::tei:w or self::tei:num][1]/following-sibling::node())">
            <xsl:element name="{local-name(descendant::*[self::tei:w or self::tei:num][1])}" namespace="http://www.tei-c.org/ns/1.0">
               <xsl:sequence select="descendant::*[self::tei:w or self::tei:num][1]/@*" />
               <xsl:apply-templates select="." mode="word-part-content" />
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:next-match />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   <xsl:template match="tei:hi" mode="combine-tokens-hi">
      <xsl:sequence select="tei:lb/preceding-sibling::node()[1][self::text()]" />
      <hi>
         <xsl:sequence select="@*" />
         <xsl:apply-templates mode="combine-tokens" />
      </hi>
   </xsl:template>

   <xsl:template match="tei:supplied | tei:unclear" mode="combine-tokens-hi" priority="2">
      <xsl:variable name="next-non-inline"
         select="following-sibling::node()[not(self::tei:supplied or self::tei:unclear)][1]" />
      <xsl:variable name="inline-run"
         select=".,
            following-sibling::*[self::tei:supplied or self::tei:unclear]
               [if ($next-non-inline) then . &lt;&lt; $next-non-inline else true()]" />
      <xsl:choose>
         <xsl:when test="preceding-sibling::node()[1][self::tei:supplied or self::tei:unclear]" />
         <xsl:when test="exists($inline-run/descendant::tei:num) and empty($inline-run/descendant::tei:w)">
            <num>
               <xsl:apply-templates select="$inline-run" mode="word-part-content" />
            </num>
         </xsl:when>
         <xsl:otherwise>
            <w>
               <xsl:apply-templates select="$inline-run" mode="word-part-content" />
            </w>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:supplied | tei:unclear" mode="word-part-content">
      <xsl:copy>
         <xsl:sequence select="@*" />
         <xsl:apply-templates select="node()" mode="word-part-content" />
      </xsl:copy>
   </xsl:template>

   <xsl:template match="tei:w" mode="word-part-content">
      <xsl:sequence select="node()" />
   </xsl:template>

   <xsl:template match="tei:num" mode="word-part-content">
      <xsl:sequence select="node()" />
   </xsl:template>

   <xsl:template match="text()" mode="word-part-content">
      <xsl:sequence select="." />
   </xsl:template>
   
   <xd:doc>
      <xd:desc>If a node has a sibling tei:w, it is handled by the previous template</xd:desc>
   </xd:doc>
   <xsl:template match="node()[../tei:w or ../tei:num]" mode="combine-tokens" />
   
   <xd:doc>
      <xd:desc>add @break="no" to lb if there was hyphenation</xd:desc>
   </xd:doc>
   <xsl:template match="tei:lb" mode="break">
      <lb>
         <xsl:sequence select="@*" />
         <xsl:attribute name="break">no</xsl:attribute>
      </lb>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>add @break="no" to lb if there was hyphenation</xd:desc>
   </xd:doc>
   <xsl:template match="tei:cb" mode="break">
      <cb>
         <xsl:sequence select="@*" />
         <xsl:attribute name="break">no</xsl:attribute>
      </cb>
   </xsl:template>

   <xsl:template match="tei:supplied | tei:unclear" mode="break">
      <xsl:copy>
         <xsl:sequence select="@*" />
         <xsl:apply-templates select="node()" mode="word-part-content" />
      </xsl:copy>
   </xsl:template>
   
   <xd:doc>
      <xd:desc>Default</xd:desc>
   </xd:doc>
   <xsl:template match="@* | node()" mode="doTokenize combine-tokens combine-tokens-hi break">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()" mode="#current" />
      </xsl:copy>
   </xsl:template>
</xsl:stylesheet>
