<?php /* Smarty version Smarty-3.1.7, created on 2015-02-11 14:09:45
         compiled from "/www/webroot/shundaishao/view/default/index.html.tmp" */ ?>
<?php /*%%SmartyHeaderCode:114536868854bba602d13662-36418579%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '98e13c3dc6f3936d6659c421792f7b93cc1914d8' => 
    array (
      0 => '/www/webroot/shundaishao/view/default/index.html.tmp',
      1 => 1423634985,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '114536868854bba602d13662-36418579',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.7',
  'unifunc' => 'content_54bba602d5f42',
  'variables' => 
  array (
    'url' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_54bba602d5f42')) {function content_54bba602d5f42($_smarty_tpl) {?><!DOCTYPE html>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><meta charset="utf-8" />
<meta name="keywords" content="顺带捎, 捎带, 顺带, 顺路捎带" />
<meta name="description" content="顺带捎是顺路捎带的意思, 为常规物流的有意补充, 对特急, 偏远地区的快递，对提高通行效率, 节约出行成本有重要意义. 让路上没有空驶的车, 让道上没有空手的人" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />

<meta name="viewport" content="width=device-width,initial-scale=1" />
<meta http-equiv="cleartype" content="on" />
<link rel="stylesheet" href="/view/default/css/multiscreen.normalize.css" />
<link rel="stylesheet" href="/view/default/css/multiscreen.main.css" />
<link rel="stylesheet" href="/view/default/css/multiscreen.base.css" />
<link type="image/x-icon" rel="shortcut icon" href="favicon.ico" />

<title>-顺带捎 , -shundaishao , shundaishao.com</title>
</head>
<body>
<div id="container">

<div id="header">
        <h3><a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
">顺带捎</a> . <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&mod=item">货找人</a> . <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&mod=route">人找活</a> 
                . <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&mod=sds">我的捎带</a></h3>
        --------
        现在的位置，
</div>
   
<!-- saturday.. include file="include/header.html" -->
 
<?php echo $_smarty_tpl->getSubTemplate (($_smarty_tpl->tpl_vars['smttpl']->value), $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>


<!-- include file="include/footer.html" -->


<div class="clear"></div>

<div id="footer">
        <script type="text/javascript"> 
        function diffInYearsAndDays(startDate, endDate) {
            // Copy and normalise dates
            var d0 = new Date(startDate);
            d0.setHours(12,0,0,0);
            var d1 = new Date(endDate);
            d1.setHours(12,0,0,0);
            // Make d0 earlier date
            // Can remember a sign here to make -ve if swapped
            if (d0 > d1) {
                var t = d0;
                d0 = d1;
                d1 = t;
            }  
            // Initial estimate of years
            var dY = d1.getFullYear() - d0.getFullYear();
            // Modify start date
            d0.setYear(d0.getFullYear() + dY);
            // Adjust if required
            if (d0 > d1) {
                d0.setYear(d0.getFullYear() - 1);
                --dY;
            }
            // Get remaining difference in days
            var dD = (d1 - d0) / 8.64e7;
            // If sign required, deal with it here
            return [dY, dD];  
        }
        </script>
        <br/>
        <br/>
        自然域名(NatureDNS): <a href="#-shundaishao">-顺带捎</a> .<a href="./"><script type="text/javascript">diff=diffInYearsAndDays('2015-01-18',(new Date()));document.write(' '+diff[0]+' yrs and '+diff[1]+' days.');</script></a>
        
        <div class="inder_othrer">
                <ul>
            	<li>
                	<a href="mailto:wadelau@gmail.com?subject=suggestion-on-shundaishao">Suggestion?</a>	
                </li>
                <br/>让路上没有空驶的车, 让道上没有空手的人。
                <br/> &nbsp;<img src="http://api.qrserver.com/v1/create-qr-code/?size=160x160&data=http://www.shundaishao.com" alt="shundaishao.com" />
            </ul>
        </div>

</div><!--footer-->

    
</div>
</body>
    <script type="text/javascript">
    //- create -naturedns urlredir for this page.
    //-- added by wadelau@ufqi.com on Thu Oct 24 11:35:21 CST 2013
    (function(win){
     var url = '';
     var ipos = 0;
     var preurl = 'http://ufqi.com/naturedns/search?q=';
     var ndnstag = '#-'; //- tag userd in <a href="#-r/abbc">
     for(var i=0, l=document.links.length; i<l; i++){
        url = document.links[i].href;
        ipos = url.indexOf(ndnstag); 
        if(ipos > 0){
            url = url.substring(ipos+1);
            document.links[i].href = preurl + url;
        }
     }
	 //window.alert(typeof console);
	 if(typeof console !== 'undefined'){
     	win.console.log('-NatureDNS initiated.');
	 }
     })(window);
    </script>
</html>

<?php }} ?>