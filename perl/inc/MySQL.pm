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

#use parent 'inc::DBA';
use inc::Config;

my $_ROOT_ = dirname(abs_path($0));
my ($m_host, $m_port, $m_user, $m_password, $m_name, $_link, $m_sock)
	= ('', '', '', '', '', '', '');
my $isdbg = 1;

#
sub new {
	my $class = shift;
	my $self = {};
	my $conf = shift;
	my %conf = %{$conf};
	$self->{m_host} = $conf{'mDbHost'};
	$self->{m_port} = $conf{'mDbPort'};
	$self->{m_user} = $conf{'mDbUser'};
	$self->{m_password} = $conf{'mDbPassword'};
	$self->{m_name} = $conf{'mDbDatabase'};
	$self->{m_sock} = $conf{'mDbSock'};

	bless $self, $class;
	return $self;
}

#
sub query {
	# @todo
}

#
sub readSingle {
	my $sql = "this is resultset via inc::MySQL->query, time:".time();
	return ('0'=>1, '1'=>$sql);
}

1;
