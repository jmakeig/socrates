while [ 1 = 1 ]
do
  curl -w '%{http_code}\n' -o /dev/null -s http://localhost:7777/questions/10588745180136696404
  sleep 1
done