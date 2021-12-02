#!/usr/bin/env awk -f
a && b {
  sum = a + b + $1
  if (prev && sum > prev) { inc++ }
  prev = sum
}
{ a = b; b = $1 }
END { print inc }
