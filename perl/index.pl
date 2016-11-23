#!/usr/bin/perl -w

# see desc at the bottom

use strict;
use Cwd qw(abs_path realpath);
use File::Basename qw(dirname basename);
use Time::HiRes qw(sleep time);
use Fcntl qw(:flock);
use POSIX qw(strftime);
use Encode qw(decode_utf8 encode_utf8);
use Date::Parse;
use Data::Dumper;
use JSON;
use DBI;
use DBD::mysql;

use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

my $mydir=dirname(abs_path($0));
my $basename=basename($0,(".pl"));
chdir($mydir);
print "workdir:[".$mydir."]\tbasename:[".$basename."]\n";

open(LOCK,">".$mydir."/".$basename.".lock") || die $!;
flock(LOCK,LOCK_EX|LOCK_NB) || warn "another $basename is running,exit\n";

# main body

print "now is: ".strftime("%Y-%m-%d-%H:%M:%S", localtime)."\n";

use lib '/mnt/hgfs/HostGitHub/GWA2/perl';
use lib './';

my $_ctrl_var_a = "I am a var from $0, 1:[".$ARGV[0]."]";
my $ctrl = "index";

require("./ctrl/".$ctrl.".pl");

print "var-a:[$_ctrl_var_a] in index 1:[".$ARGV[1]."].\n";

__exec__($ARGV);


close(LOCK);
unlink($mydir."/".$basename.".lock") or warn "remove lock file failed:[$!].\n";
