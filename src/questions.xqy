(: 
 :	Copyright 2010-2011 Mark Logic Corporation
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
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace html="http://marklogic.com/jmakeig/html" at "/Socrates/src/lib/html-utils.xqy";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
declare namespace x="http://www.w3.org/1999/xhtml";
declare option xdmp:mapping "false";

let $q as xs:string? := (xdmp:get-request-field("q"), "")[1]
return (
	xdmp:set-response-content-type("text/html"),
	xdmp:set-response-encoding("utf-8"),
	html:html-serialize(
	<html xmlns="http://www.w3.org/1999/xhtml"> 
		<head>
			<title>Questions</title>
			<link href="/assets/browser.css" rel="stylesheet" type="text/css"/>
		</head>
		<body>
			<form><div><input type="search" name="q" id="q"/></div></form>
			{
			let $options := <options xmlns="http://marklogic.com/appservices/search">
      	<return-query>true</return-query>
    	</options>
			return for $result in search:search($q, $options)/search:result
      	let $question as element(s:question) := doc($result/@uri)/s:question
				return 
					<div>
						<a href="{s:get-url-question($question/@id)}">Summary: {data($question/s:summary)}</a>
					</div>
			}
			<div class="actions"><ul><li><a href="{s:get-url-question-new()}">New…</a></li></ul></div>
		</body>
	</html>
	)
)