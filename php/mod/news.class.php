<?php

if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class News extends WebApp{
	
    function __construct($args=null){
		
        # $this->dba = new DBA(); # inherit from parent?
        
		if($_SESSION['language'] && $_SESSION['language'] == "en_US"){
			$this->setTbl(GConf::get('tblpre').'news');
		}
		else{
			$this->setTbl(GConf::get('tblpre').'news');
		}
		
		# other services
		if(GConf::get('enable_cache')){
			if($this->cachea == null){
				$this->cachea = new CacheA($args['cacheconf']);
				#print_r(__FILE__."cachea:[".$this->cachea."]");
			}
		}
		
    }
}
?>
