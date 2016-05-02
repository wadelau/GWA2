<?php

# work with ../ctrl/search.php
# Sun Jun  7 09:52:49 CST 2015
# by wadelau@ufqi.com
# refer https://wadelau.wordpress.com/2012/08/31/%E5%BC%80%E5%8F%91%E6%89%8B%E8%AE%B0%EF%BC%9A%E6%95%B0%E6%8D%AE%E8%A1%A8%E5%A6%82%E4%BD%95%E8%81%94%E6%9F%A5%E4%B8%A4%E4%B8%AA%E4%B8%8D%E7%9B%B8%E5%85%B3%E8%81%94%E8%A1%A8%E7%9A%84%E6%95%B0%E6%8D%AE/  

if(!defined('__ROOT__')){
	define('__ROOT__', dirname(dirname(__FILE__)));
}
require_once(__ROOT__.'/inc/webapp.class.php'); 

class Search extends WebApp{

	var $mainTables = array("livetbl"=>array("id"=>"id", "title"=>"name", "searchkey"=>"title"), 
		"producttbl"=>array("id"=>"id","pname"=>"name", "searchkey"=>"pname"), 
		"pairtbl"=>array("id"=>"id", "ititle"=>"name", "searchkey"=>"ititle"), 
		"wanttbl"=>array("id"=>"id", "wname"=>"name", "searchkey"=>"wname"),
		"usertbl"=>array("id"=>"id", "nickname"=>"name", "searchkey"=>"nickname")
		);

	//-
	function __construct(){
		$this->dba = new DBA();
		# no tables set 
		
	}

	//-
	function getList($kw, $scope=''){
		$sql = ""; $pagesize = 500;
		foreach($this->mainTables as $k=>$v){
			#print __FILE__.": k:[$k] , v:[$v].";
			if($scope != ''){
				if(strpos($k, $scope) === false){ continue; }	
			}
			$sql .= "select ";
			foreach($v as $k2=>$v2){
				if($k2 == 'searchkey'){ continue; }
				else if($v2 == 'name'){
					$sql .= "concat('".$k."_',$k2) as $v2,"; 		
				}
				else{
					$sql .= "$k2 as $v2,"; 		
				}
			}
			$sql = substr($sql, 0, strlen($sql)-1)." from ".Gconf::get('tblpre').$k." ";
			$sql .= "where ".$v['searchkey']." like '%$kw%' ";
			$sql .= "union all ";
		}
		$sql = substr($sql, 0, strlen($sql)-strlen("union all "))." ";
		$sql .= " order by id desc limit 0, $pagesize";
		#error_log(__FILE__.": sql: $sql , kw:$kw , sql:$sql .");
		#print(__FILE__.": sql: $sql , kw:$kw , sql:$sql .");
		$hm = $this->execBy($sql);
		#print_r($hm);

		return $hm;

	}

}

?>
