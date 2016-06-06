<?php
# the application entry...

# cli
if(0){ # in some scenarios, this should be set as 0 to disable this function globally. only if php script is being run from command line, see comm/cmdline.php for details
	if($argv && $argc > 0){ 
		# path
		ini_set('include_path', get_include_path(). PATH_SEPARATOR . dirname($_SERVER['PHP_SELF']));
		ini_set('max_execution_time', 0);
		
		chdir(dirname(__FILE__));
		include("./comm/cmdline.inc");
		chdir(dirname(__FILE__));

	}	
}

# routing 
$mod = $_REQUEST['mod']; # which mod is requested?
$act = $_REQUEST['act']; # what act needs to do?
if($mod == ""){
  $mod = "index";    
}

# main logic 
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

# default or common
if($mod != 'index'){
  include("./ctrl/index.php"); # here is buggy, any unshared business logic should not be placed in index mod.
}

# footer.inc file
include("./comm/footer.inc");

# add more ---

?>
