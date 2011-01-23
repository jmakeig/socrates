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
module namespace view="http://marklogic.com/socrates/view-helpers";

declare default function namespace "http://www.w3.org/2005/xpath-functions";
declare option xdmp:mapping "false";


declare function view:page-model-create($guts as item()*, $title as xs:string?, $head as item()*) as map:map {
  let $model := map:map()
  let $_ := map:put($model, "guts", $guts)
  let $_ := map:put($model, "title", $title)
  let $_ := map:put($model, "head", $head)
  return $model
};