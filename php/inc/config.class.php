<?php
############
# global constant configurations
if(true){
	
	$conf = array();

	$conf['siteid'] = 'default'; # super site id or template them code or id, e.g. 'site-18'
	$tblpre = "TABLE_PRE";
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
	$conf['dbdriver']	= 'MYSQL'; # 'MYSQL', 'MYSQLIX', 'PDOX', 'SQLSERVER', 'ORACLE' in support, UPCASE only

	# cache server
	$conf['enable_cache'] = 1; # or true for 1, false for 0
	$conf['cachehost'] = '127.0.0.1'; # '/www/bin/memcached/memcached.sock'; #  ip, domain or .sock
	$conf['cacheport'] = '11211'; # empty or '0' for linux/unix socket 
	$conf['cachedriver'] = 'MEMCACHEDX'; # REDISX, XCACHEX
	$conf['cacheexpire'] = 30 * 60;
	
	# misc
	$conf['is_debug'] = 1;
	$conf['html_resp'] = '<!DOCTYPE html><html><head><title>RESP_TITLE</title></head><body>RESP_BODY</body></html>';
	$conf['entry_tag'] = 'i'; # application name or entry name for the application, added by wadelau@ufqi.com on Sun Jan 24 13:42:16 CST 2016
	
	$conf['auto_install'] = 'INSTALL_AUTO';
	$conf['no_sql_check'] = 'omit_sql_security_check'; # keep original form of sql in some cases, 14:24 Friday, May 20, 2016, refer: http://php.net/manual/en/mysqli-stmt.bind-param.php, "2 asb(.d o,t )han(a t)n i h e i(d.o_t)dk ¶"
	$conf['allow_run_from_cli'] = 0; # keep 0 for most, only if run php from command line, 21:41 02 June 2016

	# set to global container
	Gconf::setConf($conf);
	
}
############

global $_CONFIG;
$_CONFIG = Gconf::getConf();

# configuration container

class Gconf{

	private static $conf = array();

	//-
	public static function get($key){
		return self::$conf[$key];
	}

	//-
	public static function set($key, $value){
		self::$conf[$key] = $value;	
	}

	//-
	public static function getConf(){
		return self::$conf;
	}

	//-
	public static function setConf($conf){
		foreach($conf as $k=>$v){
			self::set($k, $v);
		}	
	}
	
}


?>
