<?php
#
# global functions, by wadelau@ufqi.com
# update Sat Jul 11 09:20:03 CST 2015
# update 09:56 Tuesday, November 24, 2015
#

/* get Smarty template file name
   wadelau, Wed Feb 15 09:18:27 CST 2012
   */
function getSmtTpl($file, $act){
    $scriptname = explode("/",$file);
    $scriptname = $scriptname[count($scriptname)-1];
    $scriptname = explode(".",$scriptname);
    $scriptname = $scriptname[0];
    return $smttpl = $scriptname.'_'.($act==''?'main':$act).'.html';
}

/** 
 * Send a POST requst using cURL, refer to http://www.php.net/manual/en/function.curl-exec.php 
 * @param string $url to request 
 * @param array $post values to send 
 * @param array $options for cURL 
 * @return string 
 */ 
function curlPost($url, array $post = NULL, array $options = array()){ 
    $defaults = array( 
            CURLOPT_POST => 1, 
            CURLOPT_HEADER => 0, 
            CURLOPT_URL => $url, 
            CURLOPT_FRESH_CONNECT => 1, 
            CURLOPT_RETURNTRANSFER => 1, 
            CURLOPT_FORBID_REUSE => 1, 
            CURLOPT_TIMEOUT => 4, 
            CURLOPT_POSTFIELDS => http_build_query($post) 
            ); 

    $ch = curl_init(); 
    curl_setopt_array($ch, ($options + $defaults)); 
    if( ! $result = curl_exec($ch)) 
    {
        trigger_error(curl_error($ch)); 
    } 
    curl_close($ch); 
    return $result; 
} 

/**
 * send mail by system built-in sendmail commands
 * @para string $to, receiver's email address
 * @para string $subject, email's subject
 * @para string $body, message body
 * return array(0=>true|false, 1=>array('error'=>'...'));
 */
function sendMail($to,$subject,$body, $from='', $local=0){
    $rtnarr = array();
	
	if($local == 0){
		$from = $from==''?$_CONFIG['adminmail']:$from;

		$mailstr = 'To:'.$to.'\n';
		$mailstr .= 'Subject:'.$subject.'\n';
		$mailstr .= 'Content-Type:text/html;charset=UTF-8\n';
		$mailstr .= 'From:'.$from.'\n';
		$mailstr .= '\n';
		$mailstr .= $body.'\n';

		$tmpfile = "/tmp/".GConf::get('agentalias').".user.reg.mail.tmp";
		system('/bin/echo -e "'.$mailstr.'" > '.$tmpfile);  
		system('/bin/cat '.$tmpfile.' | /usr/sbin/sendmail -t &');  

		$rtnarr[0] = true;
    
	}
	else if($local == 1){
        global $_CONFIG;
        include($_CONFIG['appdir']."/mod/mailer.class.php");

        $_CONFIG['mail_smtp_server'] = "smtp.163.com";
        $_CONFIG['mail_smtp_username'] = "wadelau@163.com";
        $_CONFIG['mail_smtp_password'] = "my.minina.123456";
        $_CONFIG['isauth'] = true;
        $_CONFIG['mail_smtp_fromuser'] = $_CONFIG['mail_smtp_username'];

        $mail = new Mailer($_CONFIG['mail_smtp_server'],25,$_CONFIG['isauth'],$_CONFIG['mail_smtp_username'],$_CONFIG['mail_smtp_password']);

        $mail->debug = true;;
        $from==''?'bangco@'.$_CONFIG['agentname']:$from;
        if($_CONFIG['isauth']){
            $from = $_CONFIG['mail_smtp_fromuser'];
        }

        #print __FILE__.": from:$from";
        
        $rtnarr[0] = $mail->sendMail($to, $from, $subject, $body, 'HTML');

    } 

    return $rtnarr;
}

function startsWith($haystack, $needle)
{
    $length = strlen($needle);
    return (substr($haystack, 0, $length) === $needle);
}

function endsWith($haystack, $needle)
{
    $length = strlen($needle);
    $start  = $length * -1; //negative
    return (substr($haystack, $start) === $needle);
}

function inList($needle, $haystack){
    $pos = strpos(",".$haystack.",", ",".$needle.",");
    return ($pos === false ? false : true);
}

function inString($needle, $haystack){
    $pos = stripos($haystack, $needle);
    return ($pos === false ? false : true);
}

function mkUrl($file, $_REQU){
    $url = $file."?";
   
    $needdata = array('id','tbl','db','oid','otbl','oldv','field','linkfield','linkfield2','tit','tblrotate');
    foreach($_REQU as $k=>$v){
        if(in_array($k, $needdata) || startsWith($k,'pn') || startsWith($k, "oppn")){
            if($k == 'oldv'){
                $v = substr($v,0,32); # why? Sun Mar 18 20:40:59 CST 2012
            }
            $url .= $k."=".$v."&";
            #error_log(__FILE__.": $k=$v is detected.");

        }else{
            #error_log(__FILE__.": $k=$v is abandoned.");
        }
    }

    $url = substr($url, 0, strlen($url)-1);
    #print __FILE__.": url:[$url]\n"; 
    return $url;

}

function substr_unicode($str, $s, $l = null) {
    return join("", array_slice(preg_split("//u", $str, -1, PREG_SPLIT_NO_EMPTY), $s, $l));
}

function shortenStr($str, $len=0){
    $newstr = '';
    if($len == 0){
        $len = 10;
    }
    $newstr = substr_unicode($str, 0, $len);

    return $newstr;

}

function base62x($s,$dec=0,$numType=''){
    # e.g. base62x('abcd', 0, '8');
    # e.g. base62x('abcd', 1, '16');
    $type = "-enc";
    if($dec == 1){
        $type = "-dec";
    }
    return $s=exec('/www/webroot/tools/base62x '.$type.($numType==''?'':' -n '.$numType).' \''.$s.'\'');
}

/**
 *	alert
 *	@str : alert info
 *  @type : behavior
 *  @topWindow
 *  @timeout
 */
function alert($str,$type="back",$topWindow="",$timeout=100){
	$str = '';
	$str .= "<script type=\"text/javascript\">".chr(10);
	if(!empty($str)){
		$str .= "window.alert(\"警告:\\n\\n{$str}\\n\\n\");".chr(10);
	}
	#print "window.alert('type:[".$type."]');\n";
	$str .= "function _r_r_(){";
	$winName=(!empty($topWindow))?"top":"self";
	Switch (StrToLower($type)){
		case "#":
			break;
		case "back":
			$str .= $winName.".history.go(-1);".chr(10);
			break;
		case "reload":
			$str .= $winName.".window.location.reload();".chr(10);
			break;
		case "close":
			$str .= "window.opener=null;window.close();".chr(10);
			break;
		case "function":
			$str .= "var _T=new Function('return {$topWindow}')();_T();".chr(10);
			break;
			//Die();
		default:
			if($type!=""){
				//echo "window.{$winName}.location.href='{$type}';";
				$str .= "window.{$winName}.location=('{$type}');";
			}
	}
	$str .= "}".chr(10);
	//avoid firefox not excute setTimeout
	$str .= "if(window.setTimeout(\"_r_r_()\",".$timeout.")==2){_r_r_();}";
	if($timeout==100){
		$str .= "_r_r_();".chr(10);
	}
	else{
		$str .= "window.setTimeout(\"_r_r_()\",".$timeout.");".chr(10);
	}
	$str .= "</script>".chr(10);
	$html = $_CONFIG['html_resp']; $html = str_replace("RESP_TITLE","Alert!", $html); $html = str_replace("RESP_BODY", $str, $html);
	print $html;
	exit();
}

/** 
 * URL redirect, remedy by wadelau@ufqi.com 09:52 Tuesday, November 24, 2015
 */
function redirect($url, $time=0, $msg='') {
    //multi URL addr support ?
    $url = str_replace(array("\n", "\r"), '', $url);
	if(!inString('://', $url)){ # relative to absolute path
		$url = "//".$_SERVER['SERVER_NAME'].":".$_SERVER['SERVER_PORT'].$url;
	}
	if($time < 10){ $time = $time * 1000; } # in case of milliseconds
	$hideMsg = "<!DOCTYPE html><html><head>";
	$hideMsg .= "<meta http-equiv=\"refresh\" content=\"{$time};URL='{$url}'\">";
	$hideMsg .= "</head><body>";  # remedy Mon Nov 23 22:03:24 CST 2015
    if (empty($msg)){
        #$msg = "系统将在{$time}秒之后自动跳转到{$url}！";
		$hideMsg = $hideMsg." <a href=\"".$url."\">系统将在{$time}秒之后自动跳转</a> <!-- {$url}！--> ...";
	}
	else{
		$hideMsg = $hideMsg . $msg;
	}
	$hideMsg .= "<script type='text/javascript'>window.setTimeout(function(){window.location.href='".$url."';}, ".$time.");</script>";
	$hideMsg .= "</body></html>";
    if (!headers_sent()) {
        // redirect
        if (1 || 0 === $time) {
            header("Location: " . $url);
			print $hideMsg;
        } 
        else if(0){  # Refresh in HTTP is non-standard.
            header("Refresh:{$time};url={$url}");
            echo($msg);
        }
        exit();
    } 
    else{
        print $hideMsg;
        exit();
    }
}

# added by wadelau@ufqi.com,  Wed Oct 24 09:54:10 CST 2012
function isImg($file){
	$isimg = 0;
	if($file != ''){
		$tmpfileext = substr($file, strlen($file)-4);
		if(in_array($tmpfileext,array("jpeg",".jpg",".png",".gif",".bmp"))){
			$isimg = 1;    
		}   
	}       
	return $isimg;

}  

function isEmail($email){
    if(!preg_match('|^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]{2,})+$|i', $email)){
    	return 0;
    }
    else{
      return 1;
    }
}

# get Ids list from array|hash
# by wadelau@ufqi.com, Sat Jul 11 09:21:13 CST 2015
function getIdList($iarray, $ikey){
	$tmpIds = "999999,";

	foreach($iarray as $k=>$v){
		$tmpIds .= $v[$ikey].",";
	}
	$tmpIds = substr($tmpIds, 0, strlen($tmpIds)-1);

	return $tmpIds;

}

# write log in a simple approach
# by wadelau@ufqi.com, Sat Oct 17 17:38:26 CST 2015
# e.g. 
# debug($user); 
# debug($user, 'userinfo');  # with tag 'userinfo'
# debug($user, 'userinfo', 1); # with tag 'userinfo' and in backend and frontend
function debug($obj, $tag='', $output=null){
	$caller = debug_backtrace();
	if(is_array($obj) || is_object($obj)){
		if(isset($user)){
			$s .= $user->toString($obj);
		}
		else{
			$s .= serialize($obj);
		}
	}
	else{
		$s .= $obj;
	}

	if($tag != ''){
		$s = " $tag:[$s]";
	}
	$callidx = count($caller) - 2; 
	$s .= ' func:['.$caller[$callidx]['function'].'] file:['.$caller[$callidx]['file'].']';

	if($output != null){
		if($output == 0){ # in backend only
			error_log($s); 
		}
		else if($output == 1){ # in backend and frontend
			error_log($s);
			print $s;
		}
		else if($output == 2){ # in backend and frontend with backtrace
			$s .= " backtrace:[".serialize($caller)."]";
			error_log($s);
			print $s;	
		}
	}
	else{ 
		error_log($s); # default mode
	}
	
}

# resize image by GD functions
# wadelau@ufqi.com, Thu Jan 28 22:04:14 CST 2016
# return resized image
# $toWidth: int, 10~10000 ?
# $percentNum: float, 0~1
# e.g. $destFile = resizeImage($srcFile, 1024);
# e.g. $destFile = resizeImage($srcFile, 0, 0.55);
function resizeImage($srcFile, $toWidth, $percentNum=1, $destQuality=85){

	$keepSame = 1; # 0 for cutting edges, 1 for not cutting
	$edgeCutRate = 7; # 2~10, 10 for least edge-cutting...  
	$centerRate = 1.5; # 1~5, 5 for largest leaving center...

	$srcInfo = getimagesize($srcFile); # http://www.php.net/getimagesize
	$srcWidth = $srcInfo[0];
	$srcHeight = $srcInfo[1];
	$srcType = $srcInfo[2];

	if($toWidth == 0){
		if($percentNum == 1 || $percentNum == 0){
			debug($toWidth, "toWidth-percentNum-eRror");
		}
		else{ $toWidth = $srcWidth * $percentNum; }	
	}
	else if($percentNum == 1){
		$percentNum = $toWidth / $srcWidth;
	}
	$toHeight = (int)$srcHeight * ($toWidth/$srcWidth);

	$src_x_pos = 0;
	if(1 && $srcWidth > $toWidth){
		$src_x_pos = ($srcWidth - $toWidth) / $edgeCutRate;
		$srcWidth -= $src_x_pos * $centerRate;
	}
	else{
		#$toWidth = $srcWidth; # for enlarge /scale up
	}
	$src_y_pos = 0;
	if(1 && $srcHeight > $toHeight){
		$src_y_pos = ($srcHeight - $toHeight) / $edgeCutRate;
		$srcHeight -= $src_y_pos * $centerRate;
	}
	else{
		#$toHeight = $srcHeight; 
	}
	$dest_x_pos = 0; $dest_y_pos = 0;
	#debug($src_x_pos.",".$src_y_pos.",".$percentNum);

	$srcImage = null;
	if($srcType == 1){ # 'image/gif')
		$srcImage = imagecreatefromgif($srcFile);
	}
	else if($srcType == 2){ # 'image/jpeg'
		$srcImage = imagecreatefromjpeg($srcFile);
	}
	elseif($srcType == 3){ # 'image/png'
		$srcImage = imagecreatefrompng($srcFile);
	}
	elseif($srcType == 17){ # 'image/webp', still unavailable
		$srcImage = imagecreatefrompng($srcFile);
	}

	$lastDot = strrpos($srcFile, '.');
	$destFile = substr($srcFile, 0, $lastDot).'_rs_'.$toWidth.'_'.$percentNum.'.'.substr($srcFile, $lastDot+1, strlen($srcFile));				
	if($keepSame == 0){
		$destImage = imagecreatetruecolor($toWidth, $toHeight);
		imagecopyresampled($destImage, $srcImage, 
			$dest_x_pos, $dest_y_pos, $src_x_pos, $src_y_pos, 
				$toWidth, $toHeight, $srcWidth, $srcHeight);
	}
	else{
		$destImage = imagescale($srcImage, $toWidth, $toHeight);
	}

	$destQuality = $destQuality * $percentNum;
	$destQuality = $destQuality > 100 ? 100 : $destQuality;
	if($srcType == 1){
		imagegif($destImage, $destFile, $destQuality);
	}
	else if($srcType == 2){ 
		imagejpeg($destImage, $destFile, $destQuality);
	}
	elseif($srcType == 3){ 
		imagepng($destImage, $destFile, $destQuality);
	}
	elseif($srcType == 17){ 
		imagewebp($destImage, $destFile, $destQuality);
	}
	
	return $destFile;
	
}

