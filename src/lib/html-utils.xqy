(: 
 :	Copyright 2008-2010 Mark Logic Corporation
 :	
 :	Licensed under the Apache License, Version 2.0 (the "License");
 :	you may not use this file except in compliance with the License.
 :	You may obtain a copy of the License at
 :	
 :	    http://www.apache.org/licenses/LICENSE-2.0
 :	
 :	Unless required by applicable law or agreed to in writing, software
 :	distributed under the License is distributed on an "AS IS" BASIS,
 :	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 :	See the License for the specific language governing permissions and
 :	limitations under the License.
 :	
 :	@author Justin Makeig <jmakeig@marklogic.com>
 :
 :)
xquery version "1.0-ml";
module namespace html="http://marklogic.com/jmakeig/html";
declare option xdmp:mapping "false";

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