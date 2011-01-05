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

let $question as xs:string := xdmp:get-request-field("question") (: TODO: Need validation :)
let $summary as xs:string := xdmp:get-request-field("summary") (: TODO: Need validation :)
let $id as xs:string := string(xdmp:random())
let $doc as element(s:question):= 
	<s:question id="{$id}" create-date="{current-dateTime()}">
		<s:asker>{xdmp:get-current-user()}</s:asker>
		<s:detail>{html:parse-from-string($question)}</s:detail>
		<s:summary>{$summary}</s:summary>
		<s:responses/>
	</s:question>

return (
	xdmp:document-insert(
		(: TODO: Give a base URI so it can be secured with URI privs :)
		concat(xdmp:random(), ".xml"), 
		$doc, 
		(xdmp:default-permissions()(:xdmp:permission("socrates-contributor", "read"), xdmp:permission("socrates-contributor", "update"):)), 
		("http://marklogic.com/socrates/workflow/new")
	),
	(:xdmp:set-response-code(303,""),
	xdmp:add-response-header("Location", s:get-url-question($id)):)
	xdmp:redirect-response(s:get-url-question($id))
)