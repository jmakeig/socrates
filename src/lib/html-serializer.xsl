
<!-- 
  Copyright 2010-2011 Mark Logic Corporation
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
      http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  
  @author Justin Makeig <jmakeig@marklogic.com>
-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns      ="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xhtml">

  <xsl:output method="xhtml" omit-xml-declaration="yes"/>

  <xsl:template match="/xhtml:html">
    <!-- XSLT is not capable of serializing the HTML5 doctype -->
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;&#13;</xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <!-- Rewrite XHTML elements so they don't use a prefix -->
  <xsl:template match="xhtml:*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <!-- Copy everything else unchanged -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>