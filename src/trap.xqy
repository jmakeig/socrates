xquery version "1.0-ml";

import module namespace html="http://marklogic.com/jmakeig/html" at "/Socrates/src/lib/html-utils.xqy";
import module namespace r="http://marklogic.com/router" at "/Socrates/src/lib/router.xqy";

declare option xdmp:mapping "false";

declare variable $error:errors as node()* external;

let $url as xs:string? := xdmp:get-request-field("url")
let $code as xs:integer := xs:integer((xdmp:get-request-field("code"), xdmp:get-response-code()[1])[1])
let $msg as xs:string? := xdmp:get-request-field("msg", xdmp:get-response-code()[2])
let $location as xs:string? := xdmp:get-request-field("location")
let $routes := r:read-routes("/routes.xml")

return (
	xdmp:set-response-code($code, $msg),
	if($code >= 300 and $code < 400) then
		r:redirect-response($location, $code)
	else (
		xdmp:set-response-content-type("text/html"),
		html:html-serialize(
			<html xmlns="http://www.w3.org/1999/xhtml"> 
				<head>
					<title>{concat($code, ": " , $msg)}</title>
					<style type="text/css">
						body {{ font-family: Helvetica, sans-serif; }}
						pre {{ font-family: Inconsolata, Consolas, monospace; }}
						.error {{ color: red; }}
					</style>
				</head>
				<body>
					<h1>{concat($code, " " , $msg)}</h1>
					{if($error:errors) then (<h2>Error</h2>,<p class="error"><strong>{data($error:errors[1]/error:format-string)}</strong></p>,<p class="error">{data($error:errors[1]/error:stack/error:frame[1]/error:uri)}, line {data($error:errors[1]/error:stack/error:frame[1]/error:line)}</p>,<pre>{xdmp:quote($error:errors)}</pre>) else () }
					<h2>Routes</h2>
					<pre>{xdmp:quote($routes)}</pre>
				</body>	
			</html>
		)
	)
)
