#!/usr/bin/env python
import fileinput
pos, depth = 0, 0
for line in fileinput.input():
  command, value = line.split()
  match command:
    case 'forward':
      pos += int(value)
    case 'down':
      depth += int(value)
    case 'up':
      depth -= int(value)

print(pos * depth)
