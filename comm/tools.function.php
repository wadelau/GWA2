<?php

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
function curlPost($url, array $post = NULL, array $options = array()) 
{ 
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
function sendMail($to,$subject,$body, $from='', $local=0)
{
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
    
	}else if($local == 1){
        global $_CONFIG;
        include($_CONFIG['appdir']."/mod/mailer.class.php");

        $_CONFIG['mail_smtp_server'] = "smtp.163.com";
        $_CONFIG['mail_smtp_username'] = "wadelau@163.com";
        $_CONFIG['mail_smtp_password'] = "myminina.123456";
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

function mkUrl($file, $_REQU){
    $url = $file."?";
    /*
    $noneeddata = array('act','PHPSESSID','JSESSIONID','userufqi','iweb_shoppingcart','iweb_user_id','iweb_user_pwd','iweb_username','iweb_head_ico','iweb_safecode');
    foreach($_REQUEST as $k=>$v){
        if(!in_array($k,$noneeddata)){
            $url .= $k."=".$v."&";
        }
    }
    */
    $needdata = array('id','tbl','db','oid','otbl','oldv','field','linkfield','linkfield2','tit');
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
	echo "<script>".chr(10);
	if(!empty($str)){
		echo "window.alert(\"警告:\\n\\n{$str}\\n\\n\");".chr(10);
	}
	
	#print "window.alert('type:[".$type."]');\n";

	echo "function _r_r_(){";
	$winName=(!empty($topWindow))?"top":"self";
	Switch (StrToLower($type)){
	case "#":
		break;
	case "back":
		echo $winName.".history.go(-1);".chr(10);
		break;
	case "reload":
		echo $winName.".window.location.reload();".chr(10);
		break;
	case "close":
		echo "window.opener=null;window.close();".chr(10);
		break;
	case "function":
		echo "var _T=new Function('return {$topWindow}')();_T();".chr(10);
		break;
		//Die();
	default:
		if($type!=""){
			//echo "window.{$winName}.location.href='{$type}';";
			echo "window.{$winName}.location=('{$type}');";
		}
	}

	echo "}".chr(10);

	//avoid firefox not excute setTimeout
	echo "if(setTimeout(\"_r_r_()\",".$timeout.")==2){_r_r_();}";
	if($timeout==100){
		echo "_r_r_();".chr(10);
	} else {
		echo "setTimeout(\"_r_r_()\",".$timeout.");".chr(10);
	}
	echo "</script>".chr(10);
	exit();
}



/** 
 * URL redirect
 */
function redirect($url, $time=0, $msg='') {
    //multi URL addr support
    $url = str_replace(array("\n", "\r"), '', $url);
    if (empty($msg))
        $msg = "系统将在{$time}秒之后自动跳转到{$url}！";
    if (!headers_sent()) {
        // redirect
        if (0 === $time) {
            header("Location: " . $url);
        } else {
            header("refresh:{$time};url={$url}");
            echo($msg);
        }
        exit();
    } else {
        $str = "<meta http-equiv='Refresh' content='{$time};URL={$url}'>";
        if ($time != 0)
            $str .= $msg;
        exit($str);
    }
}


function isEmail($email){
    if(!preg_match('|^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]{2,})+$|i', $email)){
    
      return 0;
    
    }else{
      
      return 1;

    }
}
?>
