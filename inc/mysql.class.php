<?php
ini_set("memory_limit","256M");
//--- added on 20060704 by wadelau for "allowed memory exhausted" error.
//--- updated from 16M to 64M  on 20060816, from 64M to 256M on 20110708
//--- add "SQL Injection Attacks" prevension, updated on 2006113 by wadelau
//--- v1.2, new remedies on 20110708 by wadelau
//--- v1.3, update hm2idxArr by wadelau on  Sat Nov  3 20:38:55 CST 2012

# Wed Nov  5 14:10:39 CST 2014
require_once(__ROOT__."/inc/config.class.php");

class MySQLDB { 
	var $m_host; 
	var $m_port; 
	var $m_user; 
	var $m_password; 
	var $m_name; 
	var $m_link; 
	var $isdebug = 0; # debug mode
	var $ismagicquote = 0;

	function Err($sql = ""){
		global $HTTP_HOST;
		global $REMOTE_ADDR;
		global $PHP_SELF;
		if($this->isdebug){
			// --- leo 2002-11-01 21:42:03  start --- //
			echo "<br>xxxxxx";
			echo "<font color=red>error sql : </font><br>&nbsp;&nbsp;".$sql;
			echo "<br>";
			echo "<font color=red>error number : </font><br>&nbsp;&nbsp;".$this->getErrno();
			echo "<br>";
			echo "<font color=red>error information : </font><br>&nbsp;&nbsp;".$this->getError();
			// --- leo 2002-11-01 21:42:06  end --- //
		}
		else
		{
			//header ("Location: http://sms.fumobile.com/show_msg.php?ra=".$REMOTE_ADDR);
			echo "<div id=\"errdiv_201210131751\" style=\"color:red;z-index:99;position:absolute\">Found internal error when process your transaction..., please report this to wadelau@gmail.com. [07211253]</div>\n";
			error_log(__FILE__.": MYSQL_ERROR: err_no:[".$this->getErrno()."] err_info:[".$this->getError()."] err_sql:[".$sql."] [07211253]");
		}
		#exit;
		return false;
	} 

	function MySQLDB($config){             
		$this->m_host     = $config->mDbHost;
		$this->m_port     = $config->mDbPort; 
		$this->m_user     = $config->mDbUser; 
		$this->m_password = $config->mDbPassword; 
		$this->m_name     = $config->mDbDatabase; 
		$this->m_link=0;
	} 
	//- for test purpose, wadelau@gmail.com, Wed Jul 13 19:21:37 UTC 2011
	function showConf(){
		print "<br/>/inc/class.mysql-1.2.php: current db:[".$this->m_name."].";
	}	

	function _initconnection(){
		if ($this->m_link==0){
			$real_host = $this->m_host.":".$this->m_port;    
			//echo $real_host,$this->m_user,$this->m_password;
			$this->m_link = mysql_connect($real_host,$this->m_user,$this->m_password) or die($this->Err("mysql connect")); 
			//echo $this->Err();
			//echo "[".$this->m_link."]";
			if ("" != $this->m_name){
				mysql_select_db($this->m_name, $this->m_link) or die($this->Err("use ".$this->m_name));
			}             
			if(get_magic_quotes_gpc()){ $this->ismagicquote = 1; }
		}
	}

	function selectDb($database)
	{
		$this->m_name = $database;
		if ("" != $this->m_name){
			if ($this->m_link == 0){
				$this->_initconnection();
			}
			mysql_select_db($this->m_name, $this->m_link) or eval($this->Err("use $database"));
		}
	}

	//--- for sql injection, added on 20061113 by wadelau
	function query($sql,$hmvars,$idxarr){
		$hm = array();
		if ($this->m_link == 0){
			$this->_initconnection();
		}
		$sql = $this->_enSafe($sql,$idxarr,$hmvars);
		#$result=mysql_query($sql,$this->m_link) or eval($this->Err($sql)); 
		$result=mysql_query($sql,$this->m_link) or $this->Err($sql); 
		if($result){
			$hm[0] = true;
			$hm[1] = $result;
		}
		else{
			$hm[0] = false;
			$hm[1] = array('error'=>'Query failed');
		}
		return $hm; 

	}
	
	function _enSafe($sql,$idxarr,$hmvars){
		$sql = $origSql = trim($sql);
		$newsql = "";
        $wherepos = strpos($sql, " where ");
		if( (strpos($sql,"delete ")!==false || strpos($sql,"update ")!==false) 
			&& $wherepos === false){
			$this->Err("table action [update, delete] need [where] clause.sql:[".$sql."]");
		}
		else{
        	/*
      		if(strpos($sql, "select ") !== false && $wherepos !== false){
        		$newsql = substr($sql, 0, $wherepos);     
      		}
      		*/
			#print __FILE__."\n: sql:[".$sql."] sql_new:[".$newsql."]\n";
			$a = strpos($sql,"?");
			$i = 0;
			$n = count($idxarr);
			while($a !== false){
				#if($i>=$n){
				if($i>$n){
					$this->Err("_enSafe, fields not matched with vars.sql:[".$origSql."] i:[".$i."] n:[".$n."].");
				}
				$t = substr($sql,0,$a+1);
				#print __FILE__.": t:[".$t."] i:[".$i."] vars:[".$idxarr[$i]."] hmv:[".$hmvars[$idxarr[$i]]."]\n";
				$newsql .= str_replace("?",$this->_QuoteSafe($hmvars[$idxarr[$i]]),$t);
				$sql = substr($sql,$a+1);
				$a = strpos($sql,"?");
				$i++;
			}
			if($sql!=""){
				$newsql .=  $sql ;
			}
			#print __FILE__."\n: sql:[".$sql."] sql_new:[".$newsql."]\n";
			return $newsql;
		}
	}
	//--- for sql injection, added on 20061113 by wadelau
	function _QuoteSafe($value){
		// Quote variable to make safe
		// Stripslashes
		//if (get_magic_quotes_gpc()){
		if ($this->ismagicquote){
			$value = stripslashes($value);
		}
		// Quote if not a number or a numeric string
		if (!is_numeric($value)) {
			//$value = "'".addslashes($value)."'";
			$value = "'".mysql_real_escape_string($value,$this->m_link)."'";
            # in some case, e.g. $value = '010003', which is expected to be a string, but is_numeric return true.
            # this should be handled by $webapp->execBy with manual sql components...
		}
		else{
			#	
		} 
		return $value;
	}

	function getErrno(){
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		return mysql_errno($this->m_link);
	}
	function getError(){
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		return mysql_error($this->m_link);
	}
	
	function FetchArray($result) { 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$row=mysql_fetch_array($result); 
		return $row; 
	}
	
	function FetchArray_Asoc($result) //-- return assoc array (hash) only 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$row=mysql_fetch_array($result,MYSQL_ASSOC); 
		return $row; 
	}
	
	function FetchRow($result) //-- return number indices only
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$row=mysql_fetch_row($result); 
		return $row; 
	} 

	function FetchObject($result) 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$row=mysql_fetch_object($result); 
		return $row; 
	} 

	function FreeResult(&$result) 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		return mysql_free_result($result) or eval($this->Err()); 
	} 

	function NumRows($result) 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$result=mysql_num_rows($result) or eval($this->Err()); 
		return $result; 
	} 
	
	function DataSeek($result,$row_id) 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$result=mysql_data_seek($result,$row_id);		
		return $result; 
	}

	function getAffectedRows() 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$result=mysql_affected_rows($this->m_link); 
		return $result; 
	}

	function NumFileds() 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$result=mysql_num_fields($this->m_link); 
		return $result; 
	}

	function FiledName() 
	{ 
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$result=mysql_field_name($this->m_link); 
		return $result; 
	}
					
	function close()
	{
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		//syslog(E_WARNING,"m_link is:".$this->m_link);
		if( $this->m_link )
		{
			mysql_close($this->m_link) or eval($this->Err());
		}
	}
	
	function getInsertId()
	{
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		return mysql_insert_id($this->m_link);
	}

	//--- added on 20060705 by wadelau, for quick get one record
	//--- return an one-record array, one-dimension
	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Sun Jul 24 21:20:04 UTC 2011, wadelau@ufqi.com
	 */
	function readSingle($sql,$hmvars,$idxarr)
	{
		$hm = array();
		if ($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$sql = $this->_enSafe($sql,$idxarr,$hmvars);	
		if( strpos($sql,"limit")===false && strpos($sql,"show tables")===false)
		{
			$sql .= " limit 1 ";
		} 
        #error_log(__FILE__.": query: sql:[".$sql."]\n");
		$result = mysql_query($sql) or $this->Err($sql);
		if($result)
		{
			if($row = mysql_fetch_array($result,MYSQL_ASSOC) )
			{
				mysql_free_result($result) or $this->Err($result);
				$hm[0] = true;
				$hm[1][0] = $row;
			}
			else
			{
				#print("\nno record retrieved:\n<br/>");
				#$this->Err("sql:[".$sql."]\n");
				$hm[0] = false;
				$hm[1] = array('error'=>'No record');
			}
		}
		else
		{
			$hm[0] = true;
			$hm[1] = array('error'=>'No record');
		}
		return $hm;
	}
	//--- added on 20060705 by wadelau, for quick get batch record
	//--- return a multiple-record array, two-dimension
	/*
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Sun Jul 24 21:20:04 UTC 2011, wadelau@ufqi.com
	 */
	function readBatch($sql,$hmvars,$idxarr)
	{
		$hm = array();
		if($this->m_link == 0)
		{
			$this->_initconnection();
		}
		$sql = $this->_enSafe($sql,$idxarr,$hmvars);
		#print "<br/>/inc/class.mysql.php: readBatch sql:[".$sql."]";	
    #error_log(__FILE__.": query in readBatch: sql:[".$sql."]\n");
		$rtnarr = array();	
		$result = mysql_query($sql) or $this->Err($sql);
		if($result && !is_bool($result))
		{
			$i = 0;
			while($row = mysql_fetch_array($result,MYSQL_ASSOC) )
			{
				$rtnarr[$i] =  $row ;		
				$i++;
			}
			//--- refined by tim's advice on 20060804 by wadelau
			mysql_free_result($result) ;
		} 
		if( count($rtnarr)>0 )
		{
			#return $rtnarr ;
			$hm[0] = true;
			$hm[1] = $rtnarr;
		}	
		else
		{
			#print("\nno record retrieved:\n<br/>");
			#$this->Err("[".$sql."]\n");	
			#return 0 ;
			$hm[0] = false;
			$hm[1] = array('error'=>'No record');
		}
		return $hm;
	}


} 
/*
############################################################
#±ê×¼µ÷ÓÃ·¶Àý
#  include("class/class.config.php");
#  include("class/class.mysql.php");
#
#  $config = new Config;
#  $mysql = new MySQLDB($config);  //new³öµÄConfigÊµÀý×÷ÎªTDatabaseÀàµÄÊµÀýµÄ²ÎÊý
#  $sql = "select UserName from user where ID = 1";
#  $result = $mysql->query($sql);
#  if ($mysql->AffectedRows != 0)
#  {
#     $row = $mysql->FetchArray($result);
#     echo $row[0];
#  }
#  $mysql->DatabaseClose();
############################################################
*/
?>
