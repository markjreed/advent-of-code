my %cache;
sub count-solutions($pattern, $groups) is export {
  my $key = "$pattern:$groups";
  if %cache{$key}:!exists {
    %cache{$key} = really-count-solutions($pattern, $groups);
  }
  return %cache{$key};
}

sub really-count-solutions($pattern, $groups) {

  if !$groups {
      return $pattern ~~ /'#'/ ?? 0 !! 1;
  }

  my @groups = $groups.split: ',';

  if !$pattern {
      return 0;
  }

  my $c = $pattern.substr(0,1);
  my $g = @groups[0];

  sub dot() {
    return count-solutions($pattern.substr(1), $groups);
  }

  sub pound() {
    my $try = $pattern.substr(0,$g).subst(/'?'/, '#', :g);
    if $try ne '#' x $g {
      return 0;
    }
    if $pattern.chars == $g {
      return 1 if @groups == 1;
      return 0;
    }
    if $pattern.substr($g,1) ~~ /<[?.]>/ {
      return count-solutions($pattern.substr($g+1), @groups[1..*].join(','));
    }
    return 0;
  }

  return dot() if $c eq '.';
  return pound() if $c eq '#';
  return dot() + pound();
}
