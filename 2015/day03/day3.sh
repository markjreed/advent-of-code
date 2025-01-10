#!/usr/bin/env bash
main() {
    local input_file=${1--} x=0 y=0 dir
    local -A gifts=(["0,0"]=1)
    while read dir; do
        case "$dir" in
            '^') (( y+=1 ));;
            '>') (( x+=1 ));;
            'v') (( y-=1 ));;
            '<') (( x-=1 ));;
        esac
        (( gifts["$x,$y"]++ ))
    done < <(grep -o . "$input_file")
    printf '%d\n' "${#gifts[@]}"
}

main "$@"
