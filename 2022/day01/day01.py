#!/usr/bin/env python
import sys
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    elves = [sum([int(n) for n in elf.split("\n") if len(n)])
                         for elf in source.read().split("\n\n")]
print(f'Part 1:{max(elves)}')
print(f'Part 2:{sum(sorted(elves,reverse=True)[0:3])}')
