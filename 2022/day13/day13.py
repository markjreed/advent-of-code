#!/usr/bin/env python
from collections import defaultdict
from functools import cmp_to_key, reduce
import sys

with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    pairs = [[eval(p) for p in pair.split("\n") if p]
                      for pair in source.read().split("\n\n")]

def compare(left, right):
    if isinstance(left, int) and isinstance(right, int):
        if left == right:
            return 0
        elif left > right:
            return 1
        else:
            return -1
    
    if isinstance(left, list) and isinstance(right, list):
        if len(left) == 0 and len(right) > 0:
            return -1
        elif len(right) == 0 and len(left) > 0:
            return 1
        elif len(left) == 0:
            return 0
    
        if result := compare(left[0], right[0]):
            return result
        return compare(left[1:], right[1:])
    
    if isinstance(left, int) and isinstance(right, list):
        return compare([left], right)
    
    if isinstance(left, list) and isinstance(right, int):
        return compare(left, [right])

def in_order(left, right):
    return (compare(left,right) == -1)

total = 0
for index, (left, right) in enumerate(pairs):
    if in_order(left, right):
        total += index + 1

print(f'Part 1: {total}')
dividers = [ [[2]], [[6]] ]
packets = sorted([p for pair in pairs for p in pair] + dividers, 
                 key=cmp_to_key(compare))
part2 = reduce(lambda a,b: a*b, 
               map(lambda p: packets.index(p)+1, dividers))
print(f'Part 2: {part2}')
