#!/usr/bin/perl -w

# see desc at the bottom
# invoke by cli:
# /path/to/perl -w /path/to/index.pl "?mod=hello&act=say&fmt=json"

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
#use JSON;
use autodie;
use CGI; # @todo

use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

my $mydir = dirname(abs_path($0));
my $basename = basename($0,(".pl"));
my $singlerun = 0;
chdir($mydir);
print "workdir:[".$mydir."]\tbasename:[".$basename."]\n";
if($singlerun == 1){
	open(LOCK,">".$mydir."/".$basename.".lock") || die $!;
	flock(LOCK,LOCK_EX|LOCK_NB) || warn "another $basename is running,exit\n";
}

# main body

# header
require("./comm/header.inc.pl");

my $argvsize = scalar @ARGV;
my %hmf = (); # runtime container
%hmf = %{$ARGV[$argvsize-1]}; # return from controller
print "now is: ".strftime("%Y-%m-%d-%H:%M:%S%z", localtime)."\n";

my $i = $hmf{'i'};
my $mod = $hmf{'mod'}; # hello
my $act = $hmf{'act'}; 
my $r = $hmf{'r'}; # CGI
my $out = $hmf{'out'};
$out .= "\tI am now traveling into index. @".time()."\n\n";

$hmf{'out'} = $out;
$ARGV[$argvsize-1] = \%hmf; # $hmf; prepare for controller
if(!defined($mod)){ $mod = ''; }
if($mod eq ''){ $mod = 'index'; }

print "index: ARGV:\n";
for(my $i=0; $i<@ARGV; $i++){
	my $v = $ARGV[$i];
	print "\tindex: i:$i v:[".$v."]\n";
}

# mod, ctrl
require "./ctrl/$mod.pl";

#_exec_in_child_(); # child's func

#_exec_(); # this func

print "index: ARGV after ctrl:\n";
for(my $i=0; $i<@ARGV; $i++){
	my $v = $ARGV[$i];
	print "\tindex: i:$i v:[".$v."]\n";
}

# sub
sub _exec_ {
	my $hello = mod::Hello->new($ARGV[0], $ARGV[1]);
	print "\tindex: I am a func from $0 in index:[".$ARGV[0]."].\n";	
	$hmf{'var_in__exec_in_index'} = "_exec_index_: time: ".localtime();
	$hello->sayHi($0);
}

# footer
require("./comm/footer.inc.pl");

if($singlerun == 1){
	close(LOCK);
	unlink($mydir."/".$basename.".lock") or warn "remove lock file failed:[$!].\n";
}
