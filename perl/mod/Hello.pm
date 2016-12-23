#!/usr/bin/perl -w

use strict;
use warnings;

package mod::Hello;

use parent 'inc::WebApp';
#extends 'mod::Hello';

sub new {
	my $class = shift;
	my $self = {
		_firstname => shift,
		_lastname => shift,
	};
	bless $self, $class;
	print "\t\tmod/Hello.pm: init with firstname:["
		.$self->{_firstname}."] at time:[".time()."].\n\n";
	return $self;
}

1;
