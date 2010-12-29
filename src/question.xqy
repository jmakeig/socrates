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
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
let $id as xs:string := xdmp:get-request-field("id")
let $question as element(s:question)? := /s:question[@id eq $id]
let $_ := xdmp:log("asdf")
return (
	xdmp:set-response-content-type("text/html"),
	xdmp:set-response-encoding("utf-8"),
	html:html-serialize(
	<html xmlns="http://www.w3.org/1999/xhtml"> 
		<head>
			<title>{data($question/s:summary)}</title>
			<link href="/assets/browser.css" rel="stylesheet" type="text/css"/>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"/>
			<script src="/assets/lib/showdown-0.9-debug.js" type="text/javascript"/>
			<script src="/assets/question.js" type="text/javascript"/>
			<script type="text/javascript">
				$(document).ready(function() {{
					var editor = new ML.Editor($("#response"), $("#markup"), $("#preview"));
				}});
			</script>
		</head>
		<body>
			<h1>{data($question/s:summary)}</h1>
			<div>{(xdmp:log($question), $question/s:detail/*)}</div>
			<form action="{s:get-url-responses($id)}" method="post" class="new-response">
				<div class="control editor">
		    <div class="label">
		      <label for="question">Contribute a Response</label>
		      <div class="guide"><a class="preview-action">Preview →</a></div>
		    </div>
		    <div class="input">
		    	<div class="front">
		        <textarea id="response"/>
						<input type="hidden" name="response" id="markup" />
	        </div>
	        <div class="back">
			    	<div id="preview"/>
			    </div>
		    </div>
			</div>
				<div><button>Add…</button></div>
			</form>
			{for $response in $question/s:responses/s:response
			order by $response/@created descending
			return 
				<div class="response" id="response-{data($response/@id)}">
					<div class="respondent">Response from  
						<a href="{s:get-url-user($response/s:respondent)}">{data($response/s:respondent)}</a>
					</div>
					<div class="date">{format-dateTime($response/@created, $s:DATE_FORMAT)}</div>
					<div class="comment">{$response/s:comment/*}</div>
				</div>}
			<div class="actions">
				<ul><li><a href="{s:get-url-question-new()}">New</a></li><li><a href="{s:get-url-questions()}">All</a></li></ul>
			</div>
		</body>
	</html>
	)
)