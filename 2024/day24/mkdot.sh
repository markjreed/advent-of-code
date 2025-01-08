printf 'graph {\n'
x=() y=()
(( printed = 0, gate = 0 ))

while read line; do
    if [[ $line =~ (x[0-9]*):\ [10] ]]; then
        x+=(${BASH_REMATCH[1]})
    elif [[ $line =~ (y[0-9]*):\ [10] ]]; then
        y+=(${BASH_REMATCH[1]})
    elif [[ $line =~ ([a-z0-9]*)\ (AND|OR|XOR)\ ([a-z0-9]*)\ -\>\ ([a-z0-9]*) ]]; then
        if (( ! printed )); then 
            printf '    {%s}\n' "${x[*]}"
            printf '    {%s}\n' "${y[*]}"
            (( printed = 1 ))
        fi
        printf '%s_%03d[shape=box]\n' "${BASH_REMATCH[2]}" "$gate"
        printf '{%s %s} -- %s_%03d\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[2]}" "$gate"
        printf '%s_%03d -- %s\n' "${BASH_REMATCH[2]}" "$gate" "${BASH_REMATCH[4]}"
        (( gate++ ))
    fi
done 
printf '}\n'
