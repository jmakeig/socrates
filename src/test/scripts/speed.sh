#! /bin/bash

curl -w '%{url_effective}\n%{http_code}\nLookup time:\t%{time_namelookup}\nConnect time:\t%{time_connect}\nPreXfer time:\t%{time_pretransfer}\nStartXfer time:\t%{time_starttransfer}\n\nTotal time:\t%{time_total}\n' -o /dev/null -s http://localhost:7777/questions/14187616848594887194