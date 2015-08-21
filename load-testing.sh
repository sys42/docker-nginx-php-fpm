#!/bin/bash

trap ctrl_c INT

export count=0

ctrl_c () {
   echo "** Trapped CTRL-C **"
   echo "count=$count"
   exit 0
}


while true; do
  curl -s http://localhost:30000/info.php > /dev/null
  count=$((count+1))
done
