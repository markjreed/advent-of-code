#!/usr/bin/env python
import argh

def main(filename):
    total = 0
    counts = []
    with open(filename) as file:
        for index, card in enumerate(file):
            if index >= len(counts):
                counts.append(1)
            label, numbers = card.split(':')
            left, right = numbers.split('|')
            winning = set([int(num) for num in left.split()])
            numbers = set([int(num) for num in right.split()])
            winners = len(numbers.intersection(winning))
            for prize in range(winners):
                copy = index + 1 + prize
                if copy >= len(counts):
                    counts.append(1)
                counts[copy] += counts[index]


    print(sum(counts))

if __name__ == '__main__':
    argh.dispatch_command(main)
