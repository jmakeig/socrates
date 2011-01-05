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
import module namespace r="http://marklogic.com/router" at "/lib/router.xqy";
import module namespace s="http://marklogic.com/socrates" at "/lib/socrates.xqy";
declare option xdmp:mapping "false";

let $id as xs:string := xdmp:get-request-field("question")
let $response as xs:string := xdmp:get-request-field("response")
let $question as element(s:question)? := /s:question[@id eq $id]

(: This will throw an exception if the question-response ids don't match or the question is already answered :)
let $respondent as element(s:respondent) := 
	/s:question[@id eq $id]/s:responses/s:response[@id eq $response and not(s:answered)]/s:respondent

return (
	xdmp:node-insert-after(
		$respondent,
		<s:answered updated="{current-dateTime()}">{xdmp:get-current-user()}</s:answered>  
	),
	r:redirect-response(s:get-url-question($id, $response), 303)
)