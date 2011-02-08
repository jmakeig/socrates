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
import module namespace ut="http://marklogic.com/test/unit" at "lib/unit-test.xqy";

let $all-suites as xs:string* := ("test-example.xqy")
let $suites as xs:string* := if(empty(xdmp:get-request-field("suite"))) then $all-suites else xdmp:get-request-field("suite")
let $tests as xs:string* := if(empty(xdmp:get-request-field("test"))) then () else xdmp:get-request-field("test")
return ut:render($suites, $tests, "my")