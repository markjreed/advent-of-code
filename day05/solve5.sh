#!/usr/bin/env bash
task=1
if [[ $1 = -* ]]; then
  task=${1#-}
  shift
fi
cat "$@" | tr FBLR 0101 | sed 's/.*/2i & p/'  | dc | sort -n  |
  if (( task == 1 )); then  
    printf 'max: '
    tail -n 1
  else
    printf 'missing: '
    showranges -i | tail -n +2
  fi
