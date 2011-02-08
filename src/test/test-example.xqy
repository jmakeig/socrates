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
module namespace my="my";
declare default function namespace "http://www.w3.org/2005/xpath-functions";
import module namespace ut="http://marklogic.com/test/unit" at "lib/unit-test.xqy";
import module namespace http-util="http://marklogic.com/util/http" at "../lib/http.xqy";
declare namespace http="xdmp:http";
declare namespace error="http://marklogic.com/xdmp/error";

declare function my:get-tests() as xs:QName* {
	for $test in (
		"test-example"
	) return QName("my", $test)
};

declare function my:test-example() {
	let $_ := xdmp:log("")
	return (
		ut:assert-equals(1, 2-1),
		ut:assert-equals(2, 2+0)
	)
};