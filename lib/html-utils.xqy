xquery version "1.0-ml";
module namespace html="http://marklogic.com/jmakeig/html";

(::
 : Serialize a node as browser-friendly (X)HTML(5) using XSLT.
 :)
declare function html:html-serialize($node as element()?) as item()? {
	xdmp:xslt-invoke("html-serializer.xsl", document {$node})
};

(::
 : Parse XHTML nodes from a string.
 :)
declare function html:parse-from-string($string as xs:string?) as node()* {
	xdmp:unquote(
		$string, 
		"http://www.w3.org/1999/xhtml", 
		("format-xml", "repair-none")
	)
};