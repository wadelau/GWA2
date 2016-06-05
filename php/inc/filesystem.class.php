<?php
/* Files and Directories reading and writing, handling IO transactions
 * v0.1
 * wadelau@ufqi.com
 * Sat Jul 23 09:50:58 UTC 2011
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__."/inc/config.class.php");

class FileSystem{
	 
 	//- construct
	function __construct(){
		//-
	}

	# Todo: to be implemented in second stage for uniting the storage engine.

 	# need todo ....
	
	/*
	 * WebApp.class has been added two extended methods as
		$webapp->setBy('url:', $args);
		$webapp->setBy('file:', $args);
		$webapp->getBy('url:', $args);
		$webapp->getBy('file:', $args);
	* 2016-05-10
	*/
	
 }
?>
