<?php
# news
#下面是中文表对应的class
include_once($appdir."/mod/ads.class.php");
include($appdir."/mod/pagenavi.class.php");
include_once($appdir."/mod/news.class.php");

# some other stuff

//增加广告展示数据
$adplace = 'news';
include('include/ads.php');

# pre-set parameters should be placed before $navi is created.
if(!isset($_REQUEST['pnskstate'])){
    $_REQUEST['pnskstate'] = 1;
}
$_REQUEST['pnps'] = 2;


//获取所有新闻咨询
$navi = new PageNavi();

if(!isset($news)){

    $news = new NEWS();

    //get the page numbers,because several pages will use the page number, so put it outside act="list"
    $orderfield = $navi->getOrder(); 
    if($orderfield == ''){
        $orderfield = "id";
        $navi->set('isasc', $orderfield=='id'?1:0);
    }

    $news->set("pagesize", 6);
    $news->set("pagenum", $navi->get('pnpn'));
    $news->set("orderby",$orderfield." ".($navi->getAsc()==0?"asc":"desc")); 

    if($_REQUEST['pntc'] == '' || $_REQUEST['pntc'] == '0'){ 

        $hm = $news->getBy("count(*) as totalcount", $navi->getCondition($news, $user));
        if($hm[0]){
            $hm = $hm[1][0];
            $navi->set('totalcount',$hm['totalcount']);
        }
    }
    $data['pagenums'] = $navi->getNaviNum();

    if(!isset($hm_newslist))
    {
        $hm_newslist = $news->getBy('*', $navi->getCondition($news, $user));
        if($hm_newslist[0]){
            $data['hm_newslist'] = $hm_newslist[1];
        }else{
            $data['hm_newslist'] = array();
        }
    }
}

if($out == '' && $smttpl == ''){ # if other module do not define a smttpl and $conf['display_style_smttpl']? 

    $smttpl = 'news.html';
}

?>
