<?php

# global constant configurations

$tblpre = "TABLE_PRE";
$conf = array();

# super site id
$conf['siteid'] = 'default'; # or template them code or id, e.g. 'site-18'

$conf['tblpre'] 	= $tblpre;
$conf['appname'] 	= '-GWA2';
$conf['appchnname'] 	= '-通用网络应用架构';
$conf['appdir']		= $appdir;

$conf['rtvdir'] 	= $rtvdir;
$conf['agentname'] 	= 'AGENT_NAME';
$conf['agentalias']	= 'AGENT_ALIAS';
$conf['smarty']		= $appdir.'/mod/Smarty-3.1.7/libs';

$conf['uploaddir']	= 'upld';
$conf['septag']		= '_J_A_Z_';

$conf['maindb']		= 'DB_NAME';
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
$conf['dbhost'] 	= 'DB_HOST';
$conf['dbport'] 	= 'DB_PORT';
$conf['dbuser'] 	= 'DB_USER';
$conf['dbpassword'] 	= 'DB_PASSWORD';
$conf['dbname'] 	= $conf['maindb'];

# misc
$conf['is_debug'] = 1;
$conf['html_resp'] = '<!DOCTYPE html><html><head><title>RESP_TITLE</title></head><body>RESP_BODY</body></html>';
$conf['entry_tag'] = 'i'; # application name or entry name for the application, added by wadelau@ufqi.com on Sun Jan 24 13:42:16 CST 2016
$conf['auto_install'] = 'INSTALL_AUTO';
$conf['no_sql_check'] = 'omit_sql_security_check'; # keep original form of sql in some cases, 14:24 Friday, May 20, 2016

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
