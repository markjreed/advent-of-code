#!/usr/bin/env python
import sys


def to_range(spec):
    low, high = map(int, spec.split('-'))
    return range(low, high+1)


part1 = part2 = 0
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    data = [[set(to_range(spec)) for spec in line.split(',')]
            for line in source]

part1 = sum([left.issubset(right) or right.issubset(left)
             for left, right in data])
part2 = sum([bool(left.intersection(right)) for left, right in data])

print(f'Part 1: {part1}')
print(f'Part 2: {part2}')
