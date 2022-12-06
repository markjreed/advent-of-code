#!/usr/bin/env python
import sys

picture = []
moves = []
labels = None

# read our input
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    # a line at a time
    for line in source:
        row = line.rstrip('\n')
        cols = row.split()

        if len(cols) and cols[0].isnumeric():
            # remember the stack labels
            labels = cols
        elif labels:
            # if we've seen the labels and the line isn't blank
            if len(row):
                # then this is a move instruction; parse out its parameters
                moves.append([cols[i] for i in range(1,6,2)])
        else:
            # if we haven't seen the labels yet, this is part of the picture
            # represetnting the starting configuration
            picture.append([row[i] for i in range(1, len(line), 4)])

# transpose starting configuration so each stack is a list
start = [[crate for crate in stack if crate != ' '] for stack in zip(*picture)]

# run the simulation twice, once for each part
for part in range(2):

    # reset to starting config at top of sim
    stacks = {label: stack.copy() for label, stack in zip(labels, start)}

    # then execute the moves
    for count, source, dest in moves:
        n = int(count)
        if not part:
            # for part 1, move one crate at a time
            for _ in range(n):
                stacks[dest].insert(0, stacks[source].pop(0))
        else:
            # for part 2, move all N crates at once
            stacks[dest] = stacks[source][:n] + stacks[dest]
            stacks[source] = stacks[source][n:]

    print(f'Part {part}: {"".join([stacks[k][0] for k in sorted(stacks)])}')
