xquery version "1.0-ml";
module namespace s="http://marklogic.com/socrates";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare variable $s:DATE_FORMAT as xs:string := "[MNn] [D], [Y], [h]:[m01] [PN]";

declare function s:get-url-question($id as xs:string, $response as xs:string?) as xs:string {
	concat("/question.xqy?id=", escape-html-uri($id), 
		if($response) then concat("#response-", $response) else "")
};
declare function s:get-url-question($id as xs:string) as xs:string {
	s:get-url-question($id, ())
};
declare function s:get-url-questions($query as xs:string?) as xs:string {
	concat("/questions.xqy?", 
		if($query) then concat("?q=", escape-html-uri($query)) else ""
	)
};
declare function s:get-url-questions() as xs:string {
	s:get-url-questions(())
};

declare function s:get-url-question-new($id as xs:string) as xs:string {
	"/new.xqy"
};

