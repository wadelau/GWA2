<?php
# the application entry...

# main logic
$mod = $_REQUEST['mod']; # which mod is requested?
$act = $_REQUEST['act']; # what act needs to do?

if($mod == ""){
  $mod = "index";    
}

# header.inc file
include("./comm/header.inc");


$data['mod'] = $mod;
$data['act'] = $act;
$data['baseurl'] = $baseurl;

if(file_exists("./ctrl/".$mod.".php")){
	include("./ctrl/".$mod.".php");
}
else{
	print "ERROR.";	
	error_log(__FILE__.": found error mod:[$mod]");
	exit(0);
}

$smttpl_orig = $smttpl;

if($mod != 'index'){
  include("./ctrl/index.php");
}

# footer.inc file
include("./comm/footer.inc");

# add more ---

?>
