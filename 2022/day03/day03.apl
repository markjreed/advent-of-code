⍝ Priority of a rucksack element (a-z=1-26, A-Z=27-52)
priority ← {{(26×⍵<97)+32|⍵}⎕ucs⍵}

⍝ Part 1, add priorities of items common to both compartments in each rucksack
part1 ← {+/priority {⍵[1⍳⍨⊃∊/(≢⍵){⍵⊆⍨⌈(⍳⍺)÷⌊⍺÷2}⍵]}¨⍵}

⍝ Part 2, add prirorites of items common to each group of three rucksacks
part2 ← {+/priority ⊃¨⊃¨∩/¨⍵⊆⍨⌈(⍳≢⍵)÷3}

⍝ compute the totals for the data in the given file
∇result ← day3 filename            ;data;res1;res2
  data ← ⊃⎕NGET filename 1
  res1 ← part1 data
  res2 ← part2 data
  result ←  res1, res2
∇
