xquery version "1.0-ml";
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
let $id as xs:string := xdmp:get-request-field("id")
let $response as xs:string := xdmp:get-request-field("response")
let $question as element(s:question)? := /s:question[@id eq $id]
let $rid as xs:unsignedLong := xdmp:random()
let $r as element(s:response) := 
	<s:response id="{$rid}" created="{current-dateTime()}">
		<s:respondent>{xdmp:get-current-user()}</s:respondent>
		<s:comment>{html:parse-from-string($response)}</s:comment>
	</s:response>
return (
	xdmp:node-insert-child($question/s:responses, $r),
	xdmp:set-response-code(303,""),
	xdmp:add-response-header("Location", concat("/question.xqy?id=", $id, "#response-", $rid))
)