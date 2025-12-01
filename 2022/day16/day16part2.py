#!/usr/bin/env python
import argh, itertools, re

TimeLimit = 30
TrainingTime = 4
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

    part1 = max_rate(opened, start, TimeLimit, 0)
    print(part1)
    opened = { valve: False for valve in opened.keys() }
    part2 = max_rate(opened, (start,start), TimeLimit - TrainingTime, 0)
    print(part2)

memo = {}
def max_rate(opened, workers, time_left, pressure):
    global rates, tunnels
    if time_left == 0:
        return pressure
    
    # if there are two workers, then we have these options:
    # 1. if both workers are at the same valve, then one can
    #    turn the valve while the other moves
    # 2. or both can move
    # 3. both workers move without turning the current valve
    if type(workers) is not tuple:
        workers = (workers,)

    workers = sorted(workers)
    key = (*[opened[k] for k in sorted(opened.keys())], *workers,
           time_left, pressure)

    if key in memo:
        return memo[key]

    options = {}
    for valve in workers:
        options[valve] = {}
        if rates[valve] and not opened[valve]:
            options[valve][valve] = True
        for neighbor in tunnels[valve].keys():
            options[valve][neighbor] = True

    moves = [dest for worker in workers for dest in options[worker].keys()]
    if len(workers) == 2:
        moves = list(itertools.product(moves, moves))
        #print(f'moves={moves}')

    attempts = []
    for move in moves:
        #print(f'attempting move {move}')
        new_time = time_left - 1
        new_opened = opened
        new_pressure = pressure
        skip = False
        if type(move) is tuple:
            for valve in move:
                if valve in workers and not opened[valve]:
                    if move == (valve, valve):
                        skip = True
                    else:
                        new_opened[valve] = True
                        new_pressure += new_time * rates[valve]
        elif move in workers and not opened[move]:
            new_opened[valve] = True
            new_pressure += new_time * rates[valve]

        if not skip:
            attempts.append(max_rate(new_opened, move, new_time, new_pressure))

    #print(f'setting memo[{key}]')
    memo[key] = max(attempts)
    return memo[key]

if __name__ == '__main__':
    argh.dispatch_command(main)
