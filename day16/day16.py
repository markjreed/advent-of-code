#!/usr/bin/env python
import math, rustworkx as rx, sys

TurnCost = 1000
StepCost = 1

def main(filename, start_dir=1):
    maze = []
    with open(filename) as f:
        for line in f:
            maze.append(list(line[:-1]))

    start_at = None
    end_at = None
    occupiable = []
    for i, row in enumerate(maze):
        for j, cell in enumerate(row):
            if cell == 'S':
                start_at = i,j
                occupiable.append((i,j))
            elif cell == 'E':
                end_at = i,j
                occupiable.append((i,j))
            elif cell == '.':
                occupiable.append((i,j))
    
    dirs = [ (-1,0), (0,1), (1,0), (0,-1) ];
    
    graph = rx.PyDiGraph()
    nodes = {}
    for (i,j) in occupiable:
        for d in range(4):
            key = (i,j,d)
            if not key in nodes:
                nodes[key] = graph.add_node(key)
            self = nodes[key]

            for t in [ (d-1) % 4, (d + 1) % 4 ]:
                neighbor_key = (i, j, t)
                if not neighbor_key in nodes:
                    nodes[neighbor_key] = graph.add_node(neighbor_key)
                neighbor = nodes[neighbor_key]
                graph.add_edge(self, neighbor, TurnCost)

            di, dj = dirs[d]
            ni, nj = i+di, j+dj
            if maze[ni][nj] in [ '.', 'S', 'E' ]:
                neighbor_key = (ni, nj, d)
                if not neighbor_key in nodes:
                    nodes[neighbor_key] = graph.add_node(neighbor_key)
                neighbor = nodes[neighbor_key]
                graph.add_edge(self, neighbor, StepCost)

    start = nodes[start_at + ( start_dir, )]
    
    best = (math.inf, [])
    for d in range(4):
        key = end_at + (d,)
        if key in nodes:
            finish = nodes[key]
            paths = rx.all_shortest_paths(graph, start, finish,
                                              weight_fn = float)
            last = None
            cost = 0
            for node in paths[0]:
                if last is not None:
                    cost += graph.get_edge_data(last, node)
                last = node
            if cost < best[0]:
                best = (cost, paths)
    print(best[0])
    good_seats = {}
    for path in best[1]:
        for node in path:
            key = graph.get_node_data(node)
            i,j,d = key
            good_seats[(i,j)] = True
    print(len(good_seats))

if __name__ == '__main__' and len(sys.argv) > 1:
    main(sys.argv[1])
