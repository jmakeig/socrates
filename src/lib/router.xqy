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
module namespace r="http://marklogic.com/router";
import module namespace http="http://marklogic.com/util/http" at "/lib/http.xqy";
declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare option xdmp:mapping "false";

(: Amped to socrates-internal :)
declare function r:read-routes($path as xs:string) as element(r:routes) {
	xdmp:invoke($path)
};

declare function r:route($routes as element(r:routes)) as xs:string? {
	r:route($routes, xdmp:get-request-url(), xdmp:get-request-method(), xdmp:get-request-header("Accept"))
};

(: TODO: This doesn't work. It won't parse repeated fields correctly (e.g. ?foo=bar&foo=baz) :)
(:
declare function r:parse-params($params as xs:string?) as map:map? {
	if($params) then
		let $map as map:map := map:map()
		let $k-vs := tokenize($params, "&amp;")
		let $_ as empty-sequence() := for $k-v in $k-vs
			let $pair := tokenize($k-v, "=")
			return map:put($map, $pair[1], $pair[2])
		return (xdmp:log($map), $map) 
	else ()
};
:)

(: TODO: This is ugly and should be broken into smaller functions for testing and readability. :)
declare function r:route($routes as element(r:routes), $url as xs:string, $method as xs:string, $accept as xs:string?) as xs:string? {
	let $tokens := tokenize($url, "\?")
	let $path := $tokens[1]
	let $params := http:parse-params()
	let $path-matches as element(r:route)* :=  
		for $r in $routes/r:route
		where
			    r:matches-path($r/r:path, $path)
			and r:matches-parameters($r/r:parameters, tokenize($tokens[2], "&amp;"))
		return $r
	return
		(: If no paths, including query string, matches -> 404 Not Found :)
		if(count($path-matches) eq 0) then
			r:compose-error($routes, $url, 404, "Not Found")
		else
			let $method-matches := 
				for $r in $path-matches
				where r:matches-method($r/r:method,$method)
				return $r 
			return
				(: If no method matches -> 405 Method Not Allowed :) 
				if(count($method-matches) eq 0) then
					r:compose-error($routes, $url, 405, "Method Not Allowed")
				else
					let $privilege-matches :=
						for $r in $method-matches
						where r:matches-privilege($r/r:privilege)
						return $r
					return
						(: If incorrect priv -> 403 Forbidden :) 
						if(count($privilege-matches) eq 0) then
							r:compose-error($routes, $url, 403, "Forbidden")
						else
							let $accept-matches :=
								for $r in $method-matches
								where r:matches-accept($r/r:accept, $accept)
								return $r
							return
								(: If no acceptable content-type -> 406 Not Acceptable :)
								if(count($accept-matches) eq 0) then
									r:compose-error($routes, $url, 406, "Not Acceptable")
								else
									let $matches := (
										for $r in $accept-matches
										order by xs:int($r/@priority) descending
										return $r
									)[1]
									return 
										if(count($matches) eq 1) then 
											r:resolve-matched-route($matches (: route :), $path, $params, $accept) 
									else 
										r:compose-error($routes, $url, 400, "Bad Request")	
};

declare function r:resolve-matched-route($route as element(r:route), $path as xs:string, $params as map:map?, $accept as xs:string?) as xs:string {
	(: TODO: This is the second time this is parsed and calculated during routing. :)
	let $preferred-variant as xs:string? := 
		if($route/r:accept) then
			http:variant-to-string(
				http:preferred-variant(
					http:parse-accept-header($accept)/http:variant, 
					http:parse-accept-header(data($route/r:accept))/http:variant
				)
			)
		else ()
	let $_ := if(exists($params) and exists($preferred-variant)) then 
		map:put($params, "_variant", $preferred-variant) 
		else ()
	(:let $_ := xdmp:log(concat("Variant: ", http:variant-to-string(http:parse-accept-header((data($route/r:accept), "*/*")[1])/http:variant))):)
	let $_ := xdmp:log(concat("PV: ", $preferred-variant))
	let $url as xs:string :=  
		replace(
			$path, 
			r:adjust-for-trailing-slash($route/r:path, $route/r:path/@trailing-slash), 
			($route/r:resolution, $route/r:redirect)[1]
		)
	let $query-string as xs:string := 	
		if(exists($params) and xdmp:get-request-method() eq "GET") then 
			string-join(
				for $key in map:keys($params)
				return string-join(($key, map:get($params, $key)), "="),
				"&amp;"
			)
		else ""
	let $resolution as xs:string := concat(
		$url,
		if(contains($url, "?")) then "" else "?",
		$query-string
	) 
		
	let $_ := xdmp:log(concat("Resolution: ", $resolution))
	return
		if($route/r:resolution) then
			$resolution
		else if($route/r:redirect) then
			let $code as xs:integer := if($route/r:redirect/@type eq "permanent") then 301 else 302
			let $msg as xs:string := r:get-response-message($code)
			(: TODO: error.xqy should NOT be hard-coded (and it's misnamed) :)
			return concat("trap.xqy?url=", $path, "&amp;code=", xs:string($code), "&amp;msg=", $msg, "&amp;location=", $resolution)
		else 
			error(xs:QName("r:NORESOLUTIONORREDIRECT"), "The route must either have a resolution or a redirector element") 
};

declare private function r:get-response-message($code as xs:integer) as xs:string {
	if($code eq 200) then "OK"
	else if($code eq 301) then "Moved Permanently"
	else if($code eq 302) then "Found"
	else if($code eq 400) then "Bad Request"
	else if($code eq 403) then "Forbidden"
	else if($code eq 404) then "Not Found"
	else if($code eq 405) then "Method Not Allowed"
	else if($code eq 406) then "Not Acceptable"
	else "Other"
};

declare function r:matches-privilege($priv-test as element(r:privilege)?) as xs:boolean {
	if($priv-test) then
		let $_ := xdmp:log($priv-test)
		return
		xdmp:has-privilege($priv-test, "execute")
	else
		true()
};

declare function r:matches-accept($accept-test as element(r:accept)?, $accept as xs:string?) as xs:boolean {
	if(empty($accept-test)) then 
		true()
	else
		let $accept-variants as element(http:variant)* := http:parse-accept-header($accept)/http:variant
		let $declared-variants as element(http:variant)* := http:parse-accept-header(data($accept-test))/http:variant
		let $preferred-variants as element(http:variant)* := http:preferred-variant($accept-variants, $declared-variants)
		return count($preferred-variants) > 0 
};

declare function r:matches-parameters($param-test as element(r:parameters)?, $params as xs:string?) as xs:boolean {
	true()
	(:
	if(empty($param-test) or "*" eq $param-test) then
		true()
	else
		let $tests := tokenize($param-test, "\s*,\s*")
		let $ps := for $p in $params return tokenize($p, "=")[1]
		return $tests = $ps
	:)
};

declare function r:adjust-for-trailing-slash($pattern, $trailing-slash) as xs:string {
	if($trailing-slash = "ignore") then
		let $end := ends-with($pattern, "$")
		let $trimmed  := if($end) then substring($pattern, 1, string-length($pattern) - 1) else $pattern
		return concat($trimmed, "/?", if($end) then "$" else "")
	else
		$pattern
};

declare function r:matches-path($path-test as element(r:path)?, $path) as xs:boolean {
	matches(
		$path, 
		r:adjust-for-trailing-slash($path-test, $path-test/@trailing-slash)
	)
};

declare function r:matches-method($method-test as element(r:method)?, $method) as xs:boolean {
	if(empty($method-test) or "*" = $method-test) then
		true()
	else tokenize(data($method-test), "\s*,\s*") = $method
};

declare function r:matches-user-agent($user-agent-test as element(r:user-agent)?, $user-agent) as xs:boolean {
	if(empty($user-agent-test) or "*" = $user-agent-test) then
		true()
	else matches($user-agent, $user-agent-test)
};


declare function r:compose-error($routes as element(r:routes), $url as xs:string, $code as xs:integer, $message as xs:string?) {
	let $error as element(r:error) := $routes/r:error
	let $query-string as xs:string := string-join((
		concat("url=", $url),
		concat("code=", xs:string($code)),
		if($message) then concat("msg=", xdmp:url-encode($message)) else ""
	), "&amp;")
	return (
		(:xdmp:log(concat($error,"?", $query-string)),:)
		concat($error,"?", $query-string)
	)
};

(: Amped to socrates-internal :)
declare function r:redirect-response($name as xs:string, $type as xs:integer?)  as  empty-sequence() {
	(
		xdmp:log(concat("Redirect to ", $name)),
		xdmp:add-response-header("Location", $name),
		xdmp:set-response-code($type, r:get-response-message($type))
	)
};

(::
 : Raise an error and route its handling to the common error page.
 :
 : @param code The HTTP error code. The 400 range is the only thing that really makes sense here.
 : @param errors Information about the error to convey to the error view
 : @return The rendered error
 :)
declare function r:raise-error($code as xs:integer, $errors as map:map) as item()* {
	xdmp:set-response-code($code, r:get-response-message($code)),
	xdmp:invoke(
		"/trap.xqy" (: TODO: Need to read this from the routes config :), (
			xs:QName("error:errors"), $errors
		), 
    ()
	)
};
