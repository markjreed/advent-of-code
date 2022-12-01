#!/usr/bin/env python
import fileinput, math
risk = [[int(digit) for digit in line[:-1]] for line in fileinput.input()] 
height = len(risk)
width =  len(risk[0])

def find_path(risk, height, width):
    dist = []
    for _ in range(height):
        dist.append([ math.inf ] * width)
    queue = [ (0,0) ]
    dist[0][0] = 0
    while len(queue) > 0:
        i, j = queue.pop(0)
        for ni,nj in (i-1,j), (i,j-1), (i,j+1), (i+1,j):
            if ni < 0 or ni >= len(risk) or nj < 0 or nj >= len(risk[ni]):
                continue
            d = dist[i][j] + risk[ni][nj]
            if d < dist[ni][nj]:
                dist[ni][nj] = d
                queue.append((ni,nj))
    return dist[height-1][width-1]

print(find_path(risk, height, width))

# Build the bigger map
for y in range(5):
    for x in range(5):
        if not(x or y):
            continue
        for i0 in range(height):
            i = i0 + y * height
            while len(risk) < i+1:
                risk.append([])
            for j0 in range(width):
                j = j0 + x * width
                while len(risk[i]) < j+1:
                    risk[i].append([])
                risk[i][j] = (risk[i0][j0] + x + y - 1) % 9 + 1

height = len(risk)
width =  len(risk[0])
print(find_path(risk, height, width))
