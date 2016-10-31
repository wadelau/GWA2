<?php
/* Files and Directories reading and writing, handling IO transactions
 * v0.1
 * wadelau@ufqi.com
 * Sat Jul 23 09:50:58 UTC 2011
 * updates filea, filedriver, by Xenxin@Pbtt, Thu, 27 Oct 2016 08:36:48 +0800
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__."/inc/config.class.php");

class FileSystem {
	
    var $file = null;
    var $fp = null;
    var $handlelist = array();
    
 	//- construct
	function __construct(){
		//-
	}
	
	function __destruct(){
	    $this->close();
	}

	//-
	function open($file){
	    //- @todo
	    $this->file = $file;
	    
	    return true;
	}
	
	function close(){
	    //- @todo
	   return true;
	}
	
	# Todo: to be implemented in second stage for uniting the storage engine.
 	# need todo ....
	/*
	 * WebApp.class has been added two extended methods as
		$webapp->setBy('url:', $args);
		$webapp->setBy('file:', $args);
		$webapp->setBy('cache:', $args);
		$webapp->getBy('url:', $args);
		$webapp->getBy('file:', $args);
		$webapp->getBy('cache:', $args);
	* 2016-05-10
	*/
	
 }
?>
