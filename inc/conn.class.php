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

class Config_slave{
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

//-- Todo

# connection pool ?

?>
