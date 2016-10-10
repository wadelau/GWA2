<?php
#
# This class, mysqli.class, and all of db drivers' classes are working with dba.class, 
#  which is coordinator between db and objects.
# Init by Wadelau@ufqi.com, 18:35 21 May 2016
# 

# Wed Nov  5 14:10:39 CST 2014
require_once(__ROOT__."/inc/config.class.php");


class MYSQLIX { 

	var $m_host; 
	var $m_port; 
	var $m_user; 
	var $m_password; 
	var $m_name; 
	var $m_link; 
	var $isdebug = 0; # debug mode

	# 
	function __construct($config){  
	
		$this->m_host     = $config->mDbHost;
		$this->m_port     = $config->mDbPort; 
		$this->m_user     = $config->mDbUser; 
		$this->m_password = $config->mDbPassword; 
		$this->m_name     = $config->mDbDatabase; 
		$this->m_link = null;
		
	} 

	//-
	function _initConnection(){
		
		if (!is_object($this->m_link)){
			$real_host = $this->m_host.":".$this->m_port;
			$this->m_link = new mysqli($this->m_host, $this->m_user, 
				$this->m_password, $this->m_name, $this->m_port);
			
			if(GConf::get('db_enable_utf8_affirm')){
				$this->query("SET NAMES 'utf8'", null, null);
			}
			
		}
		return $this->m_link;
		
	}

	//--- for sql injection remedy, added on 20061113 by wadelau
	function query($sql,$hmvars,$idxarr){
		
		$hm = array();
		if (!$this->m_link){
			$this->_initConnection();
		}
		$sql = $this->_enSafe($sql,$idxarr,$hmvars);
		
		#debug($sql);
		try{
		  $result = $this->m_link->query($sql) or $this->sayErr("[$sql] 201605240944.");		
		}
		catch(Exception $e){
		    debug(__FILE__.": $sql, exec failed. ".$e->getMessage());
		}
		if($result){
			$hm[0] = true;
			$hm[1] = $result;
			if(!is_bool($result)){
				mysqli_free_result($result);
			}
		}
		else{
			$hm[0] = false;
			$hm[1] = array('sayError'=>'Query failed. 201107080506.');
		}
		return $hm; 

	}
	
	//--- added on 20060705 by wadelau, for quick get one record
	//--- return an one-record array, one-dimension
	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Sun Jul 24 21:20:04 UTC 2011, wadelau@ufqi.com
	 */
	function readSingle($sql,$hmvars,$idxarr){
		
		$hm = array();
		if (!$this->m_link){
			$this->_initConnection();
		}
		
		$sql = $this->_enSafe($sql,$idxarr,$hmvars);	
		if( strpos($sql,"limit")===false && strpos($sql,"show tables")===false){
			$sql .= " limit 1 ";
		} 
		#debug($sql);
        $result = $this->m_link->query($sql) or $this->sayErr("[$sql] query failed. 201605220716.");
        		
		if($result){
			if($row = $result->fetch_array(MYSQLI_ASSOC) ){
				$hm[0] = true;
				$hm[1][0] = $row;
				mysqli_free_result($result);
			}
			else{
				$hm[0] = false;
				$hm[1] = array('sayError'=>'No record. 200607050101.');
			}
		}
		else{
			$hm[0] = true;
			$hm[1] = array('sayError'=>'No record. 200607050202.');
		}
		return $hm;
		
	}

	//--- added on 20060705 by wadelau, for quick get batch record
	//--- return a multiple-record array, two-dimension
	/*
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Sun Jul 24 21:20:04 UTC 2011, wadelau@ufqi.com
	 */
	function readBatch($sql,$hmvars,$idxarr){
		
		$hm = array();
		if (!$this->m_link){
			$this->_initConnection();
		}
		$sql = $this->_enSafe($sql,$idxarr,$hmvars);
		
		#debug($sql);
		$rtnarr = array();	
		$result = $this->m_link->query($sql) or $this->sayErr("[$sql] query failed. 201605220717.");
		
   		if($result && !is_bool($result)){
			$i = 0;
			while($row = $result->fetch_array(MYSQLI_ASSOC) ){
				$rtnarr[$i] =  $row ;		
				$i++;
			}
			//--- refined by tim's advice on 20060804 by wadelau
			mysqli_free_result($result);
		} 
		if( count($rtnarr)>0 ){
			$hm[0] = true;
			$hm[1] = $rtnarr;
		}	
		else{
			$hm[0] = false;
			$hm[1] = array('sayError'=>'No record. 200607050303.');
		}
		return $hm;
		
	}
	
	//-
	function selectDb($database){
		$this->m_name = $database;
		if ("" != $this->m_name){
			
			if (!$this->m_link){
				$this->_initConnection();
			}
			
			mysqli_select_db($this->m_name, $this->m_link) or eval($this->sayErr("use $database"));
			
		}
	}
	
	#
	function _enSafe($sql,$idxarr,$hmvars){
		
		$sql = $origSql = trim($sql);
		if($hmvars[GConf::get('no_sql_check')]){
			$hmvars[GConf::get('no_sql_check')] = false; # valid only once
			return $origSql;
		}
		else{
			$newsql = "";
			$wherepos = strpos($sql, " where ");
			if( (strpos($sql,"delete ")!==false || strpos($sql,"update ")!==false) 
				&& $wherepos === false){
				$this->sayErr("table action [update, delete] need [where] clause.sql:[".$sql."]");
			}
			else{
				$a = strpos($sql,"?");
				$i = 0;
				$n = count($idxarr);
				while($a !== false){
					if($i>$n){
						$this->sayErr("_enSafe, fields not matched with vars.sql:[".$origSql."] i:[".$i."] n:[".$n."].");
					}
					$t = substr($sql,0,$a+1);
					#print __FILE__.": t:[".$t."] i:[".$i."] vars:[".$idxarr[$i]."] hmv:[".$hmvars[$idxarr[$i]]."]\n";
					if(!array_key_exists($idxarr[$i], $hmvars)){
						# in case that, field was not set by $obj->set but written in sql with '?', Sat Apr  2 23:54:48 CST 2016
						debug(__FILE__.": found unmatched field:[$t], i:[$i], n:[$n], a:[$a].");
						debug($idxarr);
						debug($hmvars);
						$sql = substr($sql,$a+1);
						$a = strpos($sql,"?");
						$newsql .= str_replace("?", '\'\'', $t);
					}
					else{
						$sql = substr($sql,$a+1);
						$a = strpos($sql,"?");
						$newsql .= str_replace("?",$this->_quoteSafe($hmvars[$idxarr[$i]]),$t);
					}
					$i++;
				}
				if($sql!=""){
					$newsql .=  $sql ;
				}
				#print __FILE__."\n: sql:[".$sql."] sql_new:[".$newsql."]\n";
				return $newsql;
			}
		}
		return 0;
	}

	//--- for sql injection remedy, added on 20061113 by wadelau
	function _quoteSafe($value, $defaultValue=null){

		if (!is_numeric($value)) {
			$value = "'".mysqli_real_escape_string($this->m_link, $value)."'";
		    # in some case, e.g. $value = '010003', which is expected to be a string, but is_numeric return true.
            # this should be handled by $webapp->execBy with manual sql components...
		}
		else{
			if($defaultValue == ''){
				$value = "'".mysqli_real_escape_string($this->m_link, $value)."'";
			}
		} 
		return $value;
		
	}
	
	#
	function getErrno(){
		
		if (!$this->m_link){
			$this->_initConnection();
		}
		
		return mysqli_errno($this->m_link);
	
	}
	
	#
	function getError(){

		if (!$this->m_link){
			$this->_initConnection();
		}
		
		return mysqli_error($this->m_link);
	}
	
	#
	function freeResult(&$result){ 
	
		return mysqli_free_result($result) or eval($this->sayErr()); 
		
	} 

	#
	function getAffectedRows(){ 
		
		if (!$this->m_link){
			$this->_initConnection();
		}
		$result=mysqli_affected_rows($this->m_link); 
		return $result; 
		
	}

	#
	function numFileds(){ 
		
		if (!$this->m_link){
			$this->_initConnection();
		}
		$result=mysqli_num_fields($this->m_link); 
		return $result; 
		
	}

	#	
	function close(){
		if( !$this->m_link ){
			mysqli_close($this->m_link) or eval($this->sayErr());
		}
		return 0;
	}
	
	#
	function getInsertId(){
		if (!$this->m_link){
			$this->_initConnection();
		}
		return mysqli_insert_id($this->m_link);

	}

	#
	function sayErr($sql = ""){
		
		global $HTTP_HOST;
		global $REMOTE_ADDR;
		global $PHP_SELF;
		$str = '';
		if($this->isdebug){
			$str .= "<br>sayError:";
			$str .= "<font color=red>sayError sql : </font><br>&nbsp;&nbsp;".$sql;
			$str .= "<br>";
			$str .= "<font color=red>sayError number : </font><br>&nbsp;&nbsp;".$this->getErrno();
			$str .= "<br>";
			$str .= "<font color=red>sayError information : </font><br>&nbsp;&nbsp;".$this->getError();
		}
		else{
			$str .= "<div id=\"sayErrdiv_201210131751\" style=\"color:red;z-index:99;position:absolute\">Found internal Error when process your transaction..., please report this to wadelau@gmail.com . [2007211253]</div>\n";
			error_log(__FILE__.": MYSQL_sayErrOR: sayErr_no:[".$this->getErrno()."] sayErr_info:[".$this->getError()."] sayErr_sql:[".serialize($sql)."] [07211253]");
		}
		debug($sql);
		$html = GConf::get('html_resp'); $html = str_replace("RESP_TITLE","sayError!", $html); $html = str_replace("RESP_BODY", $str, $html);
		print $html;
		#exit(1);
		
	} 
	
	//- for test purpose, wadelau@gmail.com, Wed Jul 13 19:21:37 UTC 2011
	function showConf(){
		
		print __FILE__.":[".$this->m_name."].";
		
	}	

} 

?>
