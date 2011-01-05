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
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
declare option xdmp:mapping "false";

let $id as xs:string := xdmp:get-request-field("id")
let $response as xs:string := xdmp:get-request-field("response")
let $question as element(s:question)? := /s:question[@id eq $id]
let $rid := xs:string(xdmp:random())
let $r as element(s:response) := 
	<s:response id="{$rid}" created="{current-dateTime()}">
		<s:respondent>{xdmp:get-current-user()}</s:respondent>
		<s:comment>{html:parse-from-string($response)}</s:comment>
	</s:response>
return (
	xdmp:node-insert-child($question/s:responses, $r),
	xdmp:set-response-code(303,""),
	(:xdmp:add-response-header("Location", s:get-url-question($id, $rid)):)
	xdmp:redirect-response(s:get-url-question($id, $rid))
)