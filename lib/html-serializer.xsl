<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xhtml" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xhtml="http://www.w3.org/1999/xhtml">
	<xsl:output method="xhtml" omit-xml-declaration="yes" />
	<xsl:template match="/xhtml:html">
		<!-- XSLT is not capable of serializing the HTML5 doctype -->
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;&#13;</xsl:text>
		<xhtml:html>
			<xsl:apply-templates select="attribute()|node()|comment()|processing-instruction()" />
		</xhtml:html>
	</xsl:template>
	<!-- Prefix magic for XHTML -->
	<xsl:template match="xhtml:*" priority="-1">
		<xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml"
			inherit-namespaces="no">
			<xsl:apply-templates select="attribute()|node()" />
		</xsl:element>
	</xsl:template>
	<!-- Pass-through for non-XHTML -->
	<xsl:template match="*[namespace-uri() ne 'http://www.w3.org/1999/xhtml']">
		<xsl:copy>
			<xsl:apply-templates select="attribute()|node()|comment()|processing-instruction()" />
		</xsl:copy>
	</xsl:template>
	<!-- Generic copy for non-nodes -->
	<xsl:template match="attribute()|text()|comment()|processing-instruction()">
		<xsl:copy />
	</xsl:template>
</xsl:stylesheet>