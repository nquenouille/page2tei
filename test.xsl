<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- Eingabe- und Ausgabe-Dokument -->
  <xsl:output method="xml" indent="yes"/>

  <!-- Template, das auf TextLine-Elemente angewendet wird -->
  <xsl:template match="TextLine">
    <xsl:copy>
      <!-- Kopiere alle Attribute des Elements -->
      <xsl:copy-of select="@*"/>
      
      <!-- Bearbeite das custom-Attribut, wenn es ein "offset" enthält -->
      <xsl:attribute name="custom">
        <xsl:value-of select="concat(
          substring-before(@custom, 'offset:'),
          'offset:', 
          string(number(substring-before(substring-after(@custom, 'offset:'), ';')) - 1),
          substring-after(@custom, substring-after(@custom, ';'))
        )"/>
      </xsl:attribute>
      
      <!-- Kopiere den Inhalt des TextLine-Elements -->
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Template für den Root-Knoten -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>