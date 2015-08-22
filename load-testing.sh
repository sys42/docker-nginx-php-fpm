#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 url-to-test"
  echo "loops forever using curl to fetch data from given url"
  echo
  echo "example: $0 http://localhost:30000/info.php"
  exit 1
fi

echo "url = $1"
echo "[press Ctrl+C to stop]"
echo

trap ctrl_c INT

calls=0
bytes=0
page="$1"

starttime=$(($(date +%s%N)/1000000))

getStatistics () {
   millis=$(($(date +%s%N)/1000000 - starttime))
   runtime=$(awk "BEGIN {printf \"%.2f\",${millis}/1000}" 2>/dev/null)
   ## may run into div zero errors -> i don't care ...
   callspersec=$(awk "BEGIN {printf \"%.2f\",${calls}/${runtime}}" 2>/dev/null)
   kbpersec=$(awk "BEGIN {printf \"%.2f\",${bytes}/(${runtime}*1024)}" 2>/dev/null)
   mbs=$(awk "BEGIN {printf \"%.2f\",${bytes}/(1024*1024)}" 2>/dev/null)
   echo "#$calls | $callspersec #/s | $kbpersec kB/s | time: ${runtime}s | i/o: $mbs MB"
}

ctrl_c () {
   echo "** Trapped CTRL-C **"
   echo "$(getStatistics)"
   exit 0
}

while true; do
  _bytes=$(curl -s "$page" | wc --bytes)
  bytes=$((bytes+_bytes))
  calls=$((calls+1))
  [ $(( calls % 10 )) -eq 0 ] && echo -en "\033[s$(getStatistics)\033[u"
done
