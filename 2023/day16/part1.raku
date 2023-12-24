unit sub MAIN($input); 
use Day16;

my @map = $input.IO.lines».comb;

say simulate-beam(@map, 0,0,0,1);
