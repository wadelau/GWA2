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
#use Try::Tiny;

use parent 'inc::WebInterface';
use inc::Config qw(GConf);
use inc::Dba;

my $_ROOT_ = dirname(abs_path($0));
use constant VER => 0.01;
my $dba = {};
my %hm = (); # [];
my %hmf = ();
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
	my $self = {@_};
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
sub get($){
	my $k = pop @_; # @_[1]; # shift;
	return $hmf{$k};
}

# 
sub set($ $){
	# @_[0]:self module; @_[1]:args-1; @_[1]:args-2
	my $v = pop @_; # last one, in case of two (outer caller) or three (inner caller) arguments
	my $k = pop @_;
	$hmf{$k} = $v;
	return 1;
}

# 
sub getId{
	return get($myId);	
}

#
sub setId($){
	my $v = pop @_; # @_[1];
	set($myId, $v);
	return 1;
}

#
sub setMyId($){
	my $v = pop @_;
	$myId = $v;		
}

#
sub getTbl{
	return get(GWA2_TBL);	
}

#
sub setTbl($){
	my $v = pop @_; # @_[1];
	my $tblpre = inc::Config::get('tblpre'); # use qw ?
	print "\t\tinc::WebApp: setTbl: tblpre:[$tblpre]\n";
	set(GWA2_TBL, $v);
	return 1;
}

#
# by Xenxin@ufqi.com since Sun Jan  1 22:54:54 CST 2017
sub getBy($ $ $) {
	print "\t\tinc::WebApp: getBy: argc:".(scalar @_).", argv:@_\n";
	my $argc = scalar @_;
	my ($withCache, $conditions, $fields) = (0, '', ''); # pop @_;
	if($argc == 3){
		$conditions = pop @_;
		$fields = pop @_;
	}
	elsif($argc == 4){
		$withCache = pop @_;
		$conditions = pop @_;
		$fields = pop @_;
	}
	my %result = (); 
	if(1){
		my $sql = "";
		my %hm = ();
		my $haslimit1 = 0;
		my $pagenum = 1;
		my $pagesize = 0;
		if(defined($hmf{'pagenum'})){ $pagenum=$hmf{'pagenum'}; }
		if(defined($hmf{'pagesize'})){ $pagesize=$hmf{'pagesize'}; }
		$sql = "select $fields from ".getTbl()." where ";
		my $idval = getId(); $idval = defined($idval) ? '' : $idval;
		if($conditions eq ""){
			if($idval ne ""){
				$sql .= $myId."=? ";
				$haslimit1 = 1;
			}
			else{
				$sql .= "1=1 ";
			}
		}
		else{
			$sql .= $conditions;		
		}
		if(defined($hmf{'groupby'})){ $sql .= " group by ".$hmf{'orderby'}; }
		if(defined($hmf{'orderby'})){ $sql .= " order by ".$hmf{'orderby'}; }
		if($haslimit1 == 1){
			$sql .= " limit 1";	
		}
		else{
			if($pagesize == 0){ $pagesize = 99999; } # default maxium records per page
			$sql .= " limit ".(($pagenum-1)*$pagesize).", ".$pagesize;	
		}
		print "\t\t\tinc::WebApp: getBy: sql:[$sql] result:".%result."\n";
		my $result = $dba->select($sql, \%hmf);
		%result = %{$result};
		print "\t\t\tinc::WebApp: getBy: sql:[$sql] result:".%result."\n";
	}	
	return \%result;
}

# 
sub setBy($ $){
	my %result = (); 
	print "\t\tinc::WebApp: setBy: argc:".(scalar @_).", argv:@_\n";
	my $argc = scalar @_;
	my ($conditions, $fields) = ('', ''); # pop @_;
	$conditions = pop @_;
	$fields = pop @_;
	my $idval = getId(); $idval = !defined($idval) ? '' : $idval;
	if(1){
		my $sql = '';
		my $isupdate = 0;
		if($idval eq '' && ($conditions eq '')){
			$sql .= "insert into ".getTbl()." set ";
		}
		else{
			$sql .= "update ".getTbl()." set ";	
			$isupdate = 1;
		}
		my @fieldarr = split(/,/, $fields);
		my $fieldcount = scalar @fieldarr;
		my $field = '';
		for(my $i=0; $i<$fieldcount; $i++){
			$field = trim($fieldarr[$i]);
			if($field eq 'updatetime' || $field eq 'inserttime' || $field eq 'createtime'){
				$sql .= "$field=NOW(), ";
				delete $hmf{$field};
			}	
			else{
				$sql .= "$field=?, ";	
			}
		}
		$sql = substr($sql, 0, length($sql)-2); #
		my $issqlready = 1;
		if($conditions eq ''){
			if($idval ne ''){
				$sql .= " where ".$myId."=? ";	
			}
			elsif($isupdate == 1){
				$issqlready = 0;
				$result{0} = 0;
				$result{1} = ("error"=>"Unconditional update is forbidden. 1701232229.");
			}
		}
		else{
			$sql .= " where ".$conditions;	
		}
		print "\t\tinc::WebApp: setBy: sql:[$sql]\n";
		if($issqlready == 1){
			if($idval ne ''){ $hmf{'pagesize'} = 1; }	
			%result = $dba->update($sql, \%hmf);
		}
	}	
	return \%result;
}

#
sub getEnv {
	return "ver:[".VER."] root:[".$_ROOT_."]";	
}

#
sub trim($){
	my $s = shift;
	$s =~ s/^\s+|\s+$//g;
	return $s;
}

1;
