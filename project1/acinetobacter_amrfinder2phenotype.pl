#!/bin/env perl
# Usage: acinetobacter_amrfinder2phenotype.pl <identifier> <nucleotide_amrfinder_output>
#
# Prints tsv in format:
# <identifier>   <drug abbreviation>   R
# <identifier>   <drug abbreviation>   R
#
use strict;
use warnings;
use lib '/home/aprasad/perl5/lib';
use Carp qw(confess);
#use GTB::File qw(Open);
#use GTB::Run qw(comment_usage);

our $DEBUG = 0;
comment_usage() unless (@ARGV == 2);
my $identifier = shift;
my $filename = shift;

my $ra_rules = read_datafile('subclass2phenotype.tab');

my %resistant;

foreach my $ra_rule (@$ra_rules) {
    my @regexes = @{$ra_rule->[0]};
    my $matches = 0;
    foreach my $regex (@regexes) {
        print STDERR "$regex - $ra_rule->[1]\n" if ($DEBUG);
        my $rv;
        $DEBUG  
            ? $rv = system("grep -q '$regex' $filename ") 
            : $rv = system("grep -q '$regex' $filename > /dev/null");
        $matches++ if ($rv == 0);
    }
    if ($matches == @regexes) {
	$resistant{$ra_rule->[1]} .= join(" ", @regexes). " ";
    }
}
foreach my $drug (sort(keys(%resistant))){
    $resistant{$drug} =~ s/ +$//;
    print "$identifier\t$drug\tR\t$resistant{$drug}\n";
}

# returns $ra @ab_rules
# $ra_abrules = 
# [ 
#   [ regexes ]
#   drug abbr
#   full drug name
# ],
# [
#   [ regexes ]
#   drug abbr
#   full drug name
# ],
# All regexes must be satisfied for a resistant call
sub read_datafile {
    my $filename = shift;
    my @ab_rules;
    my $fh;
    open($fh, $filename) or die "Coudln't read $filename: $!";
    while (<$fh>) {
        chomp;
        next if (/^\s*#/ or /^\s*$/); # skip comment or blank lines
        my($regex, $abbr, $full) = split(/\t/, $_);
        if ($regex =~ /,/) {
            my @regex = split(/,/, $regex);
            push @ab_rules, [\@regex, $abbr, $full];
        } else {
            push @ab_rules, [[$regex], $abbr, $full];
        }
    }
    return \@ab_rules;
}

######################################################################
# comment_usage - print the comments at the beginning of the executable
#  as a usage message and die
# INPUTS:  Any strings passed in will be printed as error messages
#          following the usage message.
# OUTPUTS: Prints usage message and exit(1);
######################################################################
sub comment_usage {
    my @errors = @_;

    open IN, $0 or confess "Couldn't read source ($0): $!";
    $_ = <IN>;

    # skip frst 3 lines if the program starts with an eval statement
    # added by make install
    my $line2pos = tell(IN);
    $_ = <IN>; $_ .= <IN>; $_ .= <IN>;
    if ($_ !~ /\neval 'exec .*\n\s+if 0;[^\n]+\n/) {
        seek(IN, $line2pos, 0);
    }

    while (<IN>) {
        if(s/^#[ \t]?//) {
           print STDERR $_;
        } else {
            close (IN);
            last;
        }
    }
    if (@errors) {
        foreach my $error (@errors) {
            chomp $error;
            $error .= "\n";
        }
        print STDERR "ERROR:\n";
        print STDERR @errors;
        print STDERR "Died", Carp::shortmess();
        exit 1;
    }
    else {
        exit 1;
    }
}
