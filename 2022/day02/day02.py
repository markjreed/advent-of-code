#!/usr/bin/env python
import sys
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    matches = [3*'ABC'.index(e)+'XYZ'.index(h) for e,h in [line[:-1].split(' ')
                                               for line in source]]
Part1=[4, 8, 3, 1, 5, 9, 7, 2, 6]
Part2=[3, 4, 8, 1, 5, 9, 2, 6, 7]
print(f'Part 1: {sum([Part1[m] for m in matches])}')
print(f'Part 2: {sum([Part2[m] for m in matches])}')
