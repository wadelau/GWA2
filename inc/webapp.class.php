<?php
/* WebApp class, as a web application's parent for all subclass 
 * v0.1,
 * wadelau@ufqi.com,
 * 2011-07-12 22:41
 * Sun Jul 17 10:16:03 UTC 2011
 * Mon Jan 23 12:14:15 GMT 2012
 * 08:42 Sunday, June 14, 2015
 * Sat Aug  8 11:22:40 CST 2015
 */


if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require(__ROOT__."/inc/webapp.interface.php");
require_once(__ROOT__."/inc/config.class.php");
require(__ROOT__."/inc/dba.class.php");
require(__ROOT__."/inc/session.class.php");
require(__ROOT__."/inc/cache.class.php");
require(__ROOT__."/inc/filesystem.class.php");


class WebApp implements WebAppInterface{
	
	var $dba = null;
	var $hm = array();
	var $hmf = array(); # container for the Object which extends this class	
	var $isdbg = 1;  # Gconf::get('is_debug');
	var $sep = "|"; # separating tag for self-defined message body

	//- constructor
	function __construct(){
		//-
		if($this->dba == null){ # Wed Oct 22 10:23:03 CST 2014
          $this->dba = new DBA();
        }
		$this->isdbg = Gconf::get('is_debug');
	}
	//-
	function set($field,$value=null){ # update, Sat May 16 08:54:54 CST 2015
		if($value === null){
			if(is_array($field)){
				foreach($field as $k=>$v){
					$this->hmf[$k] = $v;	
				}		
			}
			else{
				$this->hmf[$field] = '';
				error_log(__FILE__.": Error! field:[$field] set a null value.");
			}
		}
		else{
			$this->hmf[$field] = $value;
		}
	}
	//-
	function get($field){
		if(array_key_exists($field,$this->hmf)){
			return $this->hmf[$field];
		}
		else if($field != 'id' & $field != 'tbl' && $field != 'er'){
			#! Otherwise, this will cause a dead loop with ._setAll.
			if($this->get('er') != 1){
				if($this->_setAll()){
					if(isset($this->hmf[$field])){
						return $this->hmf[$field];
					}
					else{
						return $this->hmf[$field]='';	
					}
				}
				else{
					return '';
				}
			}
			else {
				return '';
			}
		}
		else{
			return '';
		}
	}
	
	function setTbl($tbl){
		$tblpre = Gconf::get('tblpre');
		if(strpos($tbl, $tblpre) !== 0){
			$tbl = $tblpre.$tbl;
		}
		$this->set("tbl",$tbl);
		if($this->dba == null){ $this->dba = new DBA(); }
	}

	function getTbl(){
		return $this->get("tbl");
	}

	function setId($id){
		$this->set("id", $id);
	}

	function getId(){
		return $this->get("id");
	}

	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 */
	function setBy($fields, $conditions){
		$sql = "";
		$hm = array();
		$isupdate = 0;
		if($this->getId() == ''){
			$sql = "insert into ".$this->getTbl()." set ";
		}
		else{
			$sql = "update ".$this->getTbl()." set ";
			$isupdate = 1;
		}
		$fieldarr = explode(",",$fields);
		
		foreach($fieldarr as $k => $v){
			$v = trim($v);
			if($v == "updatetime" || $v == 'inserttime' || $v == 'createtime'){
				$sql .= $v."=NOW(), ";
                unset($this->hmf[$v]);
			}
			else{
				$sql .= $v."=?, ";
			}
		}
		$sql = substr($sql,0,strlen($sql)-2); //- drop ", " at the end, Sun Jul 17 22:51:44 UTC 2011
		$issqlready = 1;
		if($conditions == null || $conditions == ""){
			if($this->getId() != ""){
				$sql .= " where id=?";
			}
			else if($isupdate == 1){
				error_log("/inc/webapp.class.php: setBy: unconditonal update is forbidden.");
				$issqlready = 0;
				$hm[0] = false;
				$hm[1] = array("error"=>"unconditonal update is forbidden.");
			}
		}
		else{
			$sql .= " where ".$conditions;
		}
		#error_log(__FILE__.": setBy, sql:[".$sql."] hmf:[".$this->toString($this->hmf)."] [1201241223].\n");
		#print(__FILE__.": setBy, sql:[".$sql."] hmf:[".$this->toString($this->hmf)."] [1201241223].\n");
		if($issqlready == 1){
			if($this->getId() != ""){ $this->hmf["pagesize"] = 1; } # single record
			$hm = $this->dba->update($sql, $this->hmf);
		}
		return $hm;
	}

	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 */
	function getBy($fields, $conditions){
		$sql = "";
		$hm = array();
		$haslimit1 = 0;
		#print_r($this->hmf);
		$pagenum = 1; # default pagenum set to "1", unless pre set in hmvar, 20080903  
		$pagesize = 0;# default pagesize set to "0", unless pre set in hmvar, "0" means all, no limit, 20080903
		if(array_key_exists('pagenum',$this->hmf)){ $pagenum = $this->hmf['pagenum'];}
		if(array_key_exists('pagesize',$this->hmf)){ $pagesize = $this->hmf['pagesize'];}
		$sql .= "select ".$fields." from ".$this->getTbl()." where ";
		if($conditions == null || $conditions == ""){
			if($this->getId() != ""){
				$sql .= "id=?";
				$haslimit1 = 1;
			}
			else{
				$sql .= "1=1";
			}
		}
		else{
			$sql .= $conditions;
		}
		if(array_key_exists('orderby',$this->hmf)){ $sql .= " order by ".$this->hmf['orderby'];}
		if($haslimit1 == 1){
			$sql .= " limit 1 ";
		}
		else{
			if($pagesize == 0){ $pagesize = 99999; } # maximum records per query
			$sql .= ' limit '.(($pagenum-1)*$pagesize).','.$pagesize;	
		}
		#print __FILE__.':<br/>/inc/webapp.class.php: sql:['.$sql.']';
        #error_log(__FILE__.": getBy, sql:[".$sql."] hmf:[".$this->toString($this->hmf)."] [1201241223].\n");
		$hm = $this->dba->select($sql, $this->hmf);
		return $hm;
	}

    /*
     * added on Mon Jan 23 12:20:24 GMT 2012 by wadelau@ufqi.com
     */
    function execBy($sql, $conditions=array()){
	
        $hm = array();
        if($conditions == null){
            $conditions = array();
        }
        $pos = stripos($sql, "select");
		
        if($pos === 0){
			#
		}
		else{
            $pos = stripos($sql, "desc");
            if($pos === 0){
				#
			}
			else{
                $pos = stripos($sql, "show");
            }
        }
		#error_log(__FILE__.": select!! sql:$pos");
        if($pos === 0){
            $hm = $this->dba->select($sql, $conditions);
            #error_log(__FILE__.": select!! sql:[$sql] pos:[$pos]");
        }
		else{
            #error_log(__FILE__.": update!! sql:[$sql] pos:[$pos]");
            $hm = $this->dba->update($sql, $conditions);
        }
        return $hm;
    }

	/*
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 */
	function rmBy($conditions=null){
		$hm = array();
		$issqlready = 0;
		$sql = "delete from ".$this->getTbl()." where ";
		if($conditions == null || $conditions == ""){
			if($this->getId() != ""){
				$sql .= "id=?";
				$issqlready = 1;
			}
			else{
				print "unconditional deletion is strictly forbidden. stop it. sql:[".$sql."] conditions:[".$conditions."]";
				$hm[0] = false;
				$hm[1] = array("error"=>"unconditional deletion is strictly forbidden.");
			}
		}
		else{
			$sql .= $conditions;
			$issqlready = 1;
		}
		error_log(__FILE__.": rmBy, sql:[".$sql."] hmf:[".$this->toString($this->hmf)."] [1201241223].\n");
		if($issqlready == 1){
			$hm = $this->dba->update($sql, $this->hmf);
		}
		return $hm;
	}

	//-
	# method override not support? so rename set to setAll, Sat Jul 23 10:13:14 UTC 2011
	function _setAll(){
		$isinclude = 0;
		if($this->getId() != ''){
			$tmphm = $this->getBy('*',null);
			#print "/inc/webapp.class.php: _setAll";
            #print_r($tmphm);
            #print_r($this->hmf);
			if($tmphm[0]){
                #print_r($tmphm);
				$infoarr = $tmphm[1][0];
                #print_r($infoarr);
				foreach($infoarr as $k => $v){
					$this->hmf[$k] = $v;	
					if($field == $k){
						$isinclude = 1;	
					}
				}
				if($field != '' && $isinclude == 0){
					$hm->hmf[$field] = '';
				}
				return true;
			}
			else{
				error_log(__FILE__.': _setAll: failed for reading table. id:['.$this->getId().']');
				$this->set('er', 1);
				return false;
			}
		}
		else{
			#error_log('/inc/webapp.class.php: _setAll: failed for empty id.');
			$this->set('er', 1);
			return false;
		}
		$this->set('er', 1);
		return false;
	}

    /*- toString, added on 
     * added on Tue Jan 24 05:02:16 GMT 2012
     */
    public function toString($object){
        $str = '';
        if(is_array($object)){
            foreach($object as $k=>$v){
                $str .= "$k:[$v]\n";
                if(is_array($v)){
                    foreach($v as $k1=>$v1){
                        $str .= "\t $k1:[$v1]\n";
                        if(is_array($v1)){
                            foreach($v1 as $k2=>$v2){
                                $str .= "\t\t $k2:[$v2]\n";
                            }
                        }
                    }
                }
                $str .= "\n";
            } 
        }
		else{
            $str = serialize($object);
        }
        return $str;
    }

    # test whether a field is numeric or not
    # added on Mon Jun 18 20:43:55 CST 2012
    public function isNumeric($fieldtype){
        $isNumeric = 0;
        if(strpos($fieldtype, "int") !== false
            || strpos($fieldtype, "float") !== false
            || strpos($fieldtype, "double") !== false
            || strpos($fieldtype, "date") !== false){
            
            $isNumeric = 1;
        }
        return $isNumeric;
    }

	# get count based on some conditions
	# Sat Aug  8 11:25:09 CST 2015 by wadelau
	public function getCount($pCondi){
		$ro = $this->getBy("count(*) as inum", $pCondi);
		if($ro[0]){
			return intval($ro[1][0]['inum']==null ? 0 : $ro[1][0]['inum']);
		}
		else{
			return 0;
		}
	}

}
?>
