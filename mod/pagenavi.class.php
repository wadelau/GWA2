<?php
/* PageNavi class
 * v0.3
 * wadelau@ufqi.com
 * Tue Jan 24 12:25:56 GMT 2012
 */

if(!defined('__ROOT__')){
  define('__ROOT__', dirname(dirname(__FILE__)));
}

require_once(__ROOT__.'/inc/webapp.class.php'); 

class PageNavi extends WebApp{

   public function PageNavi(){

       $this->dba = new DBA(); # added by wadelau@ufqi.com, Wed Jul 11 14:31:52 CST 2012
       $para = array();
       $pdef = array('pnpn'=>1,'pnps'=>28,'pntc'=>0); # 28 for development

       $file = $_SERVER['PHP_SELF'];
       #$rawurl =$_SERVER['REQUEST_URI'];
        #$idxpos = strpos($rawurl,"index.php/") + 9;
        #$file = substr($rawurl, 0, $idxpos);
       #$file = $rawurl;
       #print __FILE__.": file:$file orig:".$_SERVER['REQUEST_URI']."\n";
       $query = $_SERVER['QUERY_STRING'];
       
       if(strpos($query, "act/list-") !== false){
            $query = preg_replace("/&act=list\-([0-9a-z]*)/","&act=list",$_SERVER['QUERY_STRING']);
            $this->hmf['neednewpntc'] = 1 ;
            $query = preg_replace("/&pntc=([0-9]*)/","", $query);
       }

       $url = $file."?".preg_replace("/&pnpn=([0-9]*)/","",$query);
       
       #print __FILE__.": orig_url: $url";

       //$url=str_replace("&","/",$url); # for RESTful address
       //$url=str_replace("=","/",$url);

       $this->hmf['url'] = $url;
 
       foreach($_REQUEST as $k=>$v){
           $para[$k] = ($v==''||$v==null)?$pdef[$k]:$v;
           $this->hmf[$k]=$para[$k];
       }
       foreach($pdef as $k=>$v){
            $para[$k] = $para[$k]>0?$para[$k]:$pdef[$k];
            $this->hmf[$k]=$para[$k];
       }

   }

   function getNavi(){
       $para = $this->hmf;  
       if($this->hmf['totalcount'] > 0){
            $para['pntc'] = $this->hmf['totalcount'];
            $this->hmf['url'] = preg_replace("/&pntc\/([0-9]*)/","", $this->hmf['url']);
            //$this->hmf['url'] .= "/pntc/".$para['pntc'];
            $this->hmf['url'] .= "&pntc=".$para['pntc'];
            $para['url'] = $this->hmf['url'];
       }

       #print __FILE__.":abcdd: ";
       print_r($this->hmf);

       $totalpage = $para['pntc'] % $para['pnps'] == 0 ? ($para['pntc']/$para['pnps']) : ceil($para['pntc']/$para['pnps']);
       $navilen = 8;
       $str = "&nbsp;&nbsp;<b>页号: &nbsp;<a href=\"javascript:pnAction('".$para['url']."&pnpn=1');\" title=\"第一页\">|&laquo;</a></b>&nbsp; ";

       for($i=$para['pnpn']-$navilen; $i<$para['pnpn'] + $navilen && $i<=$totalpage; $i++){
           if($i>0){
               if($i == $para['pnpn']){
                    $str .= " <span id=\"currentpage\" style=\"color:green;font-weight:bold;font-size:18px\">".$i."</span> "; 
               }else{
                    $str .= " <a href=\"javascript:pnAction('".$para['url']."&pnpn=".$i."');\" style=\"font-size:14px\">".$i."</a> ";
               }
           }
			#print "$i: [$str] totalpage:[$totalpage]\n";
       }
       $str .= " &nbsp;<b><a href=\"javascript:pnAction('".$para['url']."&pnpn=".$totalpage."');\" title=\"最后一页\">&raquo;|</a> </b> &nbsp; &nbsp; <a href=\"javascript:void(0);\" title=\"改变显示条数\" onclick=\"javascript:var pnps=window.prompt('请输入新的每页显示条数:','".$para['pnps']."'); if(pnps>0){ myurl='".$para['url']."'; myurl=myurl.replace('/pnps/','/opnps/'); doAction(myurl+'&pnps='+pnps);};\"><b>".$para['pnps']."</b>条/页</a> &nbsp; 共 <b>".$para['pntc']."</b>条 / <b>".$totalpage."</b>页 &nbsp;";
       if($_REQUEST['isheader'] != '0'){
           $str .= "<button name=\"initbtn\" onclick=\"javascript:pnAction('".$this->getInitUrl()."');\">初始页</button>&nbsp;";
           $str .= "<button name=\"initbtn2\" onclick=\"javascript:doAction('".str_replace("&list","&list-toexcel",$para['url'])."');\">导出xls</button>";
       }

       return $str;

   }

   function getNaviNum(){
       $para = $this->hmf; 
			 #print __FILE__.":getNavi: ".$this->hmf['url'];
       #print_r($para);
       if($this->hmf['totalcount'] > 0){
            $para['pntc'] = $this->hmf['totalcount'];
            $this->hmf['url'] = preg_replace("/\/pntc\/([0-9]*)/","", $this->hmf['url']);
            $this->hmf['url'] .= "&pntc=".$para['pntc'];
            $para['url'] = $this->hmf['url'];
       }

       #print_r($this->hmf);

       $totalpage = $para['pntc'] % $para['pnps'] == 0 ? ($para['pntc']/$para['pnps']) : ceil($para['pntc']/$para['pnps']);
       $navilen = 3;

		    $pageArr = array('totalpage'=>$totalpage, 'url'=>$para['url']);

        for($i=$para['pnpn']-$navilen; $i<$para['pnpn'] + $navilen && $i<=$totalpage; $i++){

            if($i>0){

                if($i == $para['pnpn']){
                    $pageArr['currentpage'] = $i;
                }
                $pageArr['pages'][] = $i;

            }
            #print "$i: [$str] totalpage:[$totalpage]\n";
        }

       return $pageArr;

   }

   function getInitUrl(){
        $fieldlist = array('tbl','tit','db');
        $file = $_SERVER['PHP_SELF'];
        $query = "";
        foreach($_REQUEST as $k=>$v){
            if(in_array($k, $fieldlist)){
                $query .= "&".$k."=".$v;
            }
        }
        $query = "?".substr($query,1);
        return $file.$query;
   }

   function getOrder(){
       $order = "";
        foreach($_REQUEST as $k=>$v){
            if(strpos($k,"pnob") === 0){
                $order = substr($k,4); 
                break;
            }
        }
        #error_log(__FILE__.":getOrder:$order");
        return $order;
   }

   function getAsc($field=''){
       $isasc = 0; # 0: 0->1, asc, 1: 1->0, desc
       if(array_key_exists('isasc',$this->hmf)){
            if($field == '' || ($field != '' && $this->getOrder() == $field)){
                $isasc = $this->hmf['isasc']; 
            }
       }else{
           foreach($_REQUEST as $k=>$v){
               if(($field == '' || $field == substr($k,4)) && strpos($k,"pnob") === 0){
                   if($v == 1){
                       $isasc = 1; 
                       break;
                   }
               }
           }
       }
       return $isasc; 
   }

   function getCondition($gtbl, $user){
       $condition = "";
       $pnsm = $_REQUEST['pnsm']; $pnsm = $pnsm==''?"or":'and';
       $hmfield = array(); #  $gtbl->getFieldList(); # for -gMIS
       if(count($hmfield) < 1){
       		$hmfield = array();
       		$tmpHm = $gtbl->execBy("desc ".$gtbl->getTbl());	
			if($tmpHm[0]){
				$tmpHm = $tmpHm[1];
				foreach($tmpHm as $k=>$v){
					$field = $v['Field'];
					$fieldv = "fieldtype=".$v['Type'];
					if(strtolower($field)=='id'){
						$field = strtolower($field);
					}
					$hmfield[$field] = $fieldv;
				}
			}
       }

        $objpnps = $gtbl->get("pagesize"); 
       if($objpnps > 0){
        $this->hmf['pnps'] = $objpnps; # in case that pnps does not exists in URL,  remedy by wadelau, Mon Nov 19 11:18:52 CST 2012
       }

       $hidesk = ""; # $gtbl->getHideSk($user); # for -gMIS only 
       if($hidesk != ''){
           $harr = explode("|", $hidesk);
           foreach($harr as $k=>$v){
               $harr2 = explode("::", $v);
               $tmpfield = $harr2[0];
               $tmpop = $harr2[1];
               $tmpval = $harr2[2];
               $_REQUEST['pnsk'.$tmpfield] = $tmpop."::".$tmpval;
           }
       }
       #error_log(__FILE__.": req:".$this->toString($_REQUEST));

       foreach($_REQUEST as $k=>$v){
            if(strpos($k,"pnsk") === 0){
                $field = substr($k, 4);
                $linkfield = $field;
                if(strpos($field,"=") !== false){
                    $arr = explode("=", $field);
                    $field = $arr[0];
                    $linkfield = $arr[1];
                }
                if(strpos($v,"tbl:") === 0){ #http://ufqi.com:81/dev/gtbl/ido.php?tbl=hss_dijietbl&tit=%E5%AF%BC%E6%B8%B8%E8%A1%8C%E7%A8%8B&db=&pnsktuanid=tbl:hss_findaoyoutbl:id=2 
                    $condition .= " ".$pnsm." ".$field." in (".$this->embedSql($linkfield,$v).")";
                
                }else if(strpos($v,"in::") === 0){ # <hidesk>tuanid=id::in::tbl:hss_tuanduitbl:operatearea=IN=USER_OPERATEAREA</hidesk>
                    error_log(__FILE__.": k:$k, v:$v");
                    $tmparr = explode("::", $v);
                    $tmpop = $tmparr[0];
                    $tmpval = $tmparr[1];
                    if(strpos($tmpval,"tbl:") === 0){
                        $tmpval = $this->embedSql($linkfield, $tmpval);
                    }else{
                        $tmpval = $this->addQuote($tmpval);
                    }
                    $condition .= " and $field in ($tmpval)";

                }else{
                    # remedy on Sun Jun 17 07:54:59 CST 2012 by wadelau
                    $fieldopv = $_REQUEST['oppnsk'.$field]; # refer to ./class/gtbl.class.php: getLogicOp,
                    if($fieldopv == null || $fieldopv == ''){
                        $fieldopv = "=";
                    }
                    if($fieldopv == 'inlist'){
                        if($this->isNumeric($hmfield[$field]) && strpos($hmfield[$field],'date') === false){
                            # numeric
                        }else{
                            $v = $this->addQuote($v);
                        }
                        $condition .= " ".$pnsm." $field in ($v)";
                    }else if($fieldopv == 'inrange'){
                        $tmparr = explode(",", $v);
                        if(strpos($hmfield[$field],'date') === false){
                            $condition .= " ".$pnsm." ($field >= ".$tmparr[0]." and $field <= ".$tmparr[1].")";
                        }else{
                            $condition .= " ".$pnsm." ($field >= '".$tmparr[0]."' and $field <= '".$tmparr[1]."')";
                        }
                    }else if($fieldopv == 'contains'){
                        $condition .= " ".$pnsm." "."$field like ?";
                        $gtbl->set($field, "%".$v."%");
                    }else if($fieldopv == 'notcontains'){
                        $condition .= " ".$pnsm." "."$field not like ?";
                        $gtbl->set($field, "%".$v."%");
                    }else if($fieldopv == 'startswith'){
                        $condition .= " ".$pnsm." "."$field like ?";
                        $gtbl->set($field, $v."%");
                    }else if($fieldopv == 'endswith'){
                        $condition .= " ".$pnsm." "."$field like ?";
                        $gtbl->set($field, "%".$v);
                    }else{ 
                        $condition .= " ".$pnsm." $field $fieldopv ?"; # this should be numeric only.
                        $gtbl->set($field, $v);
                    }

                }
            }
       }

       $condition = substr($condition, 4); # first pnsm seg 
       #error_log(__FILE__.":getCondition: condition: $condition");
       $pnsc = $_REQUEST['pnsc'];
       if($pnsc != ''){
            $chkpnsc = $this->signPara($pnsc, $_REQUEST['pnsck']);
            if($chkpnsc){
                $condition = $pnsc;
            }
       }
       #error_log(__FILE__.":getCondition -2 : condition: $condition");
       return $condition; 
   }

   //- sign a preset condition para, if given a $myk, validate it 
   //- added on Sat May 12 17:46:10 CST 2012
   function signPara($para,$myk=''){
        $sharekey = 'Wadelau_20120512_*(&^&****)';
        $mydate = date("Y-m-d");
        $myk2 = substr(sha1($para.$sharekey.$mydate),0,8);
        if(!isset($myk) || $myk == ''){ 
            $myk = $myk2;

        }else{
            if($myk == $myk2){
                $myk = true;   

            }else{
                $myk = false;
            }
        }
        return $myk;
   }

   //- add quote
   function addQuote($str){
       $tmpval = $str;
       if(strpos($str,",") !== false){
           $arr = explode(",", $str);
           $tmpval = '';
           foreach($arr as $k12=>$v12){
               $tmpval .= "'".$v12."',";
           }
           $tmpval = substr($tmpval, 0, strlen($tmpval)-1);
       }else{
           $tmpval = "'".$str."'";
       }
       return $tmpval;
   }

   function embedSql($field,$v){
       $condition = "";
       $varr = explode(":",$v);
       $varr2 = explode("=",$varr[2]);
       $tmpop = "=";
       $tmpval = "'".$varr2[1]."'";
       if($varr2[1] == 'IN'){
            $tmpop = $varr2[1];
            $tmpval = $varr2[2];
            $tmpval = "(".$this->addQuote($tmpval).")";
       }
       $condition .= "select $field from ".$varr[1]." where ".$varr2[0]." ".$tmpop." ".$tmpval." order by id desc";
       return $condition;
   }  
}

