#!/usr/bin/env python
import sys
from functools import reduce

# priority: a-z=1-26, A-Z=27-52
def priority(letter):
    return (ord(letter) & 0x1f) + (26 if letter < 'a' else 0)


part1, part2 = 0, 0
group = []
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    for line in source:
        # part 1
        half = len(line[:-1]) // 2
        left, right = set(line[0:half]), set(line[half:-1])
        common = list(left.intersection(right))[0]
        part1 += priority(common)

        # part 2
        group.append(set(line[:-1]))
        if len(group) == 3:
            common = list(reduce(lambda s1, s2: s1.intersection(s2), group))[0]
            part2 += priority(common)
            group = []

print(f'Part 1: {part1}')
print(f'Part 2: {part2}')
