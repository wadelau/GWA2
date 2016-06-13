<?php
/* memcache service, work with cachea.class
 * v0.1
 * wadelau@ufqi.com
 * Sat Jul 23 09:50:58 UTC 2011
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__."/inc/config.class.php");
require_once(__ROOT__."/inc/socket.class.php");
#require_once(__ROOT__."/inc/class.connectionpool.php");

class MEMCACHEDX {

	var $cport = '';
	var $chost = '';
	var $mcache = null;
	var $persistConnId = 'GWA2_BUILD_IN_MC';
	var $expireTime = 30 * 60; # 30 minutes
	
 	//- construct
	function __construct($config=null){
		
		$this->cport = $config->cport;
		$this->chost = $config->chost;
		$this->expireTime = $config->expireTime;
		
		if(true){
			//- use built-in memcache functions
			$this->mcache = new Memcached($this->persistConnId);
			$servers = $this->mcache->getServerList(); 
			$isConnected = 0;
			if(is_array($servers)) { 
				foreach ($servers as $server) {
					if(($server['host'] == $this->chost and $server['port'] == $this->cport)
						|| ($server['host'] == 'localhost')
					) {
						$isConnected = 1;
						break;
					}
				}
			}
			if(!$isConnected){
				$this->mcache->addServer($this->chost, $this->cport);
			}
			
		}
		else{
			//- open socket, #todo
		}
		
		print __FILE__;
		print_r($config);
		var_dump($this->mcache);
		print __FILE__;
		
	}
	
	//- init
	function _init(){
		if(!is_object($this->mcache)){
			$this->mcache = new Memcached($this->persistConnId);
			$servers = $this->mcache->getServerList(); 
			if(is_array($servers)) { 
				foreach ($servers as $server) {
					if(($server['host'] == $this->chost and $server['port'] == $this->cport)
						|| ($server['host'] == 'localhost')
					) {
						return $this->mcache;
					}
				}
			}
			$this->mcache->addServer($this->chost, $this->cport);
		}
		return $this->mcache;
	}

	//- set
	function set($k, $v){
		$rtn = '';
		
		if(!$this->mcache){ $this->_init(); }
		$rtn = $this->mcache->set($k, $v, $this->expireTime);
		
		print __FILE__.": k:$k, v:$v expire:[".$this->expireTime."] retn_code:[".$this->mcache->getResultCode()."] rtn:[$rtn]\n";
		
		return $rtn;
		
	}
	
	//- get
	function get($k){
		if(!$this->mcache){ $this->_init(); }
		$rtn = $this->mcache->get($k);
		print __FILE__.": k:$k, retn_code:[".$this->mcache->getResultCode()."] rtn-v:[$rtn]\n";
		return $rtn;
	}
 	
	//- delete
	function del($k){
		if(!$this->mcache){ $this->_init(); }
		return $this->mcache->delete($k);
	}
	
	
 }
?>
