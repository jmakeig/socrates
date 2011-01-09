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
import module namespace r="http://marklogic.com/router" at "/lib/router.xqy";
import module namespace mvc="http://marklogic.com/mvc" at "/lib/mvc.xqy";
import module namespace s="http://marklogic.com/socrates" at "/lib/socrates.xqy";

declare option xdmp:mapping "false";

let $q as xs:string? := xdmp:get-request-field("q", "")
let $options := <options xmlns="http://marklogic.com/appservices/search">
		<return-query>true</return-query>
	</options>
let $results := search:search($q, $options)/search:result
return
	let $model as map:map := mvc:model-put(mvc:model-create("q", $q), "results", $results)
	return mvc:render-view("questions.html", $model)
	