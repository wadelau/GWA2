<?php
/* 
 * Zip/Encrypt/Encode (ZEE), with its unzip, decrypt and decode
 * Administator of,
 * v0.1
 * wadelau@ufqi.com fro GWA2
 * Sat, 24 Dec 2016 22:08:30 +0800
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__."/inc/config.class.php");
require_once(__ROOT__."/mod/base62x.class.php");

class ZeeA {
	
    //- constants
    const Type_Gzip = 'gzip';
    const Type_Deflate = 'deflate';
    const Type_Compress = 'compress';
    const Type_Identity = 'identity';
    const Type_Br = 'br';
    
    //- variables
    var $conf = null;
    
 	//- construct
	public function __construct($zeeConf=null){
		//- open as first access
		# @todo
		
	}

	//- desctruct
	public function __destruct(){
	    $this->close();
	}
	
	//- methods, public
	//- unzip most kinds of algorithms, gzip, compress, deflate, br
	//- https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding
	//- Xenxin@ufqi.com Thu, 21 Dec 2016 22:24:42 +0800
	public static function unzip($str, $args=null){
	    $rtn = array();
	    $unkn = 'unkn';
	    $ztype = ''; # gzip, compress, defalte, identity, br
	    if($args != null){
	        if(isset($args['header'])){
	            $headers = $args['header'];
	            foreach($headers as $k=>$v){
	                if(strpos($v, 'Content-Encoding') !== false){
	                    if(strpos($v, self::Type_Gzip) !== false){
	                        $ztype = self::Type_Gzip;
	                        break;
	                    }
	                    else if(strpos($v, self::Type_Deflate) !== false){
	                        $ztype = self::Type_Deflate;
	                        break;
	                    }
	                    else if(strpos($v, self::Type_Compress) !== false){
	                        $ztype = self::Type_Compress;
	                        break;
	                    }
	                    else{
	                        $ztype = $unkn;
	                    }
	                }
	                else if($ztype == $unkn){
	                    break;
	                }
	            }
	        }
	    }
	    $ns = '';
	    if($ztype == self::Type_Gzip){
	        $ns = gzdecode($str);
	    }
	    else if($ztype == self::Type_Deflate){
	        $ns = gzinflate($str);
	    }
	    else if($ztype == self::Type_Compress){
	        $ns = gzuncompress($str);
	    }
	    else{
	        $ns = false;
	        $rtn = $str;
	        debug(__FILE__.": unknown ztype:[$ztype], let it be. 1612222232.");
	    }
	    if($ns !== false){
	        $rtn = array(true, $ns);
	    }
	    else{
	        $rtn = array(false, $str);
	    }
	    #debug(__FILE__.": ztype:$ztype size_orig:[".strlen($str)."] size_rtn:[".strlen($rtn[1])."]", '',
	    #        'file:/www/log/bin/offersync/log/ou_offer_sync_');
	    return $rtn;
	}
	
	//- close
	public function close(){
	    //- @todo
	    # need sub class override.
	}

	//-- methods, private
	//-
	private function _something(){
	    $rtn = 0;
	    # @todo
	    return $rtn;
	}
	
 }
?>
