#!/usr/bin/env awk -f
prev && $1 > prev { inc++ }
{ prev = $1 }
END { print inc }
