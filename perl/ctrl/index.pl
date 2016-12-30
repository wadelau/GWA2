#!/usr/bin/perl -w

# ctrl index

use strict;
use warnings;

use mod::Hello;

# refer: 
#	http://www.ttlsa.com/nginx/perl-fastcgi-nginx/
# 	http://search.cpan.org/~ether/FCGI-0.78/FCGI.pm

my $i = 0; # $ARGV[1];
my $argvsize = @ARGV;
my $hmf;
my %hmf = %{$ARGV[$argvsize-1]};
$i = $hmf{'i'};

my $_ctrl_var_a = "I:[$i] am a var from [$0] in ctrl/index.";

print "\tctrl/index: var-a:[$_ctrl_var_a] in ctrl/index.\n";
$hmf{'var_in_ctrl/index'} = "ctrl/index: time:[".time()."]";

$i = 1612071852;
$hmf{'i_in_ctrl/index'} = $i;

_exec2_(); # this func

_exec_(); # parent's func

$ARGV[$argvsize-1] = \%hmf; # return to parent

print "\tctrl/index: i:[$i] am now at the end of ctrl/index.\n";

sub _exec2_ {
	my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
	print "\tctrl/index: I am a func from $0 in ctrl/index:[".$ARGV[0]."].\n";	
	$hmf{'var_in__exec_in_ctr/index'} = "_exec: time: ".time()."";
	$hello->sayHi($0);
	my %result = $hello->getBy("select from ctrl/index.");
	print "\t\tresult-state:[".$result{0}."] rtn:[".$result{1}."] now:[".time()."]\n";	
}

1;
