<?php
if($isoput){
	if($isheader){
		# other stuff
	}
	$out .= "</body></html>";
}

#print_r($data);
#print __FILE__.": out:[$out]";

if($smttpl != ''){

	$data['smttpl'] = $smttpl;
	$data['url'] = $url;	
	$data['req'] = $_REQUEST; # also see comm/header.inc tag#userdatatovar 
	$data['ses'] = $_SESSION;
	$data['viewdir'] = $rtvviewdir; # where and why?
	$data['rtvdir'] = $rtvdir; # refer view/default/include/sitefeedback.html
	foreach($data as $k=>$v){
		$smt->assign($k, $v);
	}
	#print_r($data);
	#$smt->display($smttpl);
	
	if(1){
		$markfile = $appdir."/tmp/tpl_last_modified.tmp"; # todo: cache the modified tpl file
		$s_indextpl = $viewdir."/index.html";
		$s_smttpl = $viewdir."/".$smttpl;

		$indexcontent = file_get_contents($s_indextpl);
		$tplcontent = file_get_contents($s_smttpl);

		$resrclist = array("images","css","js","pics");
		foreach($resrclist as $k=>$v){
			$indexcontent = preg_replace("/\"$v\//", "\"".$rtvdir."/view/".$siteid."/$v/", $indexcontent);
			$tplcontent = preg_replace("/\"$v\//", "\"".$rtvdir."/view/".$siteid."/$v/", $tplcontent);
		}

		file_put_contents($s_indextpl.".tmp", $indexcontent);
		file_put_contents($s_smttpl.".tmp", $tplcontent);
	}

	if($display_style == $_CONFIG['display_style_index']){
		
		$smttpl = $smttpl.".tmp";
		$smt->assign('smttpl', $smttpl);

		$smt->display('index.html.tmp'); # use index.html, $smttpl would be embedded in index.html by smarty, updated on Sun Jul 29 09:59:29 CST 2012

	}else if($display_style == $_CONFIG['display_style_smttpl']){

		$smt->display($smttpl.".tmp"); # use template file only
	
	}else{
		error_log(__FILE__.": something wrong with display style and smttpl:$smttpl .");				
	}

}else{
	#error_log(__FILE__.": smttpl is empty. not display with Smarty.req:[".$_SERVER['REQUEST_URI']);
	print $out;
}

#error_log(__FILE__.": out:[".$out."]");
#error_log(date("m-d H:i:s").": ".__FILE__.": request:[".$_SERVER['REQUEST_URI']."] query_string:[".$_SERVER['QUERY_STRING']."] smttpl:[$smttpl]");

# write log
#include($appdir."/act/writelog.php");

$gtbl = null;
$user = null;
$smt = null;
$out = null;

#print_r(UID);
#print_r($_SESSION);

?>
