#!/usr/bin/perl -w

# ctrl index

use strict;
use warnings;

use mod::Hello;

my $_ctrl_var_a = "I am a var from $0 in ctrl.";

sub __exec__ {
	my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
	print "\tI am a func from $0 in ctrl:[".$ARGV[0]."].\n";	
}

print "\tvar-a:[$_ctrl_var_a] in ctrl.\n";

__exec__($ARGV);

print "\tI am now at the end of ctrl/index.pl.\n";

1;
