#!/usr/bin/env bash
skip=0
total=0
while read line; do
    case "$line" in
        ('do()') skip=0;;
        ($'don\'t()') skip=1;;
        ('mul'*) 
            if (( ! skip )); then
                read x y <<<"${line//[^0-9]/ }"
                (( total += x * y ))
            fi;;
    esac
done < <(grep -o $'mul([0-9]\{1,3\},[0-9]\{1,3\})\|do()\|don\'t()' data.txt)
echo $total
