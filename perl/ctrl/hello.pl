#!/usr/bin/perl -w

# ctrl index

use strict;
use warnings;
use CGI;

use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

use mod::Hello;

# main body
my $argvsize = scalar @ARGV;
my %hmf = (); # runtime container
%hmf = %{$ARGV[$argvsize-1]};

my $i = $hmf{'i'}; 
my $mod = $hmf{'mod'}; # hello
my $act = $hmf{'act'}; 
my $out = $hmf{'out'};
my $r = $hmf{'r'}; # CGI

my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
print "\tctr/hello: time:[".time()."]\n";
$out .= "\tNow entering into ctrl/hello. @".time()."\n\n";


$hmf{'out'} = $out;
$ARGV[$argvsize-1] = \%hmf; # return to parent

1;
