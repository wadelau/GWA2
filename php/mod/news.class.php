<?php

if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class News extends WebApp{
	
    function __construct($args=null){
		
        # $this->dba = new DBA(); # inherit from parent?
        
		if($_SESSION['language'] && $_SESSION['language'] == "en_US"){
			$this->setTbl(Gconf::get('tblpre').'news');
		}
		else{
			$this->setTbl(Gconf::get('tblpre').'news');
		}
		
		# other services
		#print_r(__FILE__."enable_cache:[".Gconf::get('enable_cache')."]");
		if(Gconf::get('enable_cache')){
			if($this->cachea == null){
				$this->cachea = new CacheA($args['cacheconf']);
				#print_r(__FILE__."cachea:[".$this->cachea."]");
			}
		}
		
    }
}
?>
