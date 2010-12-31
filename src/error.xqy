xquery version "1.0-ml";
import module namespace html="http://marklogic.com/jmakeig/html" at "/Socrates/src/lib/html-utils.xqy";
import module namespace r="http://marklogic.com/router" at "/Socrates/src/lib/router.xqy";
declare option xdmp:mapping "false";
let $url as xs:string := xdmp:get-request-field("url")
let $code as xs:integer := xs:integer(xdmp:get-request-field("code"))
let $msg as xs:string? := xdmp:get-request-field("msg", "No Message")
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
					</style>
				</head>
				<body>
					<h1>{concat($code, " " , $msg)}</h1>
					<pre>{xdmp:quote($routes)}</pre>
				</body>	
			</html>
		)
	)
)
