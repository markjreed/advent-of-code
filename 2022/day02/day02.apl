⍝ See notes.txt for derivation of score formulas
{d←{('ABC'⍳⍵[1]),('XYZ'⍳⍵[3])}¨⊃⎕NGET ⍵ 1 ⋄ ⎕←'Part 1:',+/{{⍵+3×3|1+⍵-⍺}/⍵}¨d ⋄ ⎕←'Part 2:',+/{{(3×1-⍨⍵)+1+3|⍺+⍵}/⍵}¨d}
