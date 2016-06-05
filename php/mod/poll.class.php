<?php
if(!defined('__ROOT__')){
    define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php');

class Poll extends WebApp{

    # global variables

	# construct
	function __construct(){

        $this->dba = new DBA();
        
		if($_SESSION['language'] && $_SESSION['language'] == "en_US"){
			#$this->setTbl(Gconf::get('tblpre').'indextbl_en');
			# disable multiple languages for now
            $this->setTbl(Gconf::get('tblpre').'polltbl');
		}
		else{
			$this->setTbl(Gconf::get('tblpre').'polltbl');
		}
    }

    function md5B62x($s){
        $md5 = md5($s);
        $b62x = $this->base62x(substr($md5,0,11), 0, '16').base62x(substr($md5,11,11), 0, '16').base62x(substr($md5,22,11), 0, '16');
        #print substr($md5,0,11)."--".substr($md5,11,11).'--'.substr($md5,22,11);
        return $b62x;
    }


    function base62x($s,$dec=0,$numType=''){
        # e.g. base62x('abcd', 0, '8');
        # e.g. base62x('abcd', 1, '16');
        $type = "-enc";
        if($dec == 1){
            $type = "-dec";
        }
        return $s=exec('/www/webroot/tools/base62x '.$type.($numType==''?'':' -n '.$numType).' \''.$s.'\'');
    }

 	# get latest item
	function getLatestList(){
		$hm = array();
		$this->set('orderby', 'id desc');	
		$this->set('pagesize', '15');	
		$hm = $this->getBy('*', '');
		if($hm[0]){
			$hm = $hm[1];	
		}
		
		return $hm;

	}


}
?>
