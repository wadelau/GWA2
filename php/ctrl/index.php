<?php

# controlling of homepage
include_once($appdir."/ctrl/include/language.php");
#include_once($appdir."/mod/poll.class.php");

#
# actions

$act = $act == '' ? 'index' : $act;

if($mod == "index"){ # something displayed in homepage only, 09:55 11 June 2016
	
	if($act == 'index'){
		#
		
	}
	else{
		$data['resp'] = "Unknown act:[$act].";
		
	}

}
else{
	
	# something shared across the app,
	# e.g. page header and page footer
	
}

$data['time'] = date("H:i", time());


# tpl

if($out == '' && $smttpl == ''){ # if other module do not define a smttpl and $conf['display_style_smttpl']? 
	if(isset($fmt) && $fmt == 'json'){
		# API
	}
	else{
		$smttpl = 'homepage.html';
	}
}

?>
