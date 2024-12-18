#!/usr/bin/env python
import argh, math, re, rustworkx as rx, sys

TimeLimit = 30
Pattern = re.compile(r'Valve ([A-Z][A-Z]) has flow rate=(\d+); tunnels? leads? to valves? ((?:[A-Z][A-Z](?:,\s+)?)+)')
rates = {}
tunnels = {}

def main(file, start='AA'):
    opened = {}

    with open(file) as f:
        for line in f:
            if m := Pattern.match(line):
                valve = m[1]
                rates[valve] = int(m[2])
                opened[valve] = False
                if valve not in tunnels:
                    tunnels[valve] = {}
                for neighbor in m[3].split(', '):
                    tunnels[valve][neighbor] = True

    print(rates)
    print(max_rate(opened, start, TimeLimit, 0))


memo = {}
def max_rate(opened, valve, time_left, pressure):
    global rates, tunnels
    if time_left == 0:
        return pressure

    key = (*[opened[k] for k in sorted(opened.keys())], valve, time_left, pressure)
    if key in memo:
        return memo[key]

    attempts = []
    if rates[valve] and not opened[valve]:
        attempts.append(max_rate({**opened, **{valve: True}}, 
                                valve, time_left - 1, 
                                pressure + rates[valve] * (time_left - 1)))

    for neighbor in tunnels[valve].keys():
        attempts.append(max_rate(opened, neighbor, time_left - 1, pressure))

    memo[key] = max(attempts)
    return memo[key]

if __name__ == '__main__':
    argh.dispatch_command(main)
