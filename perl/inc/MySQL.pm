package inc::MySQL;

use strict;
use warnings;
use Cwd qw(abs_path realpath);
use File::Basename qw(dirname basename);
use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );
use autodie;

use DBI;
use DBD::mysql;

#use parent 'inc::DBA';
use inc::Config;

my $_ROOT_ = dirname(abs_path($0));
my ($m_host, $m_port, $m_user, $m_password, $m_name, $_link, $m_sock)
	= ('', '', '', '', '', '', '');
my ($dbh, $sth, $sql, $rs, $row) = (undef, undef, 0, 0, 0);
my $isdbg = 1;

#
sub new {
	my $class = shift;
	my $self = {}; # {@_};
	my $conf = shift;
	my %conf = %{$conf};
	$self->{m_host} = $m_host = $conf{'mDbHost'};
	print "\t\t\tinc::MySQL: m_host:$m_host\n";
	$self->{m_port} = $m_port = $conf{'mDbPort'};
	$self->{m_user} = $m_user = $conf{'mDbUser'};
	$self->{m_password} = $m_password = $conf{'mDbPassword'};
	$self->{m_name} = $m_name = $conf{'mDbDatabase'};
	$self->{m_sock} = $m_sock = $conf{'mDbSock'};

	bless $self, $class;
	return $self;
}

#
# refined by Xenxin@ufqi.com, Mon Jan 23 22:35:23 CST 2017
sub query($ $ $) {
	my $idxarr = pop @_;
	my $hmvars = pop @_;
	my $sql = pop @_;
	if(!defined($dbh)){
		$dbh = _initConnection();	
	}
	$sql = _enSafe($sql, $hmvars, $idxarr);
	$sth = $dbh->prepare($sql);
	$sth->execute();
	my @rows = [];
	$rows[0] = $sth->rows; # affected rows
	$rows[1] = $dbh->last_insert_id(undef, undef, undef, undef); # 
	$sth->finish();
	return ('0'=>1, '1'=>\@rows);
}

#
# by Xenxin@ufqi.com since Sun Jan  1 22:54:18 CST 2017
sub readSingle($ $ $) {
	my $idxarr = pop @_;
	my $hmvars = pop @_;
	my $sql = pop @_;
	if(!defined($dbh)){
		$dbh = _initConnection();	
	}
	$sql = _enSafe($sql, $hmvars, $idxarr);
	$sth = $dbh->prepare($sql);
	$sth->execute();
	my @rows = []; 
	if(my $ref = $sth->fetchrow_hashref()){
		$rows[0] = $ref;		
	}
	$sth->finish();
	return ('0'=>1, '1'=>\@rows);
}

# by Xenxin@ufqi.com since  Mon Jan 23 21:07:09 CST 2017
sub readBatch($ $ $) {
	my $idxarr = pop @_;
	my $hmvars = pop @_;
	my $sql = pop @_;
	if(!defined($dbh)){
		$dbh = _initConnection();	
	}
	$sql = _enSafe($sql, $hmvars, $idxarr);
	print "\t\tinc::MySql: readBatch: sql:[$sql]\n";
	$sth = $dbh->prepare($sql);
	$sth->execute();
	my @rows = []; my $i = 0;
	while(my $ref = $sth->fetchrow_hashref()){
		$rows[$i++] = $ref;		
	}
	$sth->finish();
	return ('0'=>1, '1'=>\@rows);
}

# 
# Xenxin@ufqi.com, Sun Jan  1 22:52:34 CST 2017
sub _initConnection {
	$dbh = DBI->connect("DBI:mysql:database=$m_name;host=$m_host", 
		$m_user, 
		$m_password, 
		{'RaiseError'=>1, 'mysql_enable_utf8'=>1, 'AutoCommit'=>1}) or warn "cannot connect to mysql server. errno:["
			.$dbh->err."] errmsg:[".$dbh->errstr."]. 17011201556.";		
	print "\t\t\tinc::MySQL: initConnection....".time()."\n";
	return $dbh;
}

#
sub _enSafe($ $ $){
	my $idxarr = pop @_;
	my $hmvars = pop @_;
	my $sql = pop @_;

		# @todo
		# $sth->bind_param, instead of, refer to GWA2 in Java

	return $sql;
}

1;
