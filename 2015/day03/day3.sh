#!/usr/bin/env bash
main() {
    local input_file=${1--} 
    local x1=(0)   y1=(0)   # Just one deliverer in part 1
    local x2=(0 0) y2=(0 0) # Two deliverers in part 2
    local -A part1 part2 i j
    for i in "${!x1[@]}"; do
        local x=${x1[i]} y=${y1[i]}
        (( part1[$x,$y]++ ))
    done
    for j in "${!x2[@]}"; do
        local x=${x2[j]} y=${y2[j]}
        (( part2[$x,$y]++ ))
    done

    local turn=0
    while read dir; do
        (( i = turn % ${#x1[@]} ))
        (( j = turn % ${#x2[@]} ))
        case "$dir" in
            '^') (( y1[i]+=1, y2[j]+=1 ));;
            '>') (( x1[i]+=1, x2[j]+=1 ));;
            'v') (( y1[i]-=1, y2[j]-=1 ));;
            '<') (( x1[i]-=1, x2[j]-=1 ));;
        esac
        (( part1["${x1[i]},${y1[i]}"]++ ))
        (( part2["${x2[j]},${y2[j]}"]++ ))
        (( turn += 1 ))
    done < <(grep -o . "$input_file")
    printf '%d\n' "${#part1[@]}"
    printf '%d\n' "${#part2[@]}"
}

main "$@"
