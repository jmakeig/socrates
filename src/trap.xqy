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

import module namespace html="http://marklogic.com/jmakeig/html" at "/lib/html-utils.xqy";
import module namespace r="http://marklogic.com/router" at "/lib/router.xqy";
import module namespace mvc="http://marklogic.com/mvc" at "/lib/mvc.xqy";

declare option xdmp:mapping "false";

declare variable $error:errors as item()* external;

let $url as xs:string? := xdmp:get-request-field("url")
let $code as xs:integer := xs:integer((xdmp:get-request-field("code"), xdmp:get-response-code()[1])[1])
let $msg as xs:string? := xdmp:get-request-field("msg", xdmp:get-response-code()[2])
let $location as xs:string? := xdmp:get-request-field("location")
let $routes := r:read-routes("/routes.xml")

return (
	xdmp:set-response-code($code, $msg),
	if($code >= 300 and $code < 400) then
		r:redirect-response($location, $code)
	else if($code eq 403) then
		(
			xdmp:log(concat("403 dispatched from ", $url)),
			xdmp:set-session-field("login-referrer", $url),
			r:redirect-response($routes/r:authenticate, 303)
		)
	else (
		xdmp:set-response-content-type("text/html"),
		if(xdmp:has-privilege("http://marklogic.com/socrates/debug", "execute")) then
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
						{if(($error:errors castable as map:map or exists($error:errors)) and $code >= 500) then (<h2>Error</h2>,<p class="error"><strong>{data($error:errors[1]/error:format-string)}</strong></p>,<p class="error">{data($error:errors[1]/error:stack/error:frame[1]/error:uri)}, line {data($error:errors[1]/error:stack/error:frame[1]/error:line)}</p>,<pre>{xdmp:quote($error:errors)}</pre>) else () }
						<h2>Context</h2>
						<h3>Security</h3>
						<h3>Session</h3>
						{if(xdmp:get-session-field-names()) then
							<ul>{for $s in xdmp:get-session-field-names()
							return <li><strong>{$s}</strong> {xdmp:get-session-field($s)}</li>}
						</ul>
						else ()}
						<h3>HTTP</h3>
						<ul>
						{<li><strong>Method</strong> {xdmp:get-request-method()}</li>,
						<li><strong>Original URL</strong> {$url}</li>,
						<li><strong>Current URL</strong> {xdmp:get-request-url()}</li>
						}
						{for $h in xdmp:get-request-header-names()
						return <li><strong>{$h}</strong> {xdmp:get-request-header($h)}</li>
						}
						</ul>
						<h2>Routes</h2>
						<pre>{xdmp:quote($routes)}</pre>
					</body>	
				</html>
		)
		else 
			mvc:render-view("error.html")
	)
)
