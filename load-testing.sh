#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 url-to-test"
  echo
  echo "example: $0 http://localhost:30000/info.php"
  exit 1
fi

echo "[press Ctrl+C to stop]"
echo

trap ctrl_c INT

count=0
page="$1"

starttime=$(($(date +%s%N)/1000000))


getStatistics () {
   millis=$(($(date +%s%N)/1000000 - starttime))
   runtime=$(awk "BEGIN {printf \"%.2f\",${millis}/1000}")

   ## may run into div zero error -> i don't care ...
   persec=$(awk "BEGIN {printf \"%.2f\",${count}/${runtime}}") 2>&1 >/dev/null

   echo "#$count | $persec #/s | time: ${runtime}s"
}

ctrl_c () {
   echo "** Trapped CTRL-C **"
   echo "$(getStatistics)"
   exit 0
}


while true; do
  curl -s $page > /dev/null
  count=$((count+1))
  if [ $(( count % 10 )) -eq 0 ]; then      
     echo -en "\033[s$(getStatistics)\033[u"
  fi
done
