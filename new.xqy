xquery version "1.0-ml";
import module namespace html="http://marklogic.com/jmakeig/html" at "lib/html-utils.xqy";
declare namespace x="http://www.w3.org/1999/xhtml";
xdmp:set-response-content-type("text/html"),
xdmp:set-response-encoding("utf-8"),
html:html-serialize(
<html xmlns="http://www.w3.org/1999/xhtml"> 
	<head>
		<title>New question…</title>
		<link href="/assets/browser.css" rel="stylesheet" type="text/css"/>
	</head>
	<body>
		<h1>New question</h1>
		<form action="create-new.xqy" method="post">
			<div class="control">
		    <div class="label">
		      <label for="question">Question</label>
		    </div>
		    <div class="input">
	        <textarea name="question" id="question"/>
		    </div>
			</div>
			<div class="control">
		    <div class="label">
		      <label for="summary">Short summary</label>
		    </div>
		    <div class="input">
	        <input type="text" name="summary" id="summary"/>
		    </div>
			</div>
			<div class="actions">
				<button>Create…</button>
			</div>
		</form>
	</body>
</html>
)