#!/usr/bin/env python
import sys

def to_range(spec):
    low, high = map(int, spec.split('-'))
    return range(low, high+1)

part1 = part2 = 0
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    for line in source:
        left, right = [set(to_range(spec)) for spec in line.split(',')]
        if left.issubset(right) or right.issubset(left):
            part1 += 1
        if left.intersection(right):
            part2 += 1

print(f'Part 1: {part1}')
print(f'Part 2: {part2}')

