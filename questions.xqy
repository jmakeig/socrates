xquery version "1.0-ml";
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
declare namespace x="http://www.w3.org/1999/xhtml";
declare namespace s="http://marklogic.com/socrates";
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
				return <div>
					<a href="/question.xqy?id={data($question/@id)}">Summary: {data($question/s:summary)}</a>
				</div>
			}
			<div class="actions"><ul><li><a href="/new.xqy">New…</a></li></ul></div>
		</body>
	</html>
	)
)