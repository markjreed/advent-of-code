#!/usr/bin/env python
import argh
from intervaltree import Interval, IntervalTree

def main(input_file):
    tree = IntervalTree()
    new = None
    with open(input_file) as f:
        for line in f:
            words = line.split()
            if len(words) == 0:
                continue
            if words[0] == 'seeds:':
                words = words[1:]
                while words:
                    start = int(words.pop(0))
                    length = int(words.pop(0))
                    tree.addi(start, start+length)
                #print(tree)
            elif '-to-' in words[0]:
                if new != None: 
                    tree |= new
                    #print(tree)
                new = IntervalTree()
                continue
            else:
                to, start, length = [int(w) for w in words]
                #print(f'mapping {start}...{start+length-1} to {to}...{to+length-1}')
                stop = start + length
                mapping = Interval(start, start+length)
                for i in tree[mapping.begin:mapping.end]:
                    begin = i.begin
                    end = i.end
                    if begin < start:
                        before = Interval(begin, start)
                        tree.add(before)
                        begin = start
                    if end > stop:
                        after = Interval(stop, end)
                        tree.add(after)
                        end = stop
                    begin = begin - start + to
                    end   = end - start + to
                    tree.discard(i)
                    new.addi(begin, end)

    tree |= new
    print(tree.begin())

if __name__ == '__main__':
    argh.dispatch_command(main)
