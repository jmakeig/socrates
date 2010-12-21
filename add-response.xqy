xquery version "1.0-ml";
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
declare namespace s="http://marklogic.com/socrates";
let $id as xs:string := xdmp:get-request-field("id")
let $response as xs:string := xdmp:get-request-field("response")
let $question as element(s:question)? := /s:question[s:id eq $id]
return (
	xdmp:node-insert-child($question/s:responses, <s:response>
		<s:response-create-date>{current-dateTime()}</s:response-create-date>
		<s:comment>{$response}</s:comment>
	</s:response>),
	xdmp:set-response-code(303,""),
	xdmp:add-response-header("Location", concat("/question.xqy?id=", $id))
)