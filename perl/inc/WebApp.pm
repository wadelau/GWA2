package inc::WebApp;

#
# Main designs from -GWA2 in -PHP
# By Xenxin@ufqi.com, Wadelau@ufqi.com
# Since Sun Jan  1 22:56:46 CST 2017
# v0.10
#

use strict;
use warnings;
use Cwd qw(abs_path realpath);
use File::Basename qw(dirname basename);
use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

use parent 'inc::WebInterface';
use inc::Config;
use inc::Dba;

my $_ROOT_ = dirname(abs_path($0));
use constant VER => 0.01;
my $dba = {};
my $hm = [];
my $hmf = ();
my $isdbg = 1;
my $myId = 'id';
use constant {
	GWA2_ERR => 'gwa2_tag_error',
	GWA2_ID => 'gwa2_tag_id',
	GWA2_TBL => 'gwa2_tag_tbl',
};
my $GWA2_Rumtime_Env_List = ();

#
sub new {
	my $class = shift @_;
	my $args = shift; # @_ may be omitted.
	my %args = %{$args};
	print "\t\tclass:[$class] args:[".\%args."]\n";
	my $self = {};
	if(1){
		$dba = inc::Dba->new($args{'dbconf'});	
	}

	bless $self, $class;
	return $self;
}

#
sub DESTROY {
	# @todo	
	print "\t\t\tI am runing away from inc::WebApp->DESTROY...\n";
}

#
# by Xenxin@ufqi.com since Sun Jan  1 22:54:54 CST 2017
sub getBy {
	my $fields = shift;
	my $conditions = shift;
	my $withCache = shift;
	
	my $sql = "select $fields from tbl where $conditions";

	my $result = $dba->select($sql, ());
	my %result = %{$result};

	print "\t\t\tinc::WebApp: result:".%result."\n";
	
	sleep(rand(3));

	return \%result;
}

#
sub getEnv {
	return "ver:[".VER."] root:[".$_ROOT_."]";	
}

1;
