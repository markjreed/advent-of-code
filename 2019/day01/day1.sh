#!/usr/bin/env bash
t=0
while read m; do
   (( f = m / 3 - 2 ))
   while (( f > 0 )); do
       (( t += f ))
       (( f = f / 3 - 2 ))
   done
done
echo $t
