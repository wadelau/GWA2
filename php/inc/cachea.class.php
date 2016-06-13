<?php
/* Cache service connection, connecting app with cache data for high performance
 * v0.1
 * wadelau@ufqi.com
 * Sat Jul 23 09:50:58 UTC 2011
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__."/inc/config.class.php");
require_once(__ROOT__."/inc/socket.class.php");
require_once(__ROOT__."/inc/memcached.class.php");
#require_once(__ROOT__."/inc/class.connectionpool.php");

class CacheA {

	var $conf = null; 
	var $cacheconn = null;
	
 	//- construct
	function __construct($cacheConf = null){
		
		$cacheConf = ($cacheConf==null ? 'Cache_Master' : $cacheConf);
		$this->conf = new $cacheConf;
		$cacheDriver = Gconf::get('cachedriver');
		$this->cacheconn = new $cacheDriver($this->conf);
		
	}

	# get
	public function get($k){
		
		return $this->cacheconn->get($k);
				
	}
	
	# set
	public function set($k, $v){
		
		print __FILE__.": k:$k, v:$v\n";
		$rtn = $this->cacheconn->set($k, $v);
		
		return $rtn;
		
	}
	
	# delete
	public function rm($k){
		
		$rtn = $this->cacheconn->del($k);
		
		return $rtn;
		
	}
	
 	
 }
?>
