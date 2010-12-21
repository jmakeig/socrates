xquery version "1.0-ml";
module namespace html="http://marklogic.com/jmakeig/html";

declare function html:html-serialize($node as element()?) as item()? {
	xdmp:xslt-invoke("html-serializer.xsl", document {$node})
};