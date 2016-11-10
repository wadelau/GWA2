<?php
/* DB Administration, handling all db transations across the site.
 * v0.1
 * wadelau@gmail.com
 * since Wed Jul 13 18:22:06 UTC 2011
 * Thu Sep 11 16:34:20 CST 2014
 */

require(__ROOT__."/inc/conn.class.php");
include(__ROOT__."/inc/mysql.class.php");
include(__ROOT__."/inc/mysqlix.class.php");
include(__ROOT__."/inc/pdox.class.php");
include(__ROOT__."/inc/sqlserver.class.php");
include(__ROOT__."/inc/oracle.class.php");

class DBA {
	
	var $conf = null; 
	var $dbconn = null;
	var $sql_operator_list = array(); # first chars of ansi sql operators

	//-construct
	function __construct($dbconf=null){
		
		$dbconf = ($dbconf==null ? 'Config_Master' : $dbconf);
		//-
		$this->conf = new $dbconf; //- need to be changed to Config_zoneli when sync to product enviro.
		#$this->dbconn = new MySQLDB($this->conf);
		$dbDriver = GConf::get('dbdriver');
		$this->dbconn = new $dbDriver($this->conf);
		$this->sql_operator_list = array(' '=>1,'^'=>1,'~'=>1,':'=>1,'!'=>1,'/'=>1,
				'*'=>1,'&'=>1,'%'=>1,'+'=>1,'='=>1,'|'=>1,
				'>'=>1,'<'=>1,'-'=>1,'('=>1,')'=>1,','=>1);
	}	

	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 */
	function update($sql, $hmvars){
		$hm = array();
		$idxarr = $this->hm2idxArray($sql,$hmvars);
        #print_r($idxarr);
		$tmphm = $this->dbconn->query($sql,$hmvars,$idxarr);
		if($tmphm[0]){
			$hm[0] = true;
			$hm[1] = array('insertid'=>$this->dbconn->getInsertId(),'affectedrows'=>$this->dbconn->getAffectedRows());
		}
		else{
			$hm[0] = false;
			$hm[1] = $tmphm[1];
		}
		//error_log("<br/>/inc/dba.class.php: update sql:[".$sql."] result:[".$hm['insertid']."]");
		return $hm;
	}

	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 */
	function select($sql, $hmvars){
		$hm = array();
		$result = 0;
		$idxarr = $this->hm2idxArray($sql,$hmvars);
    	#print_r($idxarr);
		$haslimit1 = 0;
		if(strpos($sql,"limit 1 ") != false ||(array_key_exists('pagesize',$hmvars) && $hmvars['pagesize'] == 1)){
			$result = $this->dbconn->readSingle($sql, $hmvars,$idxarr); # why need this? @todo need to be removed.
			$haslimit1 = 1;
		}
		else{
			$result = $this->dbconn->readBatch($sql, $hmvars,$idxarr);
		}
		if($result[0]){
			$hm[0] = true;
			$hm[1] = $result[1]; # single-dimension or double-dimension array
		}
		else{
			$hm[0] = false;
			$hm[1] = $result[1];
		}
    	#debug(__FILE__.": vars in dba::select: ".debug($hmvars));
		#error_log(__FILE__.": select sql:[".$sql."] result:[".$hm[0]."]");
		return $hm;
	}

	# added on Sun Jul 17 22:19:15 UTC 2011 by wadelau@gmail.com
	# sort the parameter in order
	# return sorted array 
	function hm2idxArray($sql, $hmvars){
		$idxarr = array();
		$tmparr = array();
		$tmpposarr = array();
        $wherepos = strpos($sql, " where ");
        $selectpos = strpos($sql, "select ");
		$sqloplist = $this->sql_operator_list;
        #print_r($hmvars);
		if(is_array($hmvars)){
			foreach($hmvars as $k => $v){
		        if($k == ''){
		            #debug(__FILE__.": found n/a k:[$k], skip.");
		            continue;
		        }
		        $keyLen = strlen($k);
		        $keyPos = strpos($sql, $k);
		        if($keyPos !== false){
		            while($keyPos !== false){
        		        $preK = substr($sql, $keyPos-1, 1);
        		        $aftK = substr($sql, $keyPos+$keyLen, 1);
        		        #debug(__FILE__.": sql:[$sql] k:[$k] pos:[$keyPos] prek:[$preK] aftk:[$aftK]");
        		        if(isset($sqloplist[$preK]) && isset($sqloplist[$aftK])){
        		            if($selectpos !== false){
        		                if($keyPos > $wherepos){
        		                    $tmparr[$keyPos] = $k;
        		                }
        		                else{
        		                    # select fields
        		                }
        		            }
        		            else{
        		                $tmparr[$keyPos] = $k;
        		            }
        		        }
        		        else{
        		            #debug(__FILE__.": found illegal key preset. k:[$k] pos:[$keyPos] 
        		            #        prek:[$preK] aftk:[$aftK]");
        		        }
        		        $keyPos = strpos($sql, $k, $keyPos+$keyLen);
		            }
		        }
		        else{
		            #debug(__FILE__.": no such key:[$k] in sql:[$sql]");
		        }
		    }
			/*
			foreach($hmvars as $k => $v){
			    if($k == '' || $k == 'tbl'){
			        #debug(__FILE__.": found n/a k:[$k], skip.");
			        continue;
			    }
			    $spacek = " ".$k." ";
				$hasK = strpos($sql, " ".$k); 
				# fieldname should precede with a space ' ', e.g. "where a>?&& b < ?"
				# this is ILLEGAL! "wherea>?&& b < ?" or "where a>?&&b<?" , !!ATTENTION!!
				if($hasK !== false){
				    $sql = str_replace($k, $spacek, $sql);
					$kpos = strpos($sql, $spacek); 
					if($kpos !== false){
			   			if($selectpos !== false && $kpos > $wherepos){
							$tmparr[$kpos] = $k;	# in case "select a, b, c where a = ?"; # by wadelau on Sat Nov  3 20:35:46 CST 2012
							$tmpposarr[$k] = isset($tmpposarr)? $tmpposarr[$k]++ : 2;
			   			}
						else if($selectpos === false){
							$tmparr[$kpos] = $k;	# in case "select a, b, c where a = ?"; # by wadelau on Sat Nov  3 20:35:46 CST 2012
							$tmpposarr[$k] = isset($tmpposarr)? $tmpposarr[$k]++ : 2;
			   			} 
						$nextpos = strpos($sql, $spacek, $kpos+1);
			  			$nextpos = $nextpos===false ? strpos($sql, $spacek, $kpos+1) : $nextpos;
						while($nextpos !== false){
							$tmparr[$nextpos] = $k.($tmpposarr[$k]!='' ? ".".$tmpposarr[$k] : "");
							 /*  Attention: 
							 *      one field matches more than two values, 
							 *      name it as "field.2","field.3", "field.N", etc, as hash key
							 *  e.g. in sql: "... where age > ? and age < ? and gender=? ", settings go like:
							 *      $Obj->set('age', 20);
							 *      $obj->set('age.2', 30); # for the second match of 'age'
							 *  Sun Jul 24 21:18:00 UTC 2011
							 *  !! Need space before > or < in this case, Thu Sep 11 16:29:03 CST 2014
							 */
							 /*
							$nextpos = strpos($sql, $spacek, $nextpos+1);
							$tmpposarr[$k]++;
						}
					}
					else{
						debug(__FILE__.": hm2idxArray NOT exist k:[".$k."] sql:[".$sql."]");
					}
				}
				else{
					#error_log(__FILE__.": not found k:[$k] v:[$v] in sql:[$sql]");	
				}
			}
			*/
		}
		else{
			error_log(__FILE__.": illegal array found with hmvars.");				
		}
		$sqlLen = strlen($sql);
		$tmpi = 0;
		$kSerial = array();
		for($i=0;$i<$sqlLen;$i++){
		    if(array_key_exists($i, $tmparr)){
		        $k = $tmparr[$i];
		        $ki = isset($kSerial[$k]) ? $kSerial[$k] : ''; 
		        $idxarr[$tmpi] = $tmparr[$i].($ki=='' ? '' : '.'.($ki+1));
		        $tmpi++;
		        $kSerial[$k]++;
		    }
		    else{
		        # @todo;
		    }
		}
		/*
		for($i=0;$i<$sqllen;$i++){
			if(array_key_exists($i, $tmparr)){
				$idxarr[$tmpi] = $tmparr[$i];
				$tmpi++;
			}
			else{
				# @todo;
			}
		}
		*/
		#debug(__FILE__.": sql:[$sql] hmvars:[".serialize($hmvars)."] idxarr:");
		#debug($idxarr);
		return $idxarr;
	}

	//-
	function showDb(){
		$this->dbconn->showConf();
	}

	//-
	function close(){
	    # @todo, long conn?
	    return true;
	}
}

?>
