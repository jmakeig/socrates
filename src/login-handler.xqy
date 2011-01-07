xquery version "1.0-ml";
import module namespace r="http://marklogic.com/router" at "/lib/router.xqy";
import module namespace mvc="http://marklogic.com/mvc" at "/lib/mvc.xqy";
declare option xdmp:mapping "false";

let $user as xs:string := xdmp:get-request-field("user")
let $password as xs:string := xdmp:get-request-field("password")
let $login as xs:boolean := xdmp:login(
	$user,
	$password,
	true()
)
return if($login) then 
	let $target as xs:string := (
		(: When a privileged request is intercepted :)
		xdmp:get-session-field("login-referrer"),
		(: When the user explicitly asks to login :)
		xdmp:get-request-field("referer"),
		(: Other :)
		"/"
	)[1]
	let $_ := xdmp:set-session-field("login-referrer",())
	return r:redirect-response($target, 303)
else (
  xdmp:set-response-code(400, "Invalid Login Credentials"),
	mvc:render-view("login.html", (), map:map(
		<map:map xmlns:map="http://marklogic.com/xdmp/map">
			<map:entry>
				<map:key>failed-login</map:key>
				<map:value>Something fudged up</map:value>
			</map:entry>
		</map:map>
		)
	)
)
