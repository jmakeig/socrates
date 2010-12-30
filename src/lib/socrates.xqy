(: 
 :	Copyright 2008-2010 Mark Logic Corporation
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
module namespace s="http://marklogic.com/socrates";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare variable $s:DATE_FORMAT as xs:string := "[MNn] [D], [Y], [h]:[m01] [PN]";

declare function s:get-url-question($id as xs:string, $response as xs:string?) as xs:string {
	(:concat("/question.xqy?id=", escape-html-uri($id), 
		if($response) then concat("#response-", $response) else ""):)
	concat(s:get-url-questions(), "/", escape-html-uri($id), 
		if($response) then concat("#response-", $response) else "")
};
declare function s:get-url-question($id as xs:string) as xs:string {
	s:get-url-question($id, ())
};
declare function s:get-url-responses($question as xs:string) as xs:string {
	concat(s:get-url-question($question), "/responses")
};
declare function s:get-url-questions($query as xs:string?) as xs:string {
	(:
	concat("/questions.xqy?", 
		if($query) then concat("?q=", escape-html-uri($query)) else ""
	)
	:)
	concat(
		"/questions", 
		if($query) then concat("?q=", escape-html-uri($query)) else ""
	) 
};
declare function s:get-url-questions() as xs:string {
	s:get-url-questions(())
};

declare function s:get-url-question-new() as xs:string {
	(:"/new.xqy":)
	concat(s:get-url-questions(), "/new")
};
declare function s:get-url-users() as xs:string {
	"/users"
};
declare function s:get-url-user($id as xs:string) as xs:string {
	concat(s:get-url-users(), "/", escape-html-uri($id))
};
