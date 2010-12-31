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
import module namespace html="http://marklogic.com/jmakeig/html" at "/Socrates/src/lib/html-utils.xqy";
import module namespace s="http://marklogic.com/socrates" at "lib/socrates.xqy";
declare namespace x="http://www.w3.org/1999/xhtml";
declare option xdmp:mapping "false";

xdmp:set-response-content-type("text/html"),
xdmp:set-response-encoding("utf-8"),
html:html-serialize(
<html xmlns="http://www.w3.org/1999/xhtml"> 
	<head>
		<title>Login</title>
		<link href="/assets/browser.css" rel="stylesheet" type="text/css"/>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"/>
		<script src="/assets/lib/showdown-0.9-debug.js" type="text/javascript"/>
		<script src="/assets/question.js" type="text/javascript"/>
		<script type="text/javascript">
			$(document).ready(function() {{
				var editor = new ML.Editor($("#question"), $("#markup"), $("#preview"));
			}});
		</script>
	</head>
	<body>
		<header>Welcome, {xdmp:get-current-user()}</header>
		<h1>New question</h1>
		<!-- TODO: Extract this out -->
		<form id="new-question" action="{s:get-url-login()}" method="post">
			<div class="control editor">
		    <div class="label">
		      <label for="user">Name</label>
		    </div>
		    <div class="input">
		    	<div class="front">
						<input name="user" id="user" />
	        </div>
		    </div>
			</div>
			<div class="control editor">
		    <div class="label">
		      <label for="password">Password</label>
		    </div>
		    <div class="input">
		    	<div class="front">
						<input type="password" name="password" id="password" />
	        </div>
		    </div>
			</div>
			<div class="actions">
				<button>Login</button>
			</div>
		</form>
	</body>
</html>
)