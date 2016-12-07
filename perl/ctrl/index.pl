#!/usr/bin/perl -w

# ctrl index

use strict;
use warnings;

use mod::Hello;

my $i = $ARGV[1];
my $argvsize = @ARGV;
my $hmf;
my %hmf = ();
$hmf = $ARGV[$argvsize-1];

my $_ctrl_var_a = "I:[$i] am a var from [$0] in ctrl/index. argvsize:[$argvsize] parent-var-a:[".$hmf{'var_a'}."]";

sub __exec__ {
	my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
	print "\tI am a func from $0 in ctrl/index:[".$ARGV[0]."].\n";	
}

print "\tvar-a:[$_ctrl_var_a] in ctrl/index.\n";

__exec__($ARGV);

$ARGV[2] = $_ctrl_var_a;

print "\tI:[$i] am now at the end of ctrl/index.\n";

1;
