xquery version "1.0-ml";
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
declare namespace s="http://marklogic.com/socrates";
let $id as xs:string := xdmp:get-request-field("id")
let $question as element(s:question)? := /s:question[s:id eq $id]
return (
	xdmp:set-response-content-type("text/html"),
	xdmp:set-response-encoding("utf-8"),
	html:html-serialize(
	<html xmlns="http://www.w3.org/1999/xhtml"> 
		<head>
			<title>{data($question/s:summary)}</title>
			<link href="/assets/browser.css" rel="stylesheet" type="text/css"/>
		</head>
		<body>
			<h1>{data($question/s:summary)}</h1>
			<div>{(xdmp:log($question), $question/s:question/node())}</div>
			<form action="add-response.xqy?id={$id}" method="post">
				<div class="control">
			    <div class="label">
			      <label for="question">Respond</label>
			    </div>
			    <div class="input">
		        <textarea name="response" id="response"/>
			    </div>
				</div>
				<div><button>Add…</button></div>
			</form>
			{for $response in $question/s:responses/s:response
			order by $response/s:response-create-date descending
			return <div class="response">
				<div>{format-dateTime($response/s:response-create-date, "[MNn] [D], [Y], [h]:[m01] [PN]", "en", (), ())}</div>
				<p>{data($response/s:comment)}</p>
			</div>}
			<div class="actions">
				<ul><li><a href="/new.xqy">New</a></li><li><a href="/questions.xqy">All</a></li></ul></div>
		</body>
	</html>
	)
)