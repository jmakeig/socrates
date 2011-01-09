(: 
 :	Copyright 2010-2011 Mark Logic Corporation
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
import module namespace html="http://marklogic.com/jmakeig/html" at "/lib/html-utils.xqy";
declare namespace xhtml="http://www.w3.org/1999/xhtml";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare option xdmp:mapping "false";

(::
 : Get a view, but don't render it. This is useful for views that import other views.
 :
 : @param $name
 : @param $model
 : @param $model
 : @return 
 :)
declare function mvc:get-view($name as xs:string, $model as map:map?, $errors as map:map?) as item()* {
	(: No need for another amp to get the invoke. This should only be called from within a view, so presumably the amp still holds. :)
	xdmp:invoke(
		concat("/views/", $name (:, ".xqy":)),
		(xs:QName("mvc:model"), ($model, map:map())[1], xs:QName("mvc:errors"), ($errors, map:map())[1])
	)
};

declare function mvc:render-view($name as xs:string) as item()* {
	mvc:render-view($name, (), ())
};

declare function mvc:render-view($name as xs:string, $model as map:map?) as item()* {
	mvc:render-view($name, $model, ())
};

(: Amped to socrates-internal :)
declare function mvc:render-view($name as xs:string, $model as map:map?, $errors as map:map?) as item()* {
	let $rendered as item()* := mvc:get-view($name, $model, $errors)
	return
		typeswitch ($rendered)
			case element(xhtml:html) return (
				xdmp:set-response-content-type("text/html"),
				xdmp:set-response-encoding("utf-8"),
				html:html-serialize($rendered)
			)
			default return $rendered
};

(::
 : Utility to create a map in one line.
 :
 : @param $key
 : @param $value
 : @return 
 :)
declare function mvc:model-create($key as xs:string, $value as item()*) as map:map {
	let $model as map:map := map:map()
	return (
		map:put($model, $key, $value), 
		$model
	)
};

declare function mvc:model-put($model as map:map, $key as xs:string, $value as item()*) as map:map {
	let $_ as empty-sequence() := map:put($model, $key, $value)
	return $model
};
