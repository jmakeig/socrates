xquery version "1.0-ml";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";

declare function s:route($url, $patterns as xs:string*, $replacements as xs:string*) {
	let $route := replace($url, $patterns[1], $replacements[1])
	return 
		(: If nothing was replaced then continue. This doesn't cover the general case. :)
		if($route eq $url) then
			s:route($url, subsequence($patterns, 2), subsequence($replacements, 2))
		else $route
};

let $url as xs:string := xdmp:get-request-url()
let $method as xs:string := xdmp:get-request-method()
let $_ := xdmp:log($url)  
return
	if(matches($url, "^/assets/")) then $url
	else 
		let $route := s:route($url, 
			("^/questions/?(\?.+)?$", "^/questions/new/?$", "^/questions/([0-9]{19})/?$", "^/questions/([0-9]{19})/responses/?$",  "^/users/([^/]+)/?"),
			("questions.xqy$1",       "new.xqy",            "question.xqy?id=$1",         "add-response.xqy?id=$1",                      "/users.xqy?id=$1")
		)
		let $_ := xdmp:log(string-join(($url, $method, $route), ", "))
		return 
			if($route) then 
				if($route eq "questions.xqy" and $method eq "POST") then "create-new.xqy"
				else $route 
			else concat("error.xqy?url=", $url, "&amp;status=404")
	(:
	else if(matches($url, "^/questions/?(\?.+)?$")) then replace($url, "^/questions/?(\?.+)?$", "questions.xqy$1")
	else if(matches($url, "^/questions/new/?$")) then "new.xqy"
	else if(matches($url, "^/questions/([0-9]{19})/?")) then replace($url, "^/questions/([0-9]{19})/?", "question.xqy?id=$1")
	else "asdf.xqy"
	:)