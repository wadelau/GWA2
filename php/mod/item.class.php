<?php

# 
# Mon Jan 19 21:13:50 CST 2015
# wadelau@ufqi.com

if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php'); 

public class Item extends WebApp{

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
}

?>
