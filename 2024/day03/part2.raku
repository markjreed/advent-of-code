    #!/usr/bin/env raku
    my regex op { 
           ('mul') '(' ( \d ** 1..3 ) ',' ( \d ** 1..3 ) ')' 
        || ( 'do' "n't"? ) '()' 
    }
    
    my $doing = True;
    my $total = 0;
    for slurp() ~~  m:g/ <op> / -> $/ {
        when $<op>[0] eq "do"    { $doing = True }
        when $<op>[0] eq "don't" { $doing = False }
        when $<op>[0] eq "mul"   { $total += $<op>[1] * $<op>[2] if $doing }
    }
    say $total;
