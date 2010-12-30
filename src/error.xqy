xquery version "1.0-ml";
import module namespace r="http://marklogic.com/router" at "/Socrates/src/lib/router.xqy";
declare option xdmp:mapping "false";
let $url as xs:string := xdmp:get-request-field("url")
let $code as xs:integer := xs:integer(xdmp:get-request-field("code"))
let $msg as xs:string? := xdmp:get-request-field("msg")
let $routes := r:read-routes("/routes.xml")
return (
	xdmp:set-response-code($code, $msg),
	xdmp:set-response-content-type("text/plain"),
	$routes
)
