#!/usr/bin/perl -w

# see desc at the bottom

use lib '/mnt/hgfs/HostGitHub/GWA2/perl'; # @todo
use lib './';

use strict;
use Cwd qw(abs_path realpath);
use File::Basename qw(dirname basename);
use Time::HiRes qw(sleep time);
use Fcntl qw(:flock);
use POSIX qw(strftime);
use Encode qw(decode_utf8 encode_utf8);
#use Date::Parse;
#use Data::Dumper;
#use JSON;
#use DBI;
#use DBD::mysql;

use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

my $mydir = dirname(abs_path($0));
my $basename = basename($0,(".pl"));
my $singlerun = 1;
chdir($mydir);
print "workdir:[".$mydir."]\tbasename:[".$basename."]\n";
if($singlerun == 1){
	open(LOCK,">".$mydir."/".$basename.".lock") || die $!;
	flock(LOCK,LOCK_EX|LOCK_NB) || warn "another $basename is running,exit\n";
}

# main body

# comm/header.inc.pl ?

print "now is: ".strftime("%Y-%m-%d-%H:%M:%S%z", localtime)."\n";

my $i = 1612071942;
my $hmf;
my %hmf = (); # runtime container
my $_ctrl_var_a = "I:[$i] am a var from $0, index.";
my $ctrl = "index"; # hello
my $argvsize = @ARGV;

$hmf{'var_a'} = $_ctrl_var_a;
$hmf{'i'} = $i;
$hmf{'mod'} = $ctrl;
$ARGV[$argvsize] = \%hmf; # $hmf; prepare for controller

print "ARGV:\n";
for(my $i=0; $i<@ARGV; $i++){
	my $v = $ARGV[$i];
	#print Dumper($v);
	print "\ti:$i v:[".$v."]\n";
}

print "bfr var-a:[$_ctrl_var_a] in index\n"; 

require "./ctrl/$ctrl.pl";

_exec2_(); # child's func

_exec_(); # this func

print "\naft var-a:[$_ctrl_var_a] in index.\n\n";

for(my $i=0; $i<@ARGV; $i++){
	my $v = $ARGV[$i];
	#print Dumper($v);
	#print "\ti:$i v:[".$v."]\n";
}

%hmf = %{$ARGV[$argvsize]}; # return from controller
#print "var_in_ctrl/index:[".$hmf{'var_in_ctrl/index'}."]\n";
#print "i_in_ctrl/index:[".$hmf{'i_in_ctrl/index'}."]\n\n";

sub _exec_ {
	my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
	print "\tindex: I am a func from $0 in index:[".$ARGV[0]."] i:$i.\n";	
	$hmf{'var_in__exec_in_index'} = "_exec_index_: time: ".localtime();
	$hello->sayHi($0);
}

# comm/footer.inc.pl ?

if($singlerun == 1){
	close(LOCK);
	unlink($mydir."/".$basename.".lock") or warn "remove lock file failed:[$!].\n";
}
