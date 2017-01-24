package inc::Config;

use strict;
use warnings;

#use parent 'inc::WebInterface';

# main body of Config

my %conf = (

	# app info, Xenxin@ufqi.com, Sun Jan  1 22:53:14 CST 2017
	'siteid' => 'default',
	'tblpre' => 'TABLE_PRE',
	'appname' => '-GWA2',

	# db info
	'dbhost' => '127.0.0.1',
	'dbport' => '3306',
	'dbuser' => '',
	'dbpassword' => '',
	'dbname' => '',
	'dbdriver' => 'mysql',
	'dbsock' => '/www/bin/mysql/mysql.sock',
	'db_enable_utf8_affirm' => 1,

);

#
sub new {
	my $class = shift;
	my $args = shift;
	my $self = {}; #{@_};
	$self = \%conf;

	bless $self, $class;	
	return $self;
}

#
sub get($){
	my $key = shift;
	return $conf{$key};
}

#
sub set($ $){
	my $key = shift;
	my $value = shift;
	$conf{$key} = $value;
}

#
sub getConf(){
	return %conf;	
}

#
sub setConf(%){
	my $cf = shift;
	my %cf = %{$cf};
	foreach(keys %cf){
		$conf{$_} = $cf{$_};	
	}	
}

#

1;
