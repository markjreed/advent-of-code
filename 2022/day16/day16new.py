#!/usr/bin/env python
import argh, itertools, math, re, rustworkx as rx

TimeLimit = 30
TrainingTime = 4
Pattern = re.compile(r'Valve ([A-Z][A-Z]) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z][A-Z](?:,\s+)?)+)')
rates = {}
tunnels = {}

def main(file, start='AA'):
    global rates, tunnels, max_pressure, max_opened

    with open(file) as f:
        for line in f:
            if m := Pattern.match(line):
                valve = m[1]
                rates[valve] = int(m[2])
                if valve not in tunnels:
                    tunnels[valve] = {}
                for neighbor in m[3].split(', '):
                    tunnels[valve][neighbor] = True

    # find the shortest paths between each pair of valves (Floyd-Warshall) and
    # use those as our edges instead of the length-1 tunnels.
    dist = { v1: { v2: math.inf for v2 in rates.keys() } for v1 in rates.keys() }
    for u, t in tunnels.items():
        for v in t.keys():
            dist[u][v] = 1

    for v in dist.keys():
        dist[v][v] = 0

    for k in dist.keys():
        for i in dist.keys():
            for j in dist.keys():
                thru_k = dist[i][k] + dist[k][j]
                if thru_k < dist[i][j]:
                    dist[i][j] = thru_k
    
    # eliminate all valves with zero flow rate or that are too far away from
    # start
    valves = { k: v for k, v in rates.items() if (k==start or v) and dist[start][k] < TimeLimit }
    edges = { u: { v: dist[u][v] for v in valves.keys() } for u in valves.keys() }

    # for our graph, each vertex indicates not only our position but the state of all
    # the openable valves
    states = 1 << len(valves)
    nodes = {}
    g = rx.PyGraph()
    for i, v in enumerate(valves):
        bit = 1 << i
        for s in range(states):
            key = f'{v}{s}'
            if key not in nodes:
                nodes[key] = g.add_node(key)
            self = nodes[key]

            if s & bit == 0:
                nkey = f'{v}{s | bit}'
                if nkey not in nodes:
                    nodes[nkey] = g.add_node(nkey)
                neighbor = nodes[nkey]
                g.add_edge(self, neighbor, 1)

            for n, time in edges[v].items():
                if time:
                    nkey = f'{n}{s}'
                    if nkey not in nodes:
                        nodes[nkey] = g.add_node(nkey)
                    neighbor = nodes[nkey]
                    g.add_edge(self, neighbor, time)

    print(f'graph has {len(g.nodes())} nodes and {len(g.edges())} edges')

if __name__ == '__main__':
    argh.dispatch_command(main)
