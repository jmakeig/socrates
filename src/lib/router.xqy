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

declare function r:route($routes as element(r:routes)) as xs:string? {
	r:route($routes, xdmp:get-request-path(), xdmp:get-request-method(), xdmp:get-request-header("Accept"))
};

declare function r:route($routes as element(r:routes), $url as xs:string, $method as xs:string, $accept as xs:string?) as xs:string? {
	let $tokens := tokenize($url, "\?")
	let $path := $tokens[1]
	let $params := tokenize($tokens[2], "&amp;")
	let $matches :=  
		for $r in $routes/r:route
		where
			    r:matches-method($r/r:method,$method) 
			and r:matches-path($r/r:path, $path)
			and r:matches-parameters($r/r:parameters, $params)
			and r:matches-accept($r/r:accept, $accept)
		order by xs:int($r/@priority) descending
		return $r
	(:let $_ := xdmp:log($matches):)
	return 
		(:let $_ := xdmp:log(string-join(($path, $matches[1]/r:path, $matches[1]/r:resolution), ", ")):)
		if($matches) then 
			replace(
				$path, 
				r:adjust-for-trailing-slash($matches[1]/r:path, $matches[1]/r:path/@trailing-slash), 
				$matches[1]/r:resolution
			) 
		else 
			(: TODO: I'm not sure of the best way to propagate errors. :)
			concat(data($routes/r:error),"?url=", $url, "&amp;code=404")
};


declare function r:matches-accept($accept-test as element(r:accept)?, $accept as xs:string) as xs:boolean {
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