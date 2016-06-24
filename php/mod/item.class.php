<?php

#
# Mon Jan 19 21:13:50 CST 2015
# wadelau@ufqi.com

if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class Item extends WebApp{

    var $iname = "";

    function __construct () {
        $this->dba = new DBA();

        if($_SESSION['language'] && $_SESSION['language'] == "en_US"){
            $this->setTbl(Gconf::get('tblpre').'itemtbl');
        }
        else{
            $this->setTbl(Gconf::get('tblpre').'itemtbl');
        }
    }
			
	//- @overide,
	//- remedy by Xenxin, 10:26 16 June 2016
	public function set($k, $v){
		
		if($k != 'ou_desc'){
			parent::set($k, $v);
		}
		else{
			//- shorten desc by DESC_MAX_LENGTH
			$olen = strlen($v);
			$v = shortenStr($v, $this->get('desc_max_length'));
			$nlen = strlen($v);
			if($nlen < $olen){
				debug(__FILE__.": content afr:[$v] shortened by [".($olen-$nlen)."]");
			}
			parent::set($k, $v);
		}
	}
	
	
}

?>
