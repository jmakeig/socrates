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
module namespace mvc="http://marklogic.com/mvc";
import module namespace html="http://marklogic.com/jmakeig/html" at "/Socrates/src/lib/html-utils.xqy";
declare namespace xhtml="http://www.w3.org/1999/xhtml";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare option xdmp:mapping "false";

(:
declare function mvc:render-view($name as xs:string) as item()* {
	s:render-view($name, (), ())
};

declare function mvc:render-view($name as xs:string, $model as map:map?) as item()* {
	s:render-view($name, $model, ())
};
:)
declare function mvc:render-view($name as xs:string, $model as map:map?, $errors as map:map?) as item()* {
	(:
	$name,
	xdmp:describe($model),
	xdmp:describe($errors)
	:)
	let $rendered as item() := xdmp:invoke(
		concat("/views/", $name (:, ".xqy":)),
		(xs:QName("mvc:model"), ($model, map:map())[1], xs:QName("mvc:errors"), ($errors, map:map())[1])
	)
	return
		typeswitch ($rendered)
			case element(xhtml:html) return (
				xdmp:set-response-content-type("text/html"),
				xdmp:set-response-encoding("utf-8"),
				html:html-serialize($rendered)
			)
			default return $rendered
};