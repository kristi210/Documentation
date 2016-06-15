<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="#all" version="2.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b>July 2, 2014</xd:p>
      <xd:p><xd:b>Author:</xd:b> Dot Porter</xd:p>
      <xd:p><xd:b>Modified on:</xd:b>May 5, 2015</xd:p>
      <xd:p><xd:b>Modified by:</xd:b> Dot Porter</xd:p>
      <xd:p>This document takes as its input the output from process5.xsl. It pulls image file
        URLs from an external XML file (in tei:facsimile format and named
        @idno-imageList.xml) up into <left/> and <right/>. </xd:p>
    </xd:desc>
  </xd:doc>
  
  
  <xsl:variable name="idno" select="t:msIdentifier/t:idno"/>
  
  <xsl:template name="step3">
    <xsl:param name="step3ed" tunnel="yes"/>
      
      <xsl:for-each select="t:quire">
        <quire>
          <xsl:attribute name="n">
            <xsl:value-of select="@n"/>
          </xsl:attribute>
          <xsl:attribute name="positions">
            <xsl:value-of select="@positions"/>
          </xsl:attribute>
          <units>
            <xsl:apply-templates select="t:units"/>
          </units>
        </quire>
      </xsl:for-each>
    
  </xsl:template>
  
  <xsl:template match="t:units">
    <xsl:for-each select="t:unit">
      <unit>
        <xsl:attribute name="n" select="@n"/>
        <inside>
          <xsl:apply-templates select="t:inside"/>
        </inside>
        <outside>
          <xsl:apply-templates select="t:outside"/>
        </outside>
      </unit>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="t:inside">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="t:outside">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="//t:left">
    <left>
      <xsl:if test="@mode">
        <xsl:attribute name="mode">
          <xsl:value-of select="@mode"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@folNo">
        <xsl:attribute name="folNo">
          <xsl:value-of select="@folNo"/>
        </xsl:attribute>
      </xsl:if>
      
      <xsl:variable name="the_folNo">
        <xsl:value-of select="@folNo"/>
      </xsl:variable>
      <xsl:if test="document(concat('../',$idno,'-imageList.xml'))//t:surface/@n=$the_folNo"> 
        <xsl:attribute name="url">
          <xsl:value-of
            select="document(concat('../',$idno,'-imageList.xml'))//t:surface[@n=$the_folNo]/t:graphic/@url"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@mode='missing'">
        <xsl:attribute name="url">https://raw.githubusercontent.com/leoba/VisColl/master/data/support/images/x.jpg</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="pos">
        <xsl:value-of select="@pos"/>
      </xsl:attribute>
    </left>
  </xsl:template>
  
  <xsl:template match="//t:right">
    <right>
      <xsl:if test="@mode">
        <xsl:attribute name="mode">
          <xsl:value-of select="@mode"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@folNo">
        <xsl:attribute name="folNo">
          <xsl:value-of select="@folNo"/>
        </xsl:attribute>
      </xsl:if>
      
      
      <xsl:variable name="the_folNo">
        <xsl:value-of select="@folNo"/>
      </xsl:variable>
      <xsl:if test="document(concat('../',$idno,'-imageList.xml'))//t:surface/@n=$the_folNo"> 
        <xsl:attribute name="url">
          
          <xsl:value-of
            select="document(concat('../',$idno,'-imageList.xml'))//t:surface[@n=$the_folNo]/t:graphic/@url"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@mode='missing'">
        <xsl:attribute name="url">https://raw.githubusercontent.com/leoba/VisColl/master/data/support/images/x.jpg</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="pos">
        <xsl:value-of select="@pos"/>
      </xsl:attribute>
    </right>
  </xsl:template>
  
  
  
</xsl:stylesheet>