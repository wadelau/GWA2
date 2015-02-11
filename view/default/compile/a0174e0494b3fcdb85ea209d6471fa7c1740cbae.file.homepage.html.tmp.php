<?php /* Smarty version Smarty-3.1.7, created on 2015-01-18 19:11:16
         compiled from "/www/webroot/pages/openpoll/view/default/homepage.html.tmp" */ ?>
<?php /*%%SmartyHeaderCode:117796310254bb0a362bc641-94723427%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'a0174e0494b3fcdb85ea209d6471fa7c1740cbae' => 
    array (
      0 => '/www/webroot/pages/openpoll/view/default/homepage.html.tmp',
      1 => 1421579476,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '117796310254bb0a362bc641-94723427',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.7',
  'unifunc' => 'content_54bb0a3634825',
  'variables' => 
  array (
    'resp' => 0,
    'url' => 0,
    'i' => 0,
    'polllist' => 0,
    'v' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_54bb0a3634825')) {function content_54bb0a3634825($_smarty_tpl) {?><div id="main">
	<div class="banner_box">
        <div class="banner" style="line-height:24px">
            <!--
            <div class="scroll_box" id="bannerSlider">
                <div class="slides_container">
                
                </div>
            </div>
                -->
                <style>
                    .bigfont{ 
                        font-size:20px;
                        font-weight:strong;
                    }
                </style>

                <?php if ($_smarty_tpl->tpl_vars['resp']->value!=''){?>
                    <?php echo $_smarty_tpl->tpl_vars['resp']->value;?>

					<hr/><br/>
                <?php }?>

                <br/>
				<b><a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
">首页</a> | <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&act=create">创建</a> | <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&act=retrieve">提取</a>
					| <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&act=ticket">制票</a></b>

				<br/><br/>
				<?php echo $_smarty_tpl->tpl_vars['i']->value++;?>

				<?php  $_smarty_tpl->tpl_vars['v'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['v']->_loop = false;
 $_smarty_tpl->tpl_vars['k'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['polllist']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['v']->key => $_smarty_tpl->tpl_vars['v']->value){
$_smarty_tpl->tpl_vars['v']->_loop = true;
 $_smarty_tpl->tpl_vars['k']->value = $_smarty_tpl->tpl_vars['v']->key;
?>
					<li>
					<?php if ($_smarty_tpl->tpl_vars['v']->value['ipassword']!=''&&$_smarty_tpl->tpl_vars['v']->value['ipassword']!='访问密码(可选)'){?>
                		<ul><?php echo $_smarty_tpl->tpl_vars['i']->value++;?>
. <?php echo $_smarty_tpl->tpl_vars['v']->value['ititle'];?>
 [私有]</ul></li>
					<?php }else{ ?>
                		<ul><?php echo $_smarty_tpl->tpl_vars['i']->value++;?>
. <a href="<?php echo $_smarty_tpl->tpl_vars['url']->value;?>
&act=retrieve-do&pollid=<?php echo $_smarty_tpl->tpl_vars['v']->value['id'];?>
"><?php echo $_smarty_tpl->tpl_vars['v']->value['ititle'];?>
</a></ul>
					<?php }?>
					</li>
				<?php } ?>

            <br/>
        
        </div><!--banner-->
    </div>
    
    <div class="thenews">
		
    	<h3>Open-ended voting service, 开放式投票...</h3>

    	<div class="news_list" id="scrollDiv">
        </div>
       
        <div class="news_more">
        </div>

    </div>
    
    <div class="main_box">
    	
        <div class="index_list" style="line-height:26px;">
        
		<a href="#-r/openpoll">开放式投票</a> 适用在不预设选择项的情况下进行朴素民主的投票.
		<br/><b>在没有“上帝之手”给出选项的情况下，寻求最大公约数, 达成最大的共识</b>.
		<br/>
		<br/> 如：小组下次会议在什么地方碰头？ 周几聚餐一次安排在午餐还是晚餐？
		<br/> 本年度的最好看的2部/3部电影？ 
		<br/> 从我们Team中推选出2人？
		<br/> 年会安排在哪一天？
		<br/>
		<br/>
		<a href="#-r/openpoll">开放式投票</a> 解决传统投票用户无法表达主见的困境，<b/>将投票由被动变主动, 用户可以修改选项</b>。
		<br/>
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
        <a href="#-r/openpoll">Open-ended Poll</a>, 新选择. <a href="./"><script type="text/javascript">diff=diffInYearsAndDays('2015-01-11',(new Date()));document.write('Already '+diff[0]+' yrs and '+diff[1]+' days.');</script></a>

		</div>
        
        <div class="inder_othrer">
        	<ul>
            	<li>
                	<a href="mailto:liuzhenxing@people.cn?subject=suggestion-on-open-ended-poll">Suggestion?</a>	
                </li>
            </ul>
        </div>
        
    </div>

    <script type="text/javascript">
    //- create urlredir for this page.
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

</div><!--#main-->
<?php }} ?>