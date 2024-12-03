#!/usr/bin/env bash
(
    echo 0
    grep -o $'mul([0-9]\\{1,3\\},[0-9]\\{1,3\\})\\|do()\\|don\'t()' | 
        sed -e "/don't/,/do(/d" -e '/do(/d' -e 's/[^0-9]/ /g' -e 's/$/ * +/'
    echo p
) | dc
