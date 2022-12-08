#!/usr/bin/env python
from collections import defaultdict
import json
import re
import sys

def catfile(prefix, file):
    if file[0] == '/':
        return file
    elif prefix is None:
        raise ValueError('Relative path to unknown location')
    return ('' if prefix == '/' else '/').join([prefix, file])

def du(tree, prefix='/', result=defaultdict(lambda: 0)):
    for name, value in tree.items():
        if isinstance(value, dict):
            path = catfile(prefix, name)
            result = du(value, path, result)
            result[prefix] += result[path]
        else:
            result[prefix] += value
    return result

tree = {}
pwd = None
node = None
cd_cmd = re.compile(r'^\$\s+cd\s+(\S+)')
ls_dir = re.compile(r'^dir\s+(\S+)')
ls_file = re.compile(r'^(\d+)\s+(\S+)')
with (open(sys.argv[1]) if len(sys.argv) > 1 else sys.stdin) as source:
    for line in [l.rstrip("\n") for l in source]:
        if m := cd_cmd.fullmatch(line):
            d = m.groups()[0]
            if d == '..':
                pwd = '/'.join(pwd.split('/')[0:-1])
            else:
                pwd = catfile(pwd, m.groups()[0])
            node = tree;
            for comp in pwd.split('/'):
                if comp:
                    node = node[comp]
        elif m := ls_dir.fullmatch(line):
            node[m.groups()[0]] = {}
        elif m := ls_file.fullmatch(line):
            node[m.groups()[1]] = int(m.groups()[0])

report = du(tree)
print(f'Part 1: {sum([v for v in report.values() if v <= 100000])}')

free = 70000000 - report['/']
needed = 30000000 - free;
print(f'Part 2: {min([v for v in report.values() if v >= needed])}')
print(json.dumps(tree))
