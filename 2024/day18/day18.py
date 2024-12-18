#!/usr/bin/env python
import argh, math, rustworkx as rx, sys

StepCost = 1
def main(filename, space_size=71, count=1024):
    space = [['.'] * space_size for _ in range(space_size)]
    drops = 0
    with open(filename) as f:
        for line in f:
            x, y = [int(v) for v in line.split(',')]
            space[y][x] = '#'
            drops += 1
            if drops >= count:
                steps = steps_to_exit(space, space_size)
                if drops == count:
                    print(int(steps)) # part 1
                elif steps == math.inf:
                    print(f'{x},{y}')
                    break


def steps_to_exit(space, size):
    nodes = {}
    graph = rx.PyGraph()
    for y, row in enumerate(space):
        for x, cell in enumerate(row):
            if cell == '.':
                key = (x,y)
                if not key in nodes:
                    nodes[key] = graph.add_node(key)
                self = nodes[key]
                for (dy, dx) in [ (-1, 0), (0, 1), (1, 0), (0, -1) ]:
                    ny = y + dy
                    nx = x + dx
                    if ny in range(size) and nx in range(size):
                        if space[ny][nx] == '.':
                            neighbor_key = (nx, ny)
                            if not neighbor_key in nodes:
                                nodes[neighbor_key] = graph.add_node(neighbor_key)
                            neighbor = nodes[neighbor_key]
                            graph.add_edge(self, neighbor, StepCost)

    start = nodes[(0,0)]
    finish = nodes[(size - 1, size - 1)]
    path = rx.dijkstra_shortest_path_lengths(graph, start, lambda x: 1.0,
                                             goal=finish)
    return path[finish] if finish in path else math.inf

if __name__ == '__main__':
    argh.dispatch_command(main)
