xquery version "1.0-ml";
import module namespace r="http://marklogic.com/router" at "/Socrates/src/lib/router.xqy";
declare option xdmp:mapping "false";

xdmp:logout(),
r:redirect-response("/", 303)