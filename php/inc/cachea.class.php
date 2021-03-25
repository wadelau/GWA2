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
	var $sanitizeKeys = true; # clean format for short keys, need Base62x if true, 21:11 2021-03-23
	const Max_Plain_Key_Length = 32;
	
 	//- construct
	function __construct($cacheConf = null){	
		$cacheConf = ($cacheConf==null ? 'Cache_Master' : $cacheConf);
		$this->conf = new $cacheConf;
		$cacheDriver = GConf::get('cachedriver');
		$this->cacheconn = new $cacheDriver($this->conf);
	}
	
	//-
	function __destruct(){
		$this->close();
		$this->cacheconn = null;
	}

	# get
	public function get($k){
		
		$k = $this->_md5k($k);
		return $this->cacheconn->get($k);
				
	}
	
	# set
	public function set($k, $v, $expr=0){
		
		$k = $this->_md5k($k);
		$rtn = $this->cacheconn->set($k, $v, $expr);
		
		return $rtn;
		
	}
	
	# delete
	public function rm($k){
		
		$k = $this->_md5k($k);
		$rtn = $this->cacheconn->del($k);
		
		return $rtn;
		
	}
	
	# shorten key, with sanitizeKeys, 21:17 2021-03-23
	private function _md5k($k){
		if(strlen($k) > self::Max_Plain_Key_Length){
			$k = md5($k);
		}
		else{
			if($this->sanitizeKeys){
				$k = Base62x::encode($k);
			}
			//- leave it as plain text
		}
		return  $k;
	}
 	
	//-
	function close(){
	    # @todo, long conn?
	    # need sub class to override with actual close handler
	    $this->cacheconn->close();
	    return true;
	}
 }
?>
