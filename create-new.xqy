xquery version "1.0-ml";
declare namespace s="http://marklogic.com/socrates";
let $question as xs:string := xdmp:get-request-field("question") (: TODO: Need validation :)
let $summary as xs:string := xdmp:get-request-field("summary") (: TODO: Need validation :)
let $id as xs:string := string(xdmp:random())
let $doc := <s:question>
	<s:id>{$id}</s:id>
	<s:create-date>{current-dateTime()}</s:create-date>
	<s:create-user>{xdmp:get-current-user()}</s:create-user>
	<s:question>{$question}</s:question>
	<s:summary>{$summary}</s:summary>
	<s:responses/>
</s:question>

return (
	xdmp:document-insert(concat(xdmp:random(), ".xml"), $doc, (), ("http://marklogic.com/socrates/workflow/new")),
	xdmp:set-response-code(303,""),
	xdmp:add-response-header("Location", concat("/question.xqy?id=", $id))
)