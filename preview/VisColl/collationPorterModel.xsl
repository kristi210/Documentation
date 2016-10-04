<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="#all"
    version="2.0">
    
    
    
    <xsl:template name="DotPorterIfy">
        <xsl:param name="porterified" tunnel="yes"/>
        
        <collation>
            <xsl:for-each select=".//t:item">
                <xsl:sort select="position()"/>
                <quire>
                    <xsl:copy-of select="@*"/>
                    <xsl:attribute name="n"><xsl:value-of select="position()"/></xsl:attribute>
                    
                    <xsl:variable name="singletoncount">
                        <xsl:if test="matches(.,'stub')">
                            <xsl:analyze-string select="." regex="(\d)(,?[\s\n]+stub[\s\n]+after[\s\n]+)(\d)">
                                <xsl:matching-substring>1</xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:analyze-string select="." regex="(\d)(,?[\s\n]+stub[\s\n]+before[\s\n]+)(\d)">
                                        <xsl:matching-substring>1</xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                            
                        </xsl:if>
                    </xsl:variable>
                    
                    <xsl:call-template name="leafs">
                        <xsl:with-param name="folio">1</xsl:with-param>
                        <xsl:with-param name="currentpos">1</xsl:with-param>
                        <xsl:with-param name="prec"><xsl:value-of select="sum(preceding::t:dim[@unit='leaf'])"/></xsl:with-param>
                        <xsl:with-param name="count"><xsl:value-of select="number(t:dim[@unit='leaf'])"/></xsl:with-param>
                        <xsl:with-param name="singletons"><xsl:value-of select="string-length($singletoncount)"/></xsl:with-param>
                        
                    </xsl:call-template> 
                </quire>
                
                
            </xsl:for-each>
        </collation>
    </xsl:template>
    
    <xsl:template name="leafs">
        <xsl:param name="currentpos" />
        <xsl:param name="folio" />
        <xsl:param name="count" />
        <xsl:param name="prec"/>
        <xsl:param name="singletons"/>
        <xsl:variable name="position" select="$count + $singletons"/>
       
        
        
        <!--        <xsl:value-of select="$position"/>-->
        
        
        <!--        extract information from string about singleton-->
        <xsl:variable name="singleton">
            <xsl:analyze-string select="." regex="(\d)(,?[\s\n]+stub[\s\n]+after[\s\n]+)(\d)">
                <xsl:matching-substring>
                    <couple>
                        <singleton><xsl:value-of select="regex-group(1)"/></singleton>
                        <boa>+</boa>
                        <stub><xsl:value-of select="regex-group(3)"/></stub>
                    </couple>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:analyze-string select="." regex="(\d)(,?[\s\n]+stub[\s\n]+before[\s\n]+)(\d)">
                        <xsl:matching-substring>
                            <couple>
                                <singleton><xsl:value-of select="regex-group(1)"/></singleton>
                                <boa>-</boa>
                                <stub><xsl:value-of select="regex-group(3)"/></stub>
                            </couple>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:variable> 
        
        
        <xsl:variable name="leafs">
            <xsl:for-each select="1 to $count">
                <xsl:sort order="ascending" select="position()"/>
               <leaf n="{position()}" mode="original" folio_number="{$prec+position()}"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="leafs2">
            <xsl:for-each select="$leafs/t:leaf">
                <xsl:sort order="ascending" select="position()"/>
                <leaf><xsl:copy-of select="@*"/>
                    <xsl:choose>
                        <xsl:when test="position() = $singleton//t:singleton"><xsl:attribute name="single">true</xsl:attribute></xsl:when>
                        <xsl:otherwise><xsl:attribute name="single">false</xsl:attribute></xsl:otherwise>
                    </xsl:choose>
                </leaf>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="leafs3">
            <xsl:for-each select="$leafs2/t:leaf">
                <xsl:sort order="ascending" select="position()"/>
                <xsl:variable name="n" select="@n"/>
                <xsl:if test="$singleton/t:couple[descendant::t:stub=$n]//t:boa = '-'">
                    <leaf>
                        <xsl:attribute name="conjoin">
                            <xsl:value-of select="$singleton/t:couple[descendant::t:stub=$n]//t:singleton"/>
                        </xsl:attribute>
                    </leaf>
                </xsl:if>
                <leaf><xsl:copy-of select="@*"/>
                </leaf>
                <xsl:if test="$singleton/t:couple[descendant::t:stub=$n]//t:boa = '+'">
                    <leaf>
                        <xsl:attribute name="conjoin">
                            <xsl:value-of select="$singleton/t:couple[descendant::t:stub=$n]//t:singleton"/>
                        </xsl:attribute>
                    </leaf>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="leafs4">
            <xsl:for-each select="$leafs3/t:leaf">
                <xsl:sort order="ascending" select="position()"/>
                <xsl:variable name="pos" select="@position"/>
                <leaf>
                    <xsl:copy-of select="@*"/>
                    <xsl:attribute name="position"><xsl:value-of select="position()"/></xsl:attribute>
                    
                    <xsl:if test="@single='false'">
                        <xsl:attribute name="conjoin">
                            <xsl:choose>
                                <xsl:when test="@folio_number"><xsl:value-of select="((($count+1)+$singletons) - position())"/></xsl:when>
                                
                            </xsl:choose>
                            </xsl:attribute>
                    </xsl:if>
                </leaf>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$leafs4"/>
        
        
        <!--        first test if there is a stub at position 1-->
        <!--<xsl:if test="($currentpos &lt;= $position) and ($currentpos = 1) and ($singleton//t:stub = 'initialStub')">
            <values>stub at position 1 count<xsl:value-of select="$count"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singleton<xsl:value-of select="$singletons"/></values>
            <leaf>
                <xsl:attribute name="conjoin"><xsl:value-of select="$singleton//t:singleton[following-sibling::t:stub  = 'initialStub']"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
                
            </leaf>-->
            <!--  <leaf single="false"> 
                <xsl:attribute name="mode">
                    <xsl:choose>
                        <xsl:when test="contains(.,'added')">added</xsl:when>
                        <xsl:otherwise>original</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="$folio"/></xsl:attribute>
                <xsl:attribute name="folio_number"><xsl:value-of select="$prec + $currentpos"/></xsl:attribute>
                <xsl:attribute name="conjoin"><xsl:value-of select="(($count) - $folio)"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos + 1"/>
                </xsl:attribute>
            </leaf>-->
            
            
<!--        </xsl:if>-->
        
        <!--
        test if the folio in the current position has a number corresponding to the signleton and to a stub (cases like
        3 stub after 6; 6 stub after 3-->
       <!-- <xsl:if test="($currentpos &lt;= $position) and ($folio=$singleton//t:singleton) and ($folio=$singleton//t:stub)">
            <values>3 stub after 6; 6 stub after 3 count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values><leaf single="true"> 
                <xsl:attribute name="mode">
                    <xsl:choose>
                        <xsl:when test="contains(.,'added')">added</xsl:when>
                        <xsl:otherwise>original</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="$folio"/></xsl:attribute>
                <xsl:attribute name="folio_number"><xsl:value-of select="$prec + $currentpos"/></xsl:attribute>
                
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
            </leaf>
            <values>count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values><leaf>
                <xsl:attribute name="conjoin"><xsl:value-of select="$singleton//t:singleton[following-sibling::t:stub = $folio]"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos +1"/>
                </xsl:attribute>
                
            </leaf>
        </xsl:if>-->
        
        <!--        test it the current folio is a singleton and that it is not also the referred position of a stub-->
       <!-- <xsl:if test="($currentpos &lt;= $position) and 
            ($folio=$singleton//t:singleton) and not($folio=$singleton//t:stub)">
            <values> current folio is a singleton and that it is not also the referred position of a stub count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values><leaf single="true"> 
                <xsl:attribute name="mode">
                    <xsl:choose>
                        <xsl:when test="contains(.,'added')">added</xsl:when>
                        <xsl:otherwise>original</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="$folio"/></xsl:attribute>
                <xsl:attribute name="folio_number"><xsl:value-of select="$prec + $currentpos"/></xsl:attribute>
                
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
            </leaf>
        </xsl:if>-->
        
<!--        new tests-->
       <!-- <xsl:if test="($currentpos &lt;= $position) and (($position -1) = $singleton//t:stub)
            and ($currentpos =($singleton//t:stub +1)) and not($folio=$singleton//t:singleton)">
            
            <values>stub only
                count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values>
            
            <leaf>
                <xsl:attribute name="conjoin"><xsl:value-of select="$singleton//t:singleton[following-sibling::t:stub = ($currentpos -1)]"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$position"/>
                </xsl:attribute>
                
            </leaf>
        </xsl:if>
        
        <xsl:if test="($currentpos &lt;= $position) and ($position = $singleton//t:stub)
            and not($folio=$singleton//t:singleton)">
            
            <values>folio before stub
                count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values>
            <leaf>
                <xsl:attribute name="mode">
                    <xsl:choose>
                        <xsl:when test="contains(.,'added')">added</xsl:when>
                        <xsl:otherwise>original</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="$folio"/></xsl:attribute>
                <xsl:attribute name="folio_number"><xsl:value-of select="$prec + $currentpos"/></xsl:attribute>
                <xsl:attribute name="conjoin"><xsl:value-of select="(($count+1) - $folio)"/></xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
            </leaf>
        </xsl:if>-->
        
        <!--        test for a stub which is not in the same relative position as a singleton  -->
       <!-- <xsl:if test="($currentpos &lt;= $position) 
            and ($folio[.!=1] =$singleton//t:stub) and not($folio=$singleton//t:singleton)">
            
            <values>stub only
                count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values><leaf>
                <xsl:attribute name="conjoin"><xsl:value-of select="$singleton//t:singleton[following-sibling::t:stub = $folio]"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
                
            </leaf>
        </xsl:if>-->
        
        <!--        test for stub after folio 1, position 2, creates folio 1 and the stub-->
       <!-- <xsl:if test="($currentpos &lt;= $position) and ($folio[.=1]=$singleton//t:stub) and not($folio=$singleton//t:singleton)">
            <values>stub after folio 1, position 2, creates folio 1 and the stub count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values><leaf single="false"> 
                <xsl:attribute name="mode">
                    <xsl:choose>
                        <xsl:when test="contains(.,'added')">added</xsl:when>
                        <xsl:otherwise>original</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="$folio"/></xsl:attribute>
                <xsl:attribute name="folio_number"><xsl:value-of select="$prec + $folio"/></xsl:attribute>
                <xsl:attribute name="conjoin"><xsl:value-of select="(($count+1) - $folio)"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
            </leaf>
            <values>count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values><leaf>
                <xsl:attribute name="conjoin"><xsl:value-of select="$singleton//t:singleton[following-sibling::t:stub = $folio]"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos + 1"/>
                </xsl:attribute>
                
            </leaf>
        </xsl:if>-->
        
        <!--    NORMAL FOLIO    test for a folio which is not a sigleton or after which there is a stub-->
        <!--<xsl:if test="
            ($currentpos &lt;= $position) and not(($folio=$singleton//t:singleton) 
                                                                                       or ($currentpos=$singleton//t:stub) 
                                                                                       or (($currentpos = 1) 
                                                                                                and  ($singleton//t:stub = 'initialStub')))">
            
            <values>a folio which is not a sigleton or after which there is a stub count<xsl:value-of select="$count"/>, position<xsl:value-of select="$position"/>, currentpos<xsl:value-of select="$currentpos"/>, folio<xsl:value-of select="$folio"/>, prec<xsl:value-of select="$prec"/>, singeltons<xsl:value-of select="$singletons"/></values> <leaf single="false"> 
                <xsl:attribute name="mode">
                    <xsl:choose>
                        <xsl:when test="contains(.,'added')">added</xsl:when>
                        <xsl:otherwise>original</xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="n"><xsl:value-of select="$folio"/></xsl:attribute>
                <xsl:attribute name="folio_number"><xsl:value-of select="$prec + $folio"/></xsl:attribute>
                <xsl:attribute name="conjoin"><xsl:value-of select="(($count+1) - $folio)"/>
                </xsl:attribute>
                <xsl:attribute name="position"><xsl:value-of select="$currentpos"/>
                </xsl:attribute>
            </leaf>
            
        </xsl:if>
        -->
        
        
        <!-- After each iteration increases the position of 1 or 2 if a stub and Repeats The Loop Until Finished-->
        
       <!-- <xsl:if test="$currentpos &lt;= $position">
            <xsl:call-template name="leafs">
                <xsl:with-param name="currentpos">
                    <xsl:choose>
                        <xsl:when test="$folio[.=1]=$singleton//t:stub">
                            <xsl:value-of select="$currentpos + 2"/>
                        </xsl:when>
                        <xsl:when test="$folio=$singleton//t:stub and $folio=$singleton//t:singleton">
                            <xsl:value-of select="$currentpos + 2"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$currentpos + 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="prec">
                    <xsl:choose>
                        <xsl:when test="$folio=$singleton//t:stub">
                            <xsl:value-of select="$prec - 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prec"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="singletons">
                    <xsl:value-of select="$singletons"/>
                </xsl:with-param>
                <xsl:with-param name="count">
                    <xsl:value-of select="$count"/>
                </xsl:with-param>
                <xsl:with-param name="folio">
                    <xsl:choose><xsl:when test="($currentpos = 1) and ($singleton//t:stub = 'initialStub')">
                        <xsl:value-of select="$folio"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$folio + 1"/></xsl:otherwise></xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        -->
    </xsl:template>
    
   
</xsl:stylesheet>