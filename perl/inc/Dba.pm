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
	my $self = {}; # {@_}

	$conf = shift;
	if($conf ne ""){ $conf = "inc::Conn::$conf"; }
	print "\t\t\tinc::Dba: conf:[$conf] in inc::Dba\n";
	my $confo = $conf->new();
	$dbconn = inc::MySQL->new($confo); # swith to other drivers @todo

	bless $self, $class;
	return $self;
}

#
sub DESTROY {}

#
# Xenxin@ufqi.com, Sun Jan  1 22:51:55 CST 2017
sub select($ $) {
	my %rtnhm = ();
	my %hmvars = %{pop @_};
	my $sql = pop @_;		
	my @idxarr = _sortObject($sql, %hmvars);
	my %result =  (); 
	my $haslimit1 = 0;
	print "\t\tinc::Dba: select: sql:[$sql]\n";
	if((defined($hmvars{'pagesize'}) && $hmvars{'pagesize'} == 1)
		|| index($sql, 'limit 1') > -1){
		%result = $dbconn->readSingle($sql, \%hmvars, \@idxarr);	
		$haslimit1 = 1;
	}
	else{
		%result = $dbconn->readBatch($sql, \%hmvars, \@idxarr);
	}
	if($result{0}){
		$rtnhm{0} = 1;
		$rtnhm{1} = $result{1};
	}
	else{
		$rtnhm{0} = 0;
		$rtnhm{1} = $result{1};
	}
	print "\t\t\tinc::Dba: ret:".%rtnhm."\n";
	return \%rtnhm;
}

#
sub update($ $) {
	my %rtnhm = ();
	my %hmvars = %{pop @_};
	my $sql = pop @_;		
	my @idxarr = _sortObject($sql, %hmvars);
	my %result =  (); 
	%result = $dbconn->query($sql, \%hmvars, \@idxarr);
	if($result{0}){
		$rtnhm{0} = 1;
		my @rows = $result{1};
		my %tmp = ("affectedrows"=>$rows[0], "insertid"=>$rows[1]);
		$rtnhm{1} = %tmp;
	}
	else{
		$rtnhm{0} = 0;
		$rtnhm{1} = $result{1};
	}
	return \%rtnhm;
}

# sort object
sub _sortObject($ $){
	my @rtn = ();
	my $hmvars = pop @_;
	my $sql = pop @_;

	# @todo

	return \@rtn;
}

1;
