<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
		xmlns:atom="http://www.w3.org/2005/Atom"
		xmlns:rng="http://relaxng.org/ns/structure/1.0"
		xmlns:teix="http://www.tei-c.org/ns/Examples"
		xmlns:xd="http://www.pnp-software.com/XSLTdoc"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tei="http://www.tei-c.org/ns/1.0" 
		xmlns:xlink="http://www.w3.org/1999/xlink" 
		xmlns:dbk="http://docbook.org/ns/docbook" 
		xmlns:m="http://www.w3.org/1998/Math/MathML"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="tei xd xlink dbk xhtml m" 
		version="1.0">
  <xsl:import href="../xhtml/tei.xsl"/>
  <xsl:import href="../common/verbatim.xsl"/>
  <xsl:strip-space elements="teix:* rng:* xsl:* xhtml:* atom:* m:*"/>
  <xd:doc type="stylesheet">
    <xd:short>
      TEI stylesheet for making HTML presentations from TEI documents
      </xd:short>
    <xd:detail>
    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
   
      </xd:detail>
    <xd:author>See AUTHORS</xd:author>
    <xd:cvsId>$Id: teihtml-slides.xsl 4451 2008-03-11 00:06:36Z rahtz $</xd:cvsId>
    <xd:copyright>2007, TEI Consortium</xd:copyright>
  </xd:doc>
  <xsl:output encoding="utf-8" method="xml" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
  <xsl:param name="outputEncoding">utf-8</xsl:param>
  <xsl:param name="outputMethod">xml</xsl:param>
  <xsl:param name="outputSuffix">.xhtml</xsl:param>
  <xsl:param name="doctypePublic">-//W3C//DTD XHTML 1.1//EN</xsl:param>
  <xsl:param name="doctypeSystem">http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd</xsl:param>
  <xsl:param name="cssFile">http://www.tei-c.org/stylesheet/teislides.css</xsl:param>
  <xsl:param name="logoFile">logo.png</xsl:param>
  <xsl:param name="logoWidth">60</xsl:param>
  <xsl:param name="logoHeight">60</xsl:param>
  <xsl:param name="spaceCharacter">&#xA0;</xsl:param>
  <xsl:template name="lineBreak">
    <xsl:param name="id"/>
    <xhtml:br/>
  </xsl:template>
<!--
<xsl:text>(</xsl:text>
<xsl:value-of select="$id"/>
<xsl:text>)</xsl:text>
-->
  <xsl:param name="numberHeadings"/>
  <xsl:param name="splitLevel">0</xsl:param>
  <xsl:param name="subTocDepth">-1</xsl:param>
  <xsl:param name="topNavigationPanel"/>
  <xsl:param name="bottomNavigationPanel">true</xsl:param>
  <xsl:param name="linkPanel"/>
  <xsl:template name="copyrightStatement"/>
  <xsl:param name="makingSlides">true</xsl:param>

  <xsl:template match="tei:div" mode="number">
    <xsl:number level="any"/>
  </xsl:template>

  <xsl:template match="tei:div0/tei:div1" mode="number">
    <xsl:for-each select="parent::tei:div0">
      <xsl:number/>
    </xsl:for-each>
    <xsl:text>_</xsl:text>
    <xsl:number/>
  </xsl:template>

  <xsl:template match="tei:div1|tei:div" mode="genid">
    <xsl:value-of select="$masterFile"/>
    <xsl:apply-templates select="." mode="number"/>
  </xsl:template>

  <xsl:template match="tei:docAuthor">
    <div class="docAuthor">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:docDate">
    <div class="docDate">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="/tei:TEI">
    <xsl:param name="slidenum"><xsl:value-of select="$masterFile"/>0</xsl:param>
    <xsl:call-template name="outputChunk">
      <xsl:with-param name="ident">
        <xsl:value-of select="$slidenum"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <xsl:call-template name="mainslide"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:for-each select="tei:text/tei:body">
      <xsl:apply-templates select="tei:div|tei:div0|tei:div1"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="xrefpanel">
    <xsl:variable name="first"><xsl:value-of select="$masterFile"/>0</xsl:variable>
    <xsl:variable name="prev">
      <xsl:choose>
        <xsl:when test="preceding-sibling::tei:div">
          <xsl:apply-templates select="preceding-sibling::tei:div[1]" mode="genid"/>
        </xsl:when>
        <xsl:when test="preceding::tei:div">
          <xsl:apply-templates select="preceding::tei:div[1]" mode="genid"/>
        </xsl:when>
        <xsl:when test="preceding::tei:div1">
          <xsl:apply-templates select="preceding::tei:div1[1]" mode="genid"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="not($prev='')">
      <a class="xreflink" accesskey="p" href="{concat($prev,'.xhtml')}">
        <span class="button">&#xAB;</span>
      </a>
    </xsl:if>
    <xsl:text>  </xsl:text>
    <a class="xreflink" accesskey="f" href="{concat($first,'.xhtml')}">
      <span class="button">^</span>
    </a>
    <xsl:variable name="next">
      <xsl:choose>
        <xsl:when test="tei:div">
          <xsl:apply-templates select="tei:div[1]" mode="genid"/>
	</xsl:when>
        <xsl:when test="following-sibling::tei:div">
          <xsl:apply-templates select="following-sibling::tei:div[1]" mode="genid"/>
        </xsl:when>
        <xsl:when test="following::tei:div">
          <xsl:apply-templates select="following::tei:div[1]" mode="genid"/>
        </xsl:when>
        <xsl:when test="following::tei:div1">
          <xsl:apply-templates select="following::tei:div1[1]" mode="genid"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="not($next='')">
      <a class="xreflink" accesskey="n" href="{concat($next,'.xhtml')}">
        <span class="button">&#xBB;</span>
      </a>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="." mode="number"/>
  </xsl:template>

  <xsl:template name="mainslide">
    <html>
      <xsl:call-template name="addLangAtt"/>
      <head>
        <title>
          <xsl:call-template name="generateTitle"/>
        </title>
        <xsl:call-template name="includeCSS"/>
        <xsl:call-template name="cssHook"/>
        <xsl:call-template name="javascriptHook"/>
      </head>
      <body>
        <div class="slidetitle" style="font-size: 36pt;">
          <xsl:call-template name="generateTitle"/>
        </div>
        <div class="slidemain">
          <xsl:apply-templates select="tei:text/tei:front//tei:docAuthor"/>
          <xsl:apply-templates select="tei:text/tei:front//tei:docDate"/>
          <ul class="slidetoc">
            <xsl:for-each select="tei:text/tei:body">
              <xsl:for-each select="tei:div|tei:div0/tei:div1">
                <xsl:variable name="n">
                  <xsl:apply-templates select="." mode="genid"/>
                </xsl:variable>
                <li class="slidetoc">
                  <a href="{$n}.xhtml">
                    <xsl:value-of select="tei:head"/>
                  </a>
                </li>
              </xsl:for-each>
            </xsl:for-each>
          </ul>
        </div>
        <div class="slidebottom">
	  <div class="slidebottom-image">
	    <img id="logo" src="{$logoFile}" width="{$logoWidth}" height="{$logoHeight}" alt="logo"/>
	  </div>
	  <div class="slidebottom-text">
	    <xsl:variable name="next">
	      <xsl:value-of select="$masterFile"/>
	      <xsl:text>1</xsl:text>
	    </xsl:variable>
	    <a accesskey="n" href="{concat($next,'.xhtml')}">Start</a>
	  </div>
        </div>
      </body>
    </html>
  </xsl:template>

<xsl:template name="includeJavascript">
  <xsl:variable   name="prev">
    <xsl:choose>	
      <xsl:when test="preceding-sibling::tei:div">
	<xsl:apply-templates select="preceding-sibling::tei:div[1]" mode="genid"/>
      </xsl:when>
      <xsl:when test="preceding::tei:div1">
	<xsl:apply-templates select="preceding::tei:div1[1]" mode="genid"/>
      </xsl:when>
      <xsl:when test="preceding::tei:div">
	<xsl:apply-templates select="preceding::tei:div[1]" mode="genid"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$masterFile"/>
	<xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="next">
    <xsl:choose>
        <xsl:when test="tei:div">
          <xsl:apply-templates select="tei:div[1]" mode="genid"/>
	</xsl:when>

      <xsl:when test="following-sibling::tei:div">
	<xsl:apply-templates select="following-sibling::tei:div[1]" mode="genid"/>
      </xsl:when>
      <xsl:when test="following::tei:div1">
	<xsl:apply-templates select="following::tei:div1[1]" mode="genid"/>
      </xsl:when>
      <xsl:when test="following::tei:div">
	<xsl:apply-templates select="following::tei:div[1]" mode="genid"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$masterFile"/>
	<xsl:text>0</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
    <xsl:call-template name="writeJavascript">
      <xsl:with-param name="content">
  <xsl:text>
    var isOp = navigator.userAgent.indexOf('Opera') &gt; -1 ? 1 : 0;
    function keys(key) {
    if (!key) {
    key = event;
    key.which = key.keyCode;
    }
    switch (key.which) {
    case 10: // return
    case 32: // spacebar
    case 34: // page down
    case 39: // rightkey
    // case 40: 
    // downkey
    document.location = "</xsl:text>
    <xsl:value-of select="$next"/>
    <xsl:text>.xhtml";
    break;
    case 33: // page up
    case 37: // leftkey
    //case 38: 
    // upkey
    document.location = "</xsl:text>
    <xsl:value-of select="$prev"/>
    <xsl:text>.xhtml";
    break;
	}
	}
	function startup() {      
	if (!isOp) {		
	document.onkeyup = keys;
	document.onclick = clicker;
	}
	}
	
	function clicker(e) {
	var target;
	if (window.event) {
	target = window.event.srcElement;
	e = window.event;
	} else target = e.target;
	if (target.href != null ) return true;
	if (!e.which || e.which == 1) 
	document.location = "</xsl:text>
	<xsl:value-of select="$next"/>
	<xsl:text>.xhtml";
	}
	
	window.onload = startup;
  </xsl:text>
      </xsl:with-param>
    </xsl:call-template>
</xsl:template>

  <xsl:template match="tei:body/tei:div[tei:div]">
    <xsl:variable name="slidenum">
      <xsl:value-of select="$masterFile"/>
      <xsl:number/>
    </xsl:variable>
    <xsl:call-template name="outputChunk">
      <xsl:with-param name="ident">
        <xsl:value-of select="$slidenum"/>
      </xsl:with-param>
      <xsl:with-param name="content">
        <html>
          <xsl:call-template name="addLangAtt"/>
          <head>
            <title>
              <xsl:value-of select="tei:head"/>
            </title>
            <xsl:call-template name="includeCSS"/>
            <xsl:call-template name="cssHook"/>
            <xsl:call-template name="includeJavascript"/>
            <xsl:call-template name="javascriptHook"/>
          </head>
          <body>
            <h1>
              <xsl:value-of select="tei:head"/>
            </h1>
          </body>
        </html>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="tei:div"/>
  </xsl:template>

  <xsl:template match="tei:body/tei:div|tei:div">
    <xsl:choose>
      <xsl:when test="$splitLevel&gt;-1">
        <xsl:variable name="slidenum">
          <xsl:apply-templates select="." mode="genid"/>
        </xsl:variable>
        <xsl:call-template name="outputChunk">
          <xsl:with-param name="ident">
            <xsl:value-of select="$slidenum"/>
          </xsl:with-param>
          <xsl:with-param name="content">
            <xsl:call-template name="slideout"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="slidebody"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="slideout">
    <html>
      <xsl:call-template name="addLangAtt"/>
      <head>
        <title>
          <xsl:value-of select="tei:head"/>
        </title>
        <xsl:call-template name="includeCSS"/>
        <xsl:call-template name="cssHook"/>
        <xsl:call-template name="includeJavascript"/>
        <xsl:call-template name="javascriptHook"/>
      </head>
      <body>
        <xsl:call-template name="slidebody"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="slidebody">
    <div class="slidetop">
      <div class="slidetitle">
        <xsl:call-template name="header">
	  <xsl:with-param name="display">full</xsl:with-param>
	</xsl:call-template>
      </div>
      <xsl:if test="$splitLevel &gt;-1">
        <div class="xref">
          <xsl:call-template name="xrefpanel"/>
        </div>
      </xsl:if>
    </div>
    <div class="slidemain">
      <xsl:apply-templates/>
    </div>
    <div class="slidebottom">
      <xsl:call-template name="slideBottom"/>
    </div>
  </xsl:template>


  <xsl:template name="slideBottom">
    <div class="slidebottom">
      <div class="slidebottom-image">
	<img id="logo" src="{$logoFile}" width="{$logoWidth}" height="${logoHeight}" alt="logo"/>
      </div>
      <div class="slidebottom-text">
	<xsl:call-template name="generateTitle"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="tei:row">
	<xsl:variable name="c">
	  <xsl:number/>
	</xsl:variable>
	  <xsl:variable name="class">
	    <xsl:choose>
	      <xsl:when test="@role">
		<xsl:value-of select="@role"/>
	    </xsl:when>
	    <xsl:when test="$c mod 2=0">
	      <xsl:text>Even</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text>Odd</xsl:text>
	    </xsl:otherwise>
	    </xsl:choose>
	  </xsl:variable>
	<tr class="{$class}">
	  <xsl:apply-templates/>
	</tr>
  </xsl:template>

    <xsl:template match="teix:egXML">
      <div class="pre">
	<xsl:apply-templates mode="verbatim"/>
      </div>
  </xsl:template>

  <xsl:template match="xhtml:*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="tei:att">
    <span class="att">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

</xsl:stylesheet>



