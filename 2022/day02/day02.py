#!/usr/bin/env python
import sys
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    matches = [3*'ABC'.index(e)+'XYZ'.index(h) for e,h in [line[:-1].split(' ')
                                               for line in source]]
# See notes.txt for derivation of score formulas
Part1 = [3 * ((h - e + 1)%3) + h + 1 for e in range(3) for h in range(3)]
Part2 = [3 * h + (e + h + 2) % 3 + 1 for e in range(3) for h in range(3)]
print(f'Part 1: {sum([Part1[m] for m in matches])}')
print(f'Part 2: {sum([Part2[m] for m in matches])}')
