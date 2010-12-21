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
		<script src="/assets/lib/showdown-0.9-debug.js" type="text/javascript"/>
	</head>
	<body>
		<h1>New question</h1>
		<!-- TODO: Extract this out -->
		<form action="create-new.xqy" method="post"
			onsubmit="var markup=(new Showdown.converter()).makeHtml(document.getElementById('question').value); document.getElementById('markup').value=markup;">
			<div class="control">
		    <div class="label">
		      <label for="question">Question</label>
		    </div>
		    <div class="input">
		    	<div class="front">
		        <textarea id="question"/>
		        <textarea name="question" id="markup" style="height: 20em;"/>
		        <div><a id="preview">Preview…</a></div>
	        </div>
	        <div class="back">
			    	OUTPUT
			    </div>
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
				<button onclick="var markup=(new Showdown.converter()).makeHtml(document.getElementById('question').value); document.getElementById('markup').value=markup; return false;">Preview</button>
			</div>
		</form>
	</body>
</html>
)