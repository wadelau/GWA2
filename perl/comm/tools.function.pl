#!/usr/bin/perl -w

# comm/tools.function.pl

use strict;
use warnings;
use CGI;

my $argvsize = scalar @ARGV;
my %hmf = (); # runtime container
%hmf = %{$ARGV[$argvsize-1]}; # return from controller

my $i = $hmf{'i'}; 
my $out = $hmf{'out'};
my $fmt = $hmf{'fmt'};
my $r = $hmf{'r'};

# Mon Feb 27 22:08:08 CST 2017
# refer: http://perldoc.perl.org/functions/ref.html
sub debug{ # ($ $)
	my $self = $_[0];
	my $argc = scalar @_;
	my @origarr = @_;
	my ($tgt, $tag) = ('', '');
	if($argc == 2){
		$tgt = pop @_;
	}
	else{ # 3
		$tag = pop @_;	
		$tgt = pop @_;
	}
	my $cont = ""; my $t = ref($tgt); 
	my $i = 0; my $tabs = DBL_TBL;
	if($t eq ''){ $t = ref(\$tgt); }
	if($t eq "ARRAY"){
		my @tgt = @{$tgt};
		for($i=0; $i<@{$tgt}; $i++){
			$cont .= $tabs."i:[$i] v:[".$tgt[$i]."]\n";
		}	
	}
	elsif($t eq "REF" || $t eq "HASH"){
		foreach my $k(keys %{$tgt}){
			$cont .= $tabs."k:[$k] v:[".$tgt->{$k}."]\n";	
		}
	}
	elsif($t eq "SCALAR"){
		for($i=0; $i<@origarr; $i++){
			$cont .= $tabs."i:[$i] v:[".$origarr[$i]."]\n";
			my $tt = ref($origarr[$i]);
			if($tt=~/HASH/){
				foreach my $ttk(keys %{$origarr[$i]}){
					$cont .= $tabs."\t$ttk => ".$origarr[$i]{$ttk}."\n";
				}	
			}
			elsif($tt=~/ARRAY/){
				for(my $tti=0; $tti<@{$origarr[$i]}; $tti++){
					$cont .= $tabs."\t$tti => ".$origarr[$i][$tti]."\n";
				}
			}
		}	
		$tag = 'var';
	}
	else{
		$cont .= $tabs."UNK type. 1702272109.";	
	}
	if($tag eq '' || $tag =~/0-9/){
		$tag = 'var';	
	}
	my ($packagep, $filenamep, $linep, $subrtp) = caller($i=1); # parent
	my ($package, $filename, $line, $subrt) = caller($i=0);
	print $tabs."comm/tools::debug: $tag:[".(\$tgt)."] type:[$t]\n".$cont.$tabs."line:[$line] file:[$filename]";
	if(defined($linep)){
		print " pline:[$linep] pfile:[$filenamep]";
	}
	print "\n";
}

$ARGV[$argvsize] = \%hmf; # return to parent

1;
