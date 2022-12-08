#!/usr/bin/env raku

sub catfile($dir, $file) {
  return $file if $file ~~ m|^'/'|; # leave absolute paths alone
  die 'Relative path to unknown location' unless $dir;
  ($dir, $file).join: $dir eq '/' ?? '' !! '/';
}

sub du(%tree, $pwd='/', %result is copy={}) {
  for %tree.kv -> $name, $value {
    if $value ~~ Hash {
      my $path = catfile($pwd, $name);
      %result = du($value, $path, %result);
      %result{$pwd} += %result{$path};
    } else {
      %result{$pwd} += $value;
    }
  }
  return %result;
}

my %tree;
my $pwd;
my $node;
for $*ARGFILES.lines {
  if /^'$' \s+ 'cd' \s+ (\S+)/ {
    if $0 eq '..' {
      $pwd = $pwd.split('/')[0..*-2].join('/') || '/';
    } else {
      $pwd = catfile($pwd, ~$0);
    }
    $node = %tree;
    for $pwd.split('/') {
      $node = $node{$_} if $_;
    }
  } elsif /^'dir' \s+ (\S+)/ {
    $node{~$0} = {};
  } elsif /^ (\d+) \s+ (\S+) / {
    $node{~$1} = +$0;
  }
}
my %report = du(%tree);
say "Part 1: {[+]  %report.values.grep: * <= 100000}";

my $free = 70000000 - %report«/»;
my $needed = 30000000 - $free;
say "Part 2: { %report.values.grep( * >= $needed).min }";
