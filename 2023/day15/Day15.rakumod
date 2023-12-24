unit module Day15;

sub compute-hash($str) is export {
    my $cv = 0;
    for $str.comb».ord -> $asc {
        $cv = (17 * ($cv + $asc)) +& 0xff;
    }
    return $cv;
}

sub focusing-power(@boxes) is export {
    my $power = 0;
    for @boxes.kv -> $i, $box {
        my $number = $i + 1;
        for @$box.kv -> $j, $lens {
            my $slot = $j + 1;
            $power += $number * $slot * $lens.value;
        }
    }
    return $power;
}
