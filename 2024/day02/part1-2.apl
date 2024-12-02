split ← {(~⍵∊⍺)⊆,⍵}

safe ← {((⍵[⍋⍵]≡⍵)∨(⍵[⍒⍵]≡⍵))∧(1-⍨≢⍵)=+/{(1≤⍵)∧⍵≤3}(1-⍨≢⍵)↑|⍵-1⌽⍵}

safe2 ← {a←⍵ ⋄ (safe a)∨(∨/safe¨{a/⍨~(≢a)↑⍸⍣¯1,⍵}¨⍳≢a)}

reports ← {⍎⍵} ¨ (⎕ucs 10) split ⊃⎕nget 'data.txt' ⍝ part 1

+/safe ¨ reports ⍝ part 1

+/safe2 ¨ reports ⍝ part 2
