#!/usr/bin/env python

import re, sys

def main(filename):
    part1 = [ [0] * 1000 for _ in range(1000) ]
    part2 = [ [0] * 1000 for _ in range(1000) ]

    pattern = re.compile(r"""(?x)
        (.*\S) \s+ (\d+) , (\d+) \s + through \s+ (\d+) , (\d+)
    """)
    
    with open(filename) as f:
        for line in f:
            if m := pattern.match(line):
                (action, x1, y1, x2, y2) = m.groups()
                for y in range(int(y1), int(y2)+1):
                    for x in range(int(x1), int(x2)+1):
                        match action:
                            case 'turn off': 
                                part1[x][y] = 0
                                part2[x][y] = max(part2[x][y]-1, 0)
                            case 'turn on':
                                part1[x][y] = 1
                                part2[x][y] += 1
                            case 'toggle':
                                part1[x][y] = 1 - part1[x][y]
                                part2[x][y] += 2

    print(sum([sum(row) for row in part1]))
    print(sum([sum(row) for row in part2]))

main(sys.argv[1])
