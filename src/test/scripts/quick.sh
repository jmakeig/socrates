#! /bin/bash
curl -w '%{http_code}\t%{time_total}\t%{url_effective}\n' -o /dev/null -s http://localhost:7777/questions
curl -w '%{http_code}\t%{time_total}\t%{url_effective}\n' -o /dev/null -s http://localhost:7777/questions/10588745180136696404
curl -w '%{http_code}\t%{time_total}\t%{url_effective}\n' -o /dev/null -s http://localhost:7777/login