##### GWA2开发参考 #####
##### Tue May  6 08:36:18 CST 2014


################# GWA2 手册 ###########

-GWA2 (-自然域名, 首次使用请访问 http://ufqi.com/naturedns 先)


############## 关于项目贡献度 ##############
首先以活动时间为衡量单位
活动时间的衡量以开发人员通过Vim或者Notepad++连服务器的工作时间计数, 也即在服务器上能看到的活动时间


################### 关于 RESTful URL地址风格的实现, Mon Oct 15 22:15:17 CST 2012

1. 资源访问路径中的 ? 去掉

此前的: http://ufqi.com/dev/xxx/index.php?mod=web&act=preview&id=1234
RESTful的: http://ufqi.com/dev/xxx/index.php/mod/web/act/preview/id/1234

2. 规则，"?" 后面的参数，总是成对出现，奇数位的是参数名称，偶数位是参数值, 

3. 实现：
在后台程序中，使用 $url."/para/value" 的样式拼合
在Smarty模板红，使用那个 {$url}/para/value 的样式拼合

在入口程序中，./index.php 对 / 分割的参数重新转为 $_REQUEST 变量，同时重写

$_REQUEST['para'] = value;
$_SERVER['REQUEST_URI']; 
$_SERVER['QUERY_STRING'];

4. 在其他程序中，与普通动态地址一样使用

5. TODO: 需要对 value 中的 "/" 做转义或者编码

!!!RESTful URL地址风格在默认情况下不开启.


################## 关于 class/module 与 table 的对应关系，10:42 Saturday, August 25, 2012

1. class或者module并不是一一对应的，class或者module是指一个实物对象，而为了存储一个实物对象，可能需要多张数据表 table

2. 就是说，一个class对应多个table，是一对多的关系，相反，一个table至多对应一个 class

3. 
       /  table-1
class  -- table-2
       \  table-3

4. 一些表述，不需要单独一个对象，或者对象不明的，可以使用下面的方式读取表：
以读取 abctbl 的数据为例：

$webapp = new WebApp();
$webapp->setTbl("abctbl");
$hm = $webapp->getBy("*", $condition);
...


##### 数据库建表注意事项

1. 不使用中文字符做 comment

2. 不使用 varchar， 使用 char

3. 不允许 null， 每个字段都指定 default 默认值

4. 每个表至少有一个 primary key和 unique index key

5. 公共字段： 
	id int(11) auto_increment, 
	state tinyint(1) not null default 1, 
	updatetime datetime not null default 0, 
	operator char(32) not null default ''

6. 表名, 前缀 如 lsh_ , 后缀， tbl , 如 lsh_categorytbl，不使用复数形式

7. 字段名，两个以上单词构成的，不需要下划线连接，除非有明显的歧义

8. 表名和字段名中相邻的重复字符不省略，如 inserttime , 不能写成 insertime.

9. 使用 -gMIS 作为管理后台的话，需要有些基础设置表


##### 数据从后台到前端 ####################### 
阿成，我来演示前端读取 adlist了

水哥(7221995)  21:41:47
第一步： 创建 class/ads.class.php 模块

水哥(7221995)  21:43:49
第二步，在 ctrl/index.php include 进来，

水哥(7221995)  21:45:37
include($appdir."/class/ads.class.php");

第三步，实例化，并读取
$ads = new ADS();
$hm_homepage_adlist = $ads->getBy('*', "adplace='homepage' and state=1");
$data['hm_homepage_adlist'] = $hm_homepage_adlist;

第四步，在前端使用 smarty语句循环 $hm_homepage_adlist

smarty 手册参考： http://www.smarty.net/docs/zh_CN/



##### 用户处理流程 ##############################
用户请求处理流程

0. 用户请求统一入口地址 index.php?mod=xxxx&act=yyyy

1. 请求经过 index.php 分发给 ctrl/ 目录下的对应 mod 控制器，如 ctrl/user.php

2. 控制器 ctrl/user.php 中调用模块 model 的类，如 class/user.class.php 或者 mod/user.class.php, 实现改变对象的状态等

3. 在控制器 ctrl/user.php 中完成业务逻辑的处理，设置输出的 $data 数组 和 模板文件 如 view/user.html

4. 模板引擎 smarty 将 $data 和 view/user.html 模板文件做拼合 merge 操作，最终生成用户端的 html 页面

5. 关键步骤，第 2 步，控制器里加载模型对象 .


##### 关于目录结构 #########################
目录介绍
admin -- 管理后台, 通常使用 -gMIS 作为管理后台


####### 关于多语言支持 ######

index.php --> language.php (ctrl/include/language.php) 
	--> langlist.php (lang/langlist.php) --> en_US / zh_CN (lang/en_US.properties)

