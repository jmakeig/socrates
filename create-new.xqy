xquery version "1.0-ml";
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
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
	xdmp:document-insert(concat(xdmp:random(), ".xml"), $doc, (), ("http://marklogic.com/socrates/workflow/new")),
	xdmp:set-response-code(303,""),
	xdmp:add-response-header("Location", concat("/question.xqy?id=", $id))
)