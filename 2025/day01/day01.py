import fileinput

DEBUG = False

if DEBUG:
    print("no,line,new,part1,part2")
    print("0,,50,0,0")

dial = 50
part1 = part2 = lineno = 0

for line in fileinput.input():
    lineno += 1
    count = int(line[1:])
    if line[0] in {'L','R'} and count > 0:
        if line[0] == 'L':
            count = - count
        was = dial
        dial = (dial + count) % 100
        if dial == 0:
            part1 += 1
            part2 += 1
        elif was != 0 and ((line[0] == 'L' and dial > was) 
                        or (line[0] == 'R' and dial < was)):
            part2 += 1
        part2 += abs(count) // 100;

    if DEBUG:
        print("{lineno},{line},{dial},{part1},{part2}")

print(part1)
print(part2)
