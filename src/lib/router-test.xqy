xquery version "1.0-ml";
import module namespace r="http://marklogic.com/router" at "router.xqy";
declare namespace t = "test";
declare option xdmp:mapping "false";

declare function t:assert($assertion, $test) as xs:boolean {
	let $_ := xdmp:log("NEW ASSERTION")
	return 
	$assertion = $test	
};

let $r := <routes xmlns="http://marklogic.com/router">
	<route>
		<method>GET,POST</method>
		<path trailing-slash="ignore">^/questions$</path>
		<parameters>*</parameters>
		<resolution>questions.xqy$1</resolution>
	</route>
	<route>
		<method>GET</method>
		<path trailing-slash="ignore">^/questions/([0-9]{{15,25}})$</path>
		<parameters>*</parameters>
		<resolution>question.xqy?id=$1</resolution>
	</route>
	<error>nope.xqy</error>
</routes> 



(:
return (
	true()  = r:matches-path(<r:path trailing-slash="allow">^/questions$</r:path>, "/questions"),
	true()  = r:matches-path(<r:path trailing-slash="allow">^/questions$</r:path>, "/questions/"),
	false() = r:matches-path(<r:path trailing-slash="allow">^/questions$</r:path>, "/questionsX")
)
:)
(:
return
	r:matches-method($r/r:route/r:method, "POST")
:)

return ( 
	t:assert("questions.xqy", r:route($r, "/questions", "GET", "text/xml")),
	t:assert("questions.xqy", r:route($r, "/questions", "POST", "text/xml")),
	t:assert("question.xqy?id=123456789123456789", r:route($r, "/questions/123456789123456789", "GET", "text/html")),
	t:assert("question.xqy?id=123456789123456789", r:route($r, "/questions/123456789123456789/", "GET", "text/html"))
)
