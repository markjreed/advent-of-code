#!/usr/bin/env python
import sys
picture = []
moves = []
labels = None
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    for line in source:
        row = line.rstrip('\n')
        cols = row.split()
        if len(cols) and cols[0].isnumeric():
            labels = cols
        elif labels:
            if len(row):
                moves.append(row)
        else:
            picture.append([row[i] for i in range(1,len(line),4)])

start = [[crate for crate in stack if crate != ' '] for stack in zip(*picture)]

for part in range(1,3):
    stacks = { label: stack.copy() for label, stack in zip(labels, start) }

    for move in moves:
        words = move.split()
        count, source, dest = [words[i] for i in range(1,6,2)]
        n = int(count)
        if part == 1:
            for _ in range(n):
                stacks[dest].insert(0,stacks[source].pop(0))
        else:
            stacks[dest] = stacks[source][:n] + stacks[dest]
            stacks[source]  = stacks[source][n:]

    print(f'Part {part}: {"".join([stacks[k][0] for k in sorted(stacks)])}')
