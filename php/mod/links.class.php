<?php
/*
 * SiteNews class
 * v0.1
 * wadelau@ufqi.com
 * 2012-11-11 
 */  

if(!defined('__ROOT__')){
		define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php'); 

class Links extends WebApp{



		function Links() {
				$this->dba = new DBA();
				if($_SESSION['language'] && $_SESSION['language'] == "en_US")
				{
				    $this->setTbl(Gconf::get('tblpre').'en_info_links');
				}
				else
				{
				    $this->setTbl(Gconf::get('tblpre').'ch_info_links');
				}
				
		}



}
?>
