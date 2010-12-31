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
import module namespace r="http://marklogic.com/router" at "/Socrates/src/lib/router.xqy";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
declare option xdmp:mapping "false";

let $url as xs:string := xdmp:get-request-url()
let $method as xs:string := xdmp:get-request-method()
let $accept as xs:string? := xdmp:get-request-header("Accept")
let $options as element(r:routes) := r:read-routes("/routes.xml")
return 
	r:route($options, $url, $method, $accept)