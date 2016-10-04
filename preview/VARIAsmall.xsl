<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"  
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="t:support">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="t:provenance">
       
            <b>Provenance:</b>
             <p><xsl:apply-templates/></p>
       
    </xsl:template>
    
    <xsl:template match="t:additional">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="t:adminInfo">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="t:recordHist">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="t:source">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    
    <xsl:template match="t:note">
        <xsl:choose>
            <xsl:when test="t:p"><xsl:apply-templates/></xsl:when>
       <xsl:otherwise><p> <xsl:apply-templates/></p></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="t:handDesc">
        <h2>Hands</h2>
        <div><xsl:apply-templates/></div>
    </xsl:template>
    
    
    <xsl:template match="t:msContent">
        <div id="contents">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="t:filiation">
        <p>
            <b>Filiation: </b>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="t:incipit">
        <p>    <b>Incipit <xsl:value-of select="@xml:lang"/>: </b>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="t:explicit">
        <p>
            <b>Explicit <xsl:value-of select="@xml:lang"/>: </b>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="t:rubric">
        <p>
            <b>Rubric <xsl:value-of select="@xml:lang"/>: </b>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="t:idno[parent::t:msIdentifier]" mode="title">
        <h1>
            <xsl:value-of select="."/>
        </h1>
    </xsl:template>
    
    <xsl:template match="t:collection" mode="title">
        <b>Collection: <xsl:value-of select="."/></b>
    </xsl:template>
    
    <xsl:template match="t:altIdentifier" mode="title">
        <p>Other identifiers: <xsl:for-each select="t:idno">
            <xsl:sort/>
            <xsl:value-of select="concat(., ' ')"/>
        </xsl:for-each></p>
    </xsl:template>
    
    <xsl:template match="t:history">
        <h2>Origin <xsl:if test="./ancestor::t:msPart"><xsl:variable name="currentMsPart">
            <a href="{./ancestor::t:msPart/@xml:id}"><xsl:value-of
                select="./ancestor::t:msPart/@xml:id"/></a></xsl:variable> of
            <xsl:value-of select="$currentMsPart"/></xsl:if></h2>
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="t:watermark">
        <h3>watermark</h3>
        <p>
            <xsl:choose>
                <xsl:when test=". != ''">Yes</xsl:when>
                <xsl:otherwise>No</xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    
    
    <xsl:template match="t:custEvent/@restoration">
        <p><xsl:value-of select="//t:custEvent/@restorations"/> restorations :<xsl:value-of
            select="//t:custEvent/@subtype"/></p>
    </xsl:template>
    
    <xsl:template match="t:measure[. != '']">
        <xsl:value-of select="."/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@unit"/>
        <xsl:if test="@type">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="@type"/>
        </xsl:if>
        <xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="t:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'apices'">
                <sup>
                    <xsl:value-of select="."/>
                </sup>
            </xsl:when>
            <xsl:when test="@rend = 'underline'">
                <u>
                    <xsl:value-of select="."/>
                </u>
            </xsl:when>
            <xsl:when test="@rend = 'rubric'">
                <span class="rubric">
                    <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:ab[not(ancestor::t:body)] | t:seg[@type='script'] | t:desc[parent::t:handNote] | t:seg[@type='rubrication']">
        <p>
            <xsl:if test="@type">
                <b>
                    <xsl:value-of select="@type"/>
                </b>
                <xsl:text>: </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
        
    </xsl:template>
    
    <xsl:template match="t:textLang">
        <xsl:variable name="curlang" select="@mainLang"/>
        <p>
            <b>Language of text: </b>
            <xsl:value-of select="//t:language[@ident = $curlang]"/>
        </p>
    </xsl:template>
    <xsl:template match="t:text">
        <h2>Transcription</h2>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:body">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:div[parent::t:body]">
        <div class="row-fluid" id="{@type}">
            <head>
                <a href="{@corresp}">
                    <xsl:value-of select="replace(substring-after(@corresp, '#'), '_', ' ')"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="@subtype"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="@n"/>
                </a>
            </head>
            <br/>
            <xsl:apply-templates/>
        </div>
        <br/>
    </xsl:template>
    <xsl:template match="t:div[parent::t:div[@type='textpart']]">
        <a href="{if (@corresp) then @corresp else '#mscontent'}">
            <xsl:value-of select="@subtype"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@n"/>
        </a>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:ab">
        <div class="container-fluid">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="t:l">
        <sup>
            <xsl:value-of select="@n"/>
        </sup>
        <xsl:value-of select="."/>
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <!--lb-->
    <xsl:template match="t:lb[parent::t:ab]">
        <xsl:text> | </xsl:text>
    </xsl:template>
    <xsl:template match="t:lb[not(parent::t:ab)]">
        <xsl:variable name="line">
            <xsl:if test="@n">
                <xsl:value-of select="@n"/>
            </xsl:if>
        </xsl:variable>
        <br/> <!--hard coded carriage return would not be recognized-->
        <xsl:choose>
            <xsl:when test="number(@n) and @n mod number(5) = 0 and not(@n = 0)">
                <xsl:call-template name="margin-num"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="line-numbering-tab"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="margin-num">
        <xsl:value-of select="@n"/>
        <!-- template »line-numbering-tab« found in txt-tpl-linenumberingtab.xsl respectively odf-tpl-linenumberingtab.xsl -->
        <xsl:call-template name="line-numbering-tab"/>
    </xsl:template>
    
    <!-- $Id: txt-tpl-linenumberingtab.xsl 1543 2011-08-31 15:47:37Z ryanfb $ -->
    <xsl:template name="line-numbering-tab">
        <!--<xsl:text>		</xsl:text>-->
        <span style="padding-left: 5em;"/> <!--double tab would look much better but would not be recognized in browser-->
    </xsl:template>
    <xsl:template match="t:pb">
        <hr id="{@n}"/>
        <p>
            <xsl:value-of select="@n"/>
        </p>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:cb">
        <xsl:text>|</xsl:text>
        <sup id="{preceding-sibling::t:pb[1]/@n}{@n}">
            <xsl:value-of select="@n"/>
        </sup>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:handShift">
        <sub>
            <a href="{@new}">
                <xsl:value-of select="substring-after(@new, '#')"/>
            </a>
        </sub>
    </xsl:template>
    <xsl:template match="t:gap[@reason='illegible']">
        <xsl:variable name="quantity" select="@quantity"/>
        <xsl:for-each select="1 to $quantity">
            <xsl:text>+</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="t:subst">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:unclear">
        <xsl:value-of select="."/>
        <xsl:text>?</xsl:text>
    </xsl:template>
    <xsl:template match="t:orig">
        <span class="undeciphrable">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <xsl:template match="t:add">
        <xsl:variable name="id" select="generate-id()"/>
        <xsl:choose>
            <!--            has hand and place-->
            <xsl:when test="@hand and @place">
                <a href="#{$id}" data-toggle="popover" title="Added Text Position" data-content="Note added {                     if(@hand)                      then concat('by ',substring-after(@hand, '#')) else ''}                      at {upper-case(@place)} according to TEI definitions">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <!--            has place overstrike-->
            <xsl:when test="@place='overstrike' and preceding-sibling::t:del">
                <xsl:text>{</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            
            <!--            has only hand-->
            <xsl:when test="@hand and not(@place)">
                <xsl:text>/</xsl:text>
                <a href="#{$id}" data-toggle="popover" title="Correction author" data-content="Note added { concat('by ',substring-after(@hand, '#')) }">
                    <xsl:apply-templates/>
                </a>
                <xsl:text>/</xsl:text>
            </xsl:when>
            
            <!-- it has only place-->
            <xsl:otherwise>
                <a href="#{$id}" data-toggle="popover" title="Added Text Position" data-content="Note added                      at {upper-case(@place)} according to TEI definitions">
                    <xsl:apply-templates/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="t:gap[@reason='omitted']">
        <xsl:variable name="author" select="doc(concat('http://betamasaheft.aai.uni-hamburg.de/persons/', @resp, '.xml'))//t:TEI//t:persName[1]"/>
        <a href="#" data-toggle="tooltip" title="Omission by {$author}">. . . . .</a>
    </xsl:template>
    <xsl:template match="t:choice[t:sic and t:corr]">
        <xsl:variable name="sic" select="t:sic"/>
        <xsl:variable name="resp">
            <xsl:choose>
                <xsl:when test="starts-with(t:corr/@resp,'PRS')">
                    <xsl:value-of select="doc(concat('http://betamasaheft.aai.uni-hamburg.de/persons/', @resp, '.xml'))//t:TEI//t:persName[1]"/>
                </xsl:when>
                <xsl:when test="t:corr/@resp = 'AB'">Prof. Alessandro Bausi</xsl:when>
                <xsl:when test="t:corr/@resp = 'ES'">Eugenia Sokolinski</xsl:when>
                <xsl:when test="t:corr/@resp = 'DN'">Dr. Denis Nosnitsin</xsl:when>
                <xsl:when test="t:corr/@resp = 'MV'">Massimo Villa</xsl:when>
                <xsl:when test="t:corr/@resp = 'DR'">Dorothea Reule</xsl:when>
                <xsl:when test="t:corr/@resp = 'SG'">Solomon Gebreyes</xsl:when>
                <xsl:when test="t:corr/@resp = 'PL'">Dr. Pietro Maria Liuzzo</xsl:when>
                <xsl:when test="t:corr/@resp = 'SA'">Dr Stéphane Ancel</xsl:when>
                <xsl:when test="t:corr/@resp = 'SD'">Sophia Dege</xsl:when>
                <xsl:when test="t:corr/@resp = 'VP'">Dr Vitagrazia Pisani</xsl:when>
                <xsl:when test="t:corr/@resp = 'IF'">Iosif Fridman</xsl:when>
                <xsl:when test="t:corr/@resp = 'SH'">Susanne Hummel</xsl:when>
                <xsl:when test="t:corr/@resp = 'FP'">Francesca Panini</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a href="#" data-toggle="tooltip" title="Corrected {if ($resp) then concat('by ', $resp) else ()} from {$sic}">
            <xsl:value-of select="t:corr"/>
        </a>
    </xsl:template>
    <xsl:template match="t:sic">
        <xsl:variable name="resp">
            <xsl:choose>
                <xsl:when test="starts-with(@resp,'PRS')">
                    <xsl:value-of select="document(concat('../../Persons/', @resp, '.xml'))//t:TEI//t:persName[1]"/>
                </xsl:when>
                <xsl:when test="@resp = 'AB'">Prof. Alessandro Bausi</xsl:when>
                <xsl:when test="@resp = 'ES'">Eugenia Sokolinski</xsl:when>
                <xsl:when test="@resp = 'DN'">Dr. Denis Nosnitsin</xsl:when>
                <xsl:when test="@resp = 'MV'">Massimo Villa</xsl:when>
                <xsl:when test="@resp = 'DR'">Dorothea Reule</xsl:when>
                <xsl:when test="@resp = 'SG'">Solomon Gebreyes</xsl:when>
                <xsl:when test="@resp = 'PL'">Dr. Pietro Maria Liuzzo</xsl:when>
                <xsl:when test="@resp = 'SA'">Dr Stéphane Ancel</xsl:when>
                <xsl:when test="@resp = 'SD'">Sophia Dege</xsl:when>
                <xsl:when test="@resp = 'VP'">Dr Vitagrazia Pisani</xsl:when>
                <xsl:when test="@resp = 'IF'">Iosif Fridman</xsl:when>
                <xsl:when test="@resp = 'SH'">Susanne Hummel</xsl:when>
                <xsl:when test="@resp = 'FP'">Francesca Panini</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <a href="#" data-toggle="tooltip" title="Marked as incorrect {if ($resp) then concat('by ', $resp) else ()}">
            <xsl:value-of select="."/>
            <xsl:text> (sic)</xsl:text>
        </a>
    </xsl:template>
    <xsl:template match="t:desc[not(parent::t:relation)][not(parent::t:handNote)]">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="t:q">
        <p>
            <xsl:choose>
                <xsl:when test="text()">
                    <xsl:value-of select="concat('(', @xml:lang, ') ')"/>
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="lang" select="@xml:lang"/>
                    <xsl:text>Text in </xsl:text>
                    <xsl:value-of select="ancestor::t:TEI/t:teiHeader/t:profileDesc/t:langUsage/t:language[@ident = $lang]/text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    <xsl:template match="t:signatures">
        <xsl:value-of select="text()"/>
        <xsl:if test="t:note">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="t:note"/>
        </xsl:if>
    </xsl:template>
    
    
    
    <xsl:template match="t:supplied">
        
        <xsl:choose>
            <xsl:when test="@reason = 'lost'">
                <xsl:text>[</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:when test="@reason = 'omitted'">
                <xsl:text>&lt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&gt;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>