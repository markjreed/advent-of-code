#!/usr/bin/env perl
use v5.40;

die "Usage: $0 input-file\n" unless @ARGV == 1;

chomp(my $password = <>);

sub valid_password($string) {
    return unless $string =~ /^[a-ghjkm-z]{8}$/;
    return unless $string =~ /(.)\1.*(.)\2/;
    my $ascending = 0;
    foreach my $a ('a'..'x') {
        my $b = chr(ord($a) + 1);
        my $c = chr(ord($a) + 2);
        if ($string =~ /$a$b$c/) {
            $ascending = 1;
            last;
        }
    }
    return $ascending;
}

while (!valid_password(++$password)) { }

say $password;

while (!valid_password(++$password)) { }

say $password;

