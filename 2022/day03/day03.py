#!/usr/bin/env python
import sys

# priority: a-z=1-26, A-Z=27-52
def priority(letter):
  return (ord(letter) & 0x1f) + (26 if letter < 'a' else 0)

part1, part2 = 0, 0
group = []
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    for line in source:
        half = len(line)//2
        left, right = set(line[0:half]), set(line[half:-1])
        common = list(left.intersection(right))[0]
        part1 += priority(common)
        group.append(set(line[:-1]))
        if len(group) == 3:
           s1 = group[0].intersection(group[1])
           result = s1.intersection(group[2])
           common = list(result)[0]
           part2 += priority(common)
           group = []

print(f'Part 1: {part1}')
print(f'Part 2: {part2}')
