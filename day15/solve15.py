#!/usr/bin/env python
import argh

def main(numbers, position=2020, verbose=False):
  starting_list = [int(n) for n in numbers.split(",")]
  spoken = {n: i for i,n in enumerate(starting_list[:-1])}
  last = starting_list[-1]
  turn = len(starting_list)-1;
  while turn < position -1:
    if last in spoken:
      say = turn - spoken[last]
    else:
      say = 0
    spoken[last] = turn
    last = say
    turn = turn + 1

  if verbose:
    print(f"Turn {turn+1}: ",end='')
  print(last);

if __name__ == '__main__':
    argh.dispatch_command(main)
