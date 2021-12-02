#!/usr/bin/env python
import fileinput
aim, pos, depth = 0, 0, 0
for line in fileinput.input():
  command, value = line.split()
  match command:
    case 'forward':
      pos += int(value)
      depth += aim * int(value)
    case 'down':
      aim += int(value)
    case 'up':
      aim -= int(value)

print(pos * depth)
