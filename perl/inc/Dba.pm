package inc::Dba;

use strict;
use warnings;
use Cwd qw(abs_path realpath);
use File::Basename qw(dirname basename);
use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

use inc::Config;
use inc::MySQL;
use inc::Conn;

my $_ROOT_ = dirname(abs_path($0));
my $conf = ();
my $dbconn = {};
my $sql_operator_list = ();

#
sub new {
	my $class = shift @_;
	my $self = {};

	$conf = shift;
	if($conf ne ""){ $conf = "inc::Conn::$conf"; }
	print "\t\t\tconf:[$conf] in inc::Dba\n";
	my $confo = $conf->new();
	$dbconn = inc::MySQL->new($confo); # swith to other drivers @todo

	bless $self, $class;
	return $self;
}

#
sub DESTROY {}

#
sub select {
	my $sql = shift;		
	my $hmvars = shift;

	my %result = $dbconn->readSingle($sql, $hmvars);

	return %result;
}

#
sub update {
	my $sql = shift;		
	my $hmvars = shift;

	my %result = $dbconn->query($sql, $hmvars);

	return %result;
}
1;