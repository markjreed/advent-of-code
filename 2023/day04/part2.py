#!/usr/bin/env python
import argh

def main(filename):
    total = 0
    cards = []
    with open(filename) as file:
        for card in file:
            label, numbers = card.split(':')
            left, right = numbers.split('|')
            winning = set([int(num) for num in left.split()])
            numbers = set([int(num) for num in right.split()])
            cards.append(len(numbers.intersection(winning)))
    total = len(cards)
    queue = list(range(total))
    while len(queue):
        number = queue.pop(0)
        total += cards[number]
        for i in range(cards[number]):
            queue.append(number + 1 + i)

    print(total)

if __name__ == '__main__':
    argh.dispatch_command(main)
