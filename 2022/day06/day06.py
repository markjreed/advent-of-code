#!/usr/bin/env python
import sys

# read our input
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    # a line at a time
    for line in source:
        data = line.rstrip('\n')
        for part in range(2):
            size = 4 + part * 10
            for i in range(size,len(data)):
                if len(set(data[i-size:i])) == size:
                    if part:
                        print('\t',end='')
                    print(f'Part {part+1}: {i}',end='')
                    break
        print()
