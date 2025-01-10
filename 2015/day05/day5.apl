nice ← { s←⍵ ⋄ 0≠(3 ≤ +/s∊'aeiou') ∧ (+/{s[⍵] = s[⍵+1]}¨⍳1-⍨≢s) ∧ (0=+/{(s[⍵]∊'acpx')∧(s[⍵+1]=⎕ucs 1+⎕ucs s[⍵])}¨⍳1-⍨≢s)}

 +/nice ¨ ⊃⎕nget 'input.txt' 1
