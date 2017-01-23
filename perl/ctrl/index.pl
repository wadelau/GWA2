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
my @arr1 = $hmf{'arr1'};

my $_ctrl_var_a = "I:[$i] am a var from [$0] in ctrl/index. arr1-0-0:[".$arr1[0][0]."]";

print "\tctrl/index: var-a:[$_ctrl_var_a] in ctrl/index.\n";
$hmf{'var_in_ctrl/index'} = "ctrl/index: time:[".time()."]";

$i = 1612071852;
$hmf{'i_in_ctrl/index'} = $i;

#_exec_in_child_(); # this func

_exec_(); # parent's func

$ARGV[$argvsize-1] = \%hmf; # return to parent

print "\tctrl/index: i:[$i] am now at the end of ctrl/index.\n";

sub _exec_in_child_ {
	my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
	print "\tctrl/index: I am a func from $0 in ctrl/index:[".$ARGV[0]."].\n";	
	$hmf{'var_in__exec_in_ctr/index'} = "_exec: time: ".time()."";
	#$hello->sayHi($0);
	$hello->setTbl('materials');
	$hello->set('pagesize', 3);
	my $result = $hello->getBy("*", "1=1", 123);
	my %result = %{$result};
	print "\t\t0-result-state:[".$result{0}."] rtn:[".$result{1}."] now:[".time()."]\n";	
	$hello->set('orderby', 'rand()');
	$result = $hello->getBy("*", "1=1");
	%result = %{$result};
	print "\t\t1-result-state:[".$result{0}."] rtn:[".$result{1}."] now:[".time()."]\n";	
	my @rows = @{$result{1}};
	my $rowCount = @rows;
	for($i=0; $i<$rowCount; $i++){
		print "\t\ti:$i\n";	
		my %row = %{$rows[$i]};
		foreach(keys %row){
			print "\t\t\tk:$_ v:".$row{$_}."\n";
		}
	}

	my $k = 'unionname';
	$hello->set($k, 'value-a'.time());
	$hello->set('threshold', 20001);
	$hello->set('updateu', 'gwa2-in-perl-'.time());
	#$hello->setId(12345);
	$hello->setTbl('temptbl');
	print "\t\t\tget-key-a:[".$hello->get($k)."] id:[".$hello->get('updateu')."] tbl:[".$hello->getTbl()."]\n";
	$result = $hello->setBy('unionname, threshold, updateu', '');
	%result = %{$result};
	print "\t\t2-setBy-result-state:[".$result{0}."] rtn:[".$result{1}."] now:[".time()."]\n";	
}

1;
