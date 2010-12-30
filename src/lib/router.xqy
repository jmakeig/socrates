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
module namespace r="http://marklogic.com/router";
declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare option xdmp:mapping "false";

(: Amped :)
declare function r:read-routes($path as xs:string) as element(r:routes) {
	xdmp:invoke($path)
};

declare function r:route($routes as element(r:routes)) as xs:string? {
	r:route($routes, xdmp:get-request-path(), xdmp:get-request-method(), xdmp:get-request-header("Accept"))
};

(: TODO: This is ugly and should be broken into smaller functions for testing and readability. :)
declare function r:route($routes as element(r:routes), $url as xs:string, $method as xs:string, $accept as xs:string?) as xs:string? {
	let $tokens := tokenize($url, "\?")
	let $path := $tokens[1]
	let $params := tokenize($tokens[2], "&amp;")
	(:let $_ := xdmp:log($routes):)
	let $path-matches as element(r:route)* :=  
		for $r in $routes/r:route
		where
			    r:matches-path($r/r:path, $path)
			and r:matches-parameters($r/r:parameters, $params)
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
											r:resolve-matched-route($matches, $path) 
									else 
										r:compose-error($routes, $url, 400, "Bad Request")	
};

declare function r:resolve-matched-route($route as element(r:route), $path) as xs:string {
	let $resolution := replace(
		$path, 
		r:adjust-for-trailing-slash($route/r:path, $route/r:path/@trailing-slash), 
		($route/r:resolution, $route/r:redirect)[1]
	)
	return
		if($route/r:resolution) then
			$resolution
		else if($route/r:redirect) then
			let $code as xs:integer := if($route/r:redirect/@type eq "permanent") then 301 else 302
			let $msg as xs:string := r:get-response-message($code)
			(: TODO: error.xqy should NOT be hard-coded (and it's misnamed) :)
			return concat("error.xqy?url=", $path, "&amp;code=", xs:string($code), "&amp;msg=", $msg, "&amp;location=", $resolution)
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
		xdmp:has-privilege($priv-test, ($priv-test/@action, "execute")[1])
	else
		true()
};

declare function r:matches-accept($accept-test as element(r:accept)?, $accept as xs:string?) as xs:boolean {
	true()
};

declare function r:matches-parameters($param-test as element(r:parameters)?, $params as xs:string?) as xs:boolean {
	true()
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

declare function r:compose-error($routes as element(r:routes), $url as xs:string, $code as xs:integer, $message as xs:string?) {
	let $error as element(r:error) := $routes/r:error
	let $query-string as xs:string := string-join((
		concat("url=", $url),
		concat("code=", xs:string($code)),
		if($message) then concat("msg=", xdmp:url-encode($message)) else ""
	), "&amp;")
	return
		concat($error,"?", $query-string)
};

declare function r:redirect-response($name as xs:string, $type as xs:integer?)  as  empty-sequence() {
	(
		xdmp:add-response-header("Location", $name),
		xdmp:set-response-code($type, r:get-response-message($type))
	)
};
