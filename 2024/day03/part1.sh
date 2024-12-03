#!/usr/bin/env bash
grep -o 'mul([0-9]\{1,3\},[0-9]\{1,3\})' |
sed -e 's/[^0-9]/ /g' -e 's/$/* + /' -e '1s/+//' -e '$s/$/ p/' | dc
