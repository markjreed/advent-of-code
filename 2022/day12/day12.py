#!/usr/bin/env python
from collections import defaultdict
import sys

with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    elevation_map = [line for line in source]

def elevation(letter):
    if letter == 'S':
        letter = 'a'
    elif letter == 'E':
        letter = 'z'
    return ord(letter) - ord('a')

alternates = []
edges = defaultdict(lambda: [])

for i, row in enumerate(elevation_map):
    for j, letter in enumerate(row):
        coords = (i, j)
        if letter == 'S':
            start = coords
        elif letter == 'E':
            end = coords
        elif letter == 'a':
            alternates.append(coords)

        level = elevation(letter)
        for di, dj in ((-1,0),(0,1),(1,0),(0,-1)):
            ni = i + di
            if 0 <= ni  and ni < len(elevation_map):
                nj = j + dj
                if 0 <= nj and nj < len(elevation_map[ni]):
                    nlevel = elevation(elevation_map[ni][nj])
                    if nlevel <= level + 1:
                        edges[coords].append((ni,nj))

for part in range(2):
    heads = set([start])
    if part:
        heads = heads.union(alternates)

    distance = 0;
    while not end in heads:
        distance += 1
        new_heads = heads.copy()
        for node in heads:
            for neighbor in edges[node]:
                new_heads.add(neighbor)
        heads = new_heads

    print(f'Part {part+1}: {distance}')
