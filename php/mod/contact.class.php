<?php
if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class Contact extends WebApp{
    function Contact(){
        $this->dba = new DBA();
        
		if($_SESSION['language'] && $_SESSION['language'] == "en_US")
		{
			$this->setTbl(Gconf::get('tblpre').'en_leavemsgtbl');
		}
		else
		{
			$this->setTbl(Gconf::get('tblpre').'ch_leavemsgtbl');
		}
    }
	
	function sendMsg($name,$email,$message)
	{
	    //$this->set
	}
}
?>