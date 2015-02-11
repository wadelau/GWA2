<?php
if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class NEWS extends WebApp{
    function NEWS(){
        $this->dba = new DBA();
        
		if($_SESSION['language'] && $_SESSION['language'] == "en_US")
		{
			$this->setTbl(Gconf::get('tblpre').'en_newstbl');
		}
		else
		{
			$this->setTbl(Gconf::get('tblpre').'ch_newstbl');
		}
    }
}
?>
