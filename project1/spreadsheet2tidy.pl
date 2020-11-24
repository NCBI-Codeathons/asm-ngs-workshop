#!/bin/env perl
use strict;
use warnings;
#use GTB::File qw(Open);

#my $in = Open('spreadsheet-phenotypes.tab2');
my $in;
open($in, 'spreadsheet-phenotypes.tab') 
    or die "Couldn't open spreadsheet-phenotypes.tab: $!";

my $h = <$in>;
chomp($h);
my @h = split(/\t/, $h);

my @data;

while (<$in>) {
    chomp;
    my @F = split(/\t/);
    for (my $i = 1; $i <= $#F; $i++) {
        my $drug = $h[$i];
        print "$F[0]\t$drug\t$F[$i]\n";
    }
}


