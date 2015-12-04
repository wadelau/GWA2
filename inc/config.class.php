<?php

# global constant configurations

$tblpre = "";
$conf = array();

# super site id
$conf['siteid'] = 'default'; #'site-18';

$conf['tblpre'] 	= $tblpre;
$conf['appname'] 	= 'Shundaishao';
$conf['appchnname'] 	= '顺带捎';
$conf['appdir']		= $appdir;

$conf['rtvdir'] 	= $rtvdir;
$conf['agentname'] 	= 'Shundaishao';
$conf['agentalias']	= 'SDS';
$conf['smarty']		= $appdir.'/mod/Smarty-3.1.7/libs';

$conf['uploaddir']	= 'upld';
$conf['septag']		= '_J_A_Z_';

$conf['maindb']		= '';
$conf['maintbl']	= $tblpre.'customertbl';
$conf['usertbl']	= $tblpre.'info_usertbl';
$conf['welcometbl']	= $tblpre.'info_welcometbl';
$conf['operatelogtbl']	= $tblpre.'fin_operatelogtbl';

$conf['signkey']	= '-rw-r--r-- 1 bangco users 13 Jul 16 16:28 w.txt';
$conf['adminemail'] = 'info@ufqi.com';

# display style
$conf['display_style_index']		= 0;
$conf['display_style_smttpl']		= 1; 

# db info
$conf['dbhost'] 	= '';
$conf['dbport'] 	= '3306';
$conf['dbuser'] 	= '';
$conf['dbpassword'] 	= '';
$conf['dbname'] 	= $conf['maindb'];

# misc
$conf['is_debug'] = 1;
$conf['html_resp'] = '<!DOCTYPE html><html><head><title>RESP_TITLE</title></head><body>RESP_BODY</body></html>';

############

Gconf::setConf($conf);

global $_CONFIG;
$_CONFIG = Gconf::getConf();

# configuration container

class Gconf{

	private static $conf = array();

	public static function get($key){
		return self::$conf[$key];
	}

	public static function set($key, $value){
		self::$conf[$key] = $value;	
	}

	public static function getConf(){
		return self::$conf;
	}

	public static function setConf($conf){
		foreach($conf as $k=>$v){
			self::set($k, $v);
		}	
	}
}


?>
