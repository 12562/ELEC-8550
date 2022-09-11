#! /usr/bin/perl

use strict;
use warnings;

my $binary_num = $ARGV[0];
my %representations;
$representations{"$binary_num"} = 1;

sub for_continuous1_substitution {
    my ($num) = @_;
    while ( $num =~ /^(11+).*/ ) {
      my $tmp = $1;
      $tmp =~ s/1/0/g; $tmp =~ s/0$/\-1/g; $tmp = "1$tmp";
      ($num = $num) =~ s/^1+/$tmp/;
      if ( !exists($representations{"$num"})) {
         $representations{"$num"} = 1;
         for_01_substitution("$num");
         for_01bar_substitution($num);
         for_continuous1_substitution($num);
      }
    }
}

sub for_01_substitution {
    my ($num) = @_;
    while ( $num =~ /01/ ) {
      ($num = $num) =~ s/01/1\-1/;
      if ( !exists($representations{"$num"})) {
         $representations{"$num"} = 1;
         for_01_substitution("$num");
         for_01bar_substitution($num);
         for_continuous1_substitution($num);
      }
    }
}

sub for_01bar_substitution {
    my ($num) = @_;
    while ( grep(/0-1/,$num) ) {
      ($num = $num) =~ s/0-1/\-11/;
      if ( !exists($representations{"$num"})) {
         $representations{"$num"} = 1;
         for_01_substitution($num);
         for_01bar_substitution($num);
         for_continuous1_substitution($num);
      }
    }
}

for_01_substitution("$binary_num");
for_01bar_substitution("$binary_num");
for_continuous1_substitution($binary_num);

foreach my $key ( keys(%representations) ) {
  print "$key\n";
}

#print "$binary_num\n"
