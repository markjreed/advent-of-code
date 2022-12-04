range←{1-⍨⍺+⍳⍵-⍺-1}
split←{(~⍵∊⍺)⊆,⍵}
sort←{⍵[⍋⍵]}
seq←{(sort ⍺)≡(sort ⍵)}
contains←{u←⍺∪⍵ ⋄ (⍺ seq u)∨(⍵ seq u)}
∇result ← day4 filename;data;part1;part2
   data ← {{⊃range/⍎¨'-'split⍵}¨⍵}¨{','split⍵}¨⊃⎕nget filename 1
   part1 ← +/{contains/⍵}¨data
   part2 ← +/{0≠≢⊃∩/⍵}¨data
   result ← part1 part2
∇
