#!/usr/bin/perl -w

# comm/header.inc.pl

use strict;
use warnings;
use CGI;

my $r = CGI->new(); # @todo, refer: http://perldoc.perl.org/CGI.html

my $i = 0; 
my $argvsize = scalar @ARGV;
my %hmf = (); # runtime container
$hmf{'out'} = "\$out : I am starting from comm/header @".time()."\n\n";
$hmf{'fmt'} = '';
$hmf{'r'} = \$r;
$hmf{'i'} = $i;
print "\tcomm/header: argc:$argvsize ARGV:\n";
for($i=0; $i<@ARGV; $i++){
	my $v = $ARGV[$i];
	print "\t\ti:$i v:[".$v."]\n";
}
my $params = $ARGV[0];
if(!defined($params)){ $params = ''; }
elsif($params=~/^\?/){ $params = substr($params,1); }
if($params=~/&amp;/){ $params = ~s/&amp;/&/g; }
my @param_list = split(/&/, $params);
my $param_size = scalar @param_list;
for($i=0; $i<$param_size; $i++){
	my $v = $param_list[$i];
	print "\t\tcomm/header: i:$i v:".$v."\n";	
	if($v=~/=/){
		my @v2 = split(/=/, $v);
		$hmf{$v2[0]} = $v2[1];
	}
}

$ARGV[$argvsize] = \%hmf; # return to parent

1;
