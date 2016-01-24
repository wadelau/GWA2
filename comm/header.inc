<?php 

global $sid, $appdir, $siteid, $user, $userid,$isdbg;
date_default_timezone_set("Asia/Chongqing");

$isdbg = 1;

$docroot = $_SERVER['DOCUMENT_ROOT'];
$rtvdir = dirname(dirname(__FILE__)); # relative dir
$rtvdir = str_replace($docroot,"", $rtvdir);
$appdir = $docroot.$rtvdir;

require($appdir."/inc/config.class.php");
require($appdir."/inc/FileUpload.class.php");
require($appdir."/mod/user.class.php");
require($appdir."/comm/tools.function.php");

$siteid = $_CONFIG['siteid'];

# user info
session_start(); # in developping stage, using php built-in session manager
define('UID',$_CONFIG['agentalias'].'_user_id');
global $data; # variables container for template file
$data = array();

$HTTP_REFERER = parse_url($_SERVER['HTTP_REFERER']);
if (! isset($_SESSION['ref']) || $HTTP_REFERER['path'] != $_SERVER['REDIRECT_URL']){
    $_SESSION['ref'] = array(
        'REDIRECT_URL'=>$_SERVER['REDIRECT_URL'],
        'HTTP_REFERER'=>"{$_SERVER['HTTP_REFERER']}"
    );
}

if(!isset($user)){
    $user = new User(); 
} 
$userid = '';
if(array_key_exists(UID,$_SESSION) && $_SESSION[UID] != '')
{
	$userid = $_SESSION[UID];
	$user->setId($userid);
	$data['islogin'] = 1;
	$data['userid'] = $userid;
	$data['username'] = $user->getUserName();
}

# main content container if no template file
$out = '';

# smarty template engine
require($_CONFIG['smarty']."/Smarty.class.php");
$smt = new Smarty();
$rtvviewdir = $rtvdir."/view/".$siteid;
$viewdir = $appdir.'/view/'.$siteid;
#`print "viewdir:[$viewdir]\n";
$smt->setTemplateDir($viewdir);
$smt->setCompileDir($viewdir.'/compile');
$smt->setConfigDir($viewdir.'/config');
$smt->setCacheDir($viewdir.'/cache');
$smttpl = '';

global $display_style;  
$display_style = $_CONFIG['display_style_index']; 

# page info
header("Content-type: text/html;charset=utf-8");

## RESTful handler
$entry_tag = $_CONFIG['entry_tag'];;
$paraArr = explode("/", $_SERVER['REQUEST_URI']);
$found_entry = 0; $query_string = '';
$paraCount = count($paraArr);
for($i=0; $i<$paraCount; $i++){
	if($paraArr[$i] == $entry_tag){
		$found_entry = 1;
	}	
	else{
		if($found_entry == 1 && $paraArr[$i] != ''){
			$_REQUEST[$paraArr[$i]] = $paraArr[++$i];		
			$query_string .= $paraArr[$i-1]."=".$paraArr[$i].'&';
		}
	}
}
if($query_string != ''){ $query_string = substr($query_string, 0, strlen($query_string)-1); }
$_SERVER['REQUEST_URI'] = $_SERVER['SCRIPT_NAME']; 
$_SERVER['QUERY_STRING'] = $query_string;

$url = $rtvdir.'/'.$entry_tag;
$data['randi'] = rand(10000,999999);

# global variables
if($isdbg){
    $sid = $_REQUEST['sid'];
    if($sid == ''){
      $sid =$_SESSION['sid'];
      if($sid == ''){
        $sid = rand(1000, 999999); $_SESSION['sid'] = $sid;
      }
    }
	else{
		$sid = str_replace('<', '&lt;', $sid);	
	}
    $url .= "/sid/".$sid;
}

# convert user input data to variables, tag#userdatatovar
foreach($_REQUEST as $k=>$v){
    $k = trim($k);
    if($k != ''){
        if(preg_match("/([0-9a-z_]+)/i",$k,$matcharr)){
            $k_orig = $k = $matcharr[1];
			if(is_string($v)){
				$v = trim($v);
			}
            $data[$k] = $v;
            if(preg_match('/[^\x20-\x7e]/', $k)){
                eval("\${$k} = \"$v\";");
            }
        }
		else{
        }
  	}
}

function exception_handler($exception) {
	echo '<div class="alert alert-danger">';
	echo '<b>Fatal error</b>:  Uncaught exception \'' . get_class($exception) . '\' with message ';
	echo $exception->getMessage() . ' .<br/> <!--- please refer to server log. --> Please report this to administrators.';
	error_log($exception->getTraceAsString());
	error_log("thrown in [" . $exception->getFile() . "] on line:[".$exception->getLine()."].");
	echo '</div>';
}
set_exception_handler('exception_handler');


?>
