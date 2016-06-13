<?php
/* DB Connection config, for all db settings.
 * v0.1
 * wadelau@ufqi.com
 * since Wed Jul 13 18:20:28 UTC 2011
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__."/inc/config.class.php");

# db master
class Config_Master{
	var $mDbHost     = "";	
	var $mDbUser     = "";
	var $mDbPassword = ""; 
	var $mDbPort     = "";	
	var $mDbDatabase = "";
	
	function __construct(){
		$gconf = new Gconf();
		$this->mDbHost = $gconf->get('dbhost');
		$this->mDbPort = $gconf->get('dbport');
		$this->mDbUser = $gconf->get('dbuser');
		$this->mDbPassword = $gconf->get('dbpassword');
		$this->mDbDatabase = $gconf->get('dbname');

	} 
}

# db slave
class Config_Slave{
	var $mDbHost     = "";	
	var $mDbUser     = "";
	var $mDbPassword = ""; 
	var $mDbPort     = "";	
	var $mDbDatabase = "";
	
	function __construct(){
		$gconf = new Gconf();
		$this->mDbHost = $gconf->get('dbhost_slave');
		$this->mDbPort = $gconf->get('dbport_slave');
		$this->mDbUser = $gconf->get('dbuser_slave');
		$this->mDbPassword = $gconf->get('dbpassword_slave');
		$this->mDbDatabase = $gconf->get('dbname_slave');

	} 
}


# cache master
class Cache_Master{
	
	var $chost = '';
	var $cport = '';
	var $expireTime = 30 * 60; 
	
	function __construct(){
		
		$this->chost = Gconf::get('cachehost');
		$this->cport = Gconf::get('cacheport');
		$this->expireTime = Gconf::get('cacheexpire');
		
	}
	
}


//-- Todo

# connection pool ?

?>
