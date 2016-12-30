package inc::Conn;

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
my $isdbg = 1;

#
{
	package inc::Conn::MasterDB;

	sub new {
		my $class = shift;
		my $self = {};
		my $conf = (); # shift;
		my %conf = (); # %{$conf};

		# @todo
		# read from inc::Config automatically 

		$self->{mDbHost} = $conf{'mDbHost'};
		$self->{mDbPort} = $conf{'mDbPort'};
		$self->{mDbUser} = $conf{'mDbUser'};
		$self->{mDbPassword} = $conf{'mDbPassword'};
		$self->{mDbDatabase} = $conf{'mDbDatabase'};
		$self->{mDbSock} = $conf{'mDbSock'};

		bless $self, $class;
		return $self;
	}

}

#
{
	package inc::Conn::SlaveDB;

	sub new {
		# @todo		
	}
}

1;
