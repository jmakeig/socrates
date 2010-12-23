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
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"/>
		<script src="/assets/question.js" type="text/javascript"/>
	</head>
	<body>
		<h1>New question</h1>
		<!-- TODO: Extract this out -->
		<form id="new-question" action="create-new.xqy" method="post"
			onsubmit="">
			<div class="control editor">
		    <div class="label">
		      <label for="question">Question</label>
		      <div class="guide"><a class="preview-action">Preview →</a></div>
		    </div>
		    <div class="input">
		    	<div class="front">
		        <textarea id="question"/>
						<input type="hidden" name="question" id="markup" />
	        </div>
	        <div class="back">
			    	<div id="preview"></div>
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
			</div>
		</form>
	</body>
</html>
)