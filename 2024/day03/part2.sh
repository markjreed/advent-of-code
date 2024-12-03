#!/usr/bin/env bash
total=0
doing=1
while read line; do
    case "$line" in
        ('do()') doing=1;;
        ($'don\'t()') doing=0;;
        ('mul'*) 
            if (( doing )); then
                read x y <<<"${line//[^0-9]/ }"
                (( total += x * y ))
            fi;;
    esac
done < <(grep -o $'mul([0-9]\{1,3\},[0-9]\{1,3\})\|do()\|don\'t()')
echo $total
