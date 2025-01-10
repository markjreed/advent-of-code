⍝ Dyalog doesn't permit newlines inside direct function definitions, so these have to be 
⍝ pasted on one line, so I've included more nicely formatted versions in the comments.

⍝ nice1 ← { 
⍝   s←⍵ ⋄
⍝     0 ≠ (3 ≤ +/s∊'aeiou')                                        ⍝ at least three vowels
⍝   ∧     (+/{s[⍵] = s[⍵+1]}¨⍳1-⍨≢s)                               ⍝ AND a repeated letter
⍝   ∧     (0=+/{(s[⍵]∊'acpx')∧(s[⍵+1]=⎕ucs 1+⎕ucs s[⍵])}¨⍳1-⍨≢s)}  ⍝ AND no ab, cd, pq, or xy
⍝ }

nice1 ← { s←⍵ ⋄ 0≠(3 ≤ +/s∊'aeiou') ∧ (+/{s[⍵] = s[⍵+1]}¨⍳1-⍨≢s) ∧ (0=+/{(s[⍵]∊'acpx')∧(s[⍵+1]=⎕ucs 1+⎕ucs s[⍵])}¨⍳1-⍨≢s)}

⍝ nice2 ← {
⍝     s←⍵ ⋄
⍝       (0 ≠ +/{ s[⍵] = s[⍵+2] } ¨ ⍳ 2-⍨≢s ) ⍝ a letter that repeats 2 spaces later
⍝     ∧ (0 ≠ +/{ 
⍝             i←⍵ ⋄
⍝             0 ≠ +/{ (s[i]=s[⍵]) ∧ (s[i+1]=s[⍵+1]) } ¨ 1 + i + ⍳ ((≢s)-i+2)
⍝         } ¨ ⍳ 3-⍨≢s)
⍝ }

nice2←{s←⍵ ⋄ (0≠+/{s[⍵]=s[⍵+2]}¨⍳2-⍨≢s)∧(0≠+/{i←⍵⋄0≠+/{ (s[i]=s[⍵]) ∧ (s[i+1]=s[⍵+1])}¨1+i+⍳((≢s)-i+2)}¨⍳3-⍨≢s)}

lines ← ⊃⎕nget 'input.txt' 1
⎕ ← +/nice1 ¨ lines
⎕ ← +/nice2 ¨ lines
