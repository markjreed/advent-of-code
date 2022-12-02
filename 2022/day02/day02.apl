⍝ See notes.txt for derivation of score formulas

⍝ compute the score for a matchup
⍝ call as `elf partN human` with elf, human in the range 1-3
part1 ← {⍵+3×3|1+⍵-⍺}
part2 ← {(3×1-⍨⍵)+1+3|⍺+⍵}

⍝ compute the totals for the data in the given file
∇result ← day2 filename            ;data;res1;res2
  data ← {('ABC'⍳⍵[1]),('XYZ'⍳⍵[3])}¨⊃⎕NGET filename 1
  res1 ← +/{part1/⍵} ¨ data
  res2 ← +/{part2/⍵} ¨ data
  result ←  res1, res2
∇
