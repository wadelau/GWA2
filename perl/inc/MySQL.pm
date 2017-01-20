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
sub query {
	# @todo
}

#
# by Xenxin@ufqi.com since Sun Jan  1 22:54:18 CST 2017
sub readSingle {
	my $sql2 = "this is resultset via inc::MySQL->query, time:".time().", dbname:[".$m_host."]";
	if(!defined($dbh)){
		$dbh = _initConnection();	
	}
	$sql = "show tables";
	$sth = $dbh->prepare($sql);
	$sth->execute();
	my @rows = []; my $i = 0;
	while(my $ref = $sth->fetchrow_hashref()){
		#foreach(keys $ref){
		#	print "\t\t\tk:$_ v:".$ref->{$_}."\n";	
		#}
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
		{'RaiseError'=>1, 'mysql_enable_utf8'=>1, 'AutoCommit'=>1}) or warn "cannot connect to mysql server. 17011201556.";		
	print "\t\t\tinc::MySQL: initConnection....".time()."\n";
	return $dbh;
}

1;
