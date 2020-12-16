#!/usr/bin/env python
import argh

def main(numbers, position=2020, verbose=False):
  starting_list = [int(n) for n in numbers.split(',')]
  last = starting_list.pop()

  if verbose:
    for i,n in enumerate(starting_list):
      print(f'Turn {i+1}: {n}')

  turn = len(starting_list);
  spoken = {n: i for i,n in enumerate(starting_list)}

  while turn < position -1:
    if verbose:
      print(f'Turn {turn+1}: {last}')

    say = 0
    if last in spoken:
      say = turn - spoken[last]
    spoken[last] = turn
    last = say
    turn = turn + 1

  if verbose:
    print(f'Turn {turn+1}: ',end='')
  print(last);

if __name__ == '__main__':
    argh.dispatch_command(main)
