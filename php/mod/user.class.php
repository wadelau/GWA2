<?php
/* User class for user center
 * v0.1,
 * wadelau@ufqi.com,
 * Mon Jul 23 20:49:47 CST 2012
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class User extends WebApp{
	
	var $sep = "|";
	var $eml = "email";
    
	//-
	function __construct(){
		//-
		$this->setTbl(GConf::get('tblpre').'info_siteusertbl');
		
		# Parent constructors are not called implicitly
		#     if the child class defines a constructor.
		# In order to run a parent constructor, a call to parent::__construct()
		#     within the child constructor is required.
		parent::__construct();
		
	}
	
	//-
	function setEmail($email){
		$this->set($this->eml,$email);
	}

	//-
	function getEmail(){
		return $this->get($this->eml);
	}

	//-
	function isLogin(){
		return $this->getId() != '';
	}

	function getUserName()
	{
		return $this->get('username');
	}

    function getGroup(){
        return $this->get('usergroup');
    }
	
}
?>
