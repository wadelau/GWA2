#!/usr/bin/perl -w

# ctrl index

use strict;
use warnings;

use mod::Hello;

# main body

my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
print "\tctr/hello: time:[".time()."]\n";


1;
