# GWA2
GWA2 is General Web Application Architecture. 

![gwa2](http://ufqi.com/blog/wp-content/uploads/2016/06/gwa2-logo-201606.png)
----
[-NatureDNS](http://ufqi.com/naturedns) : [-GWA2](http://ufqi.com/naturedns/search?q=-gwa2) , [-吉娃兔](http://ufqi.com/naturedns/search?q=-吉娃兔)

*From Interface to Interactions*

*From Demand to Design*

***Three Layers***
----
*Core Services*, 
  which also being called compenents, consists of databases, sessions, quenes, caches, file-systems....; 

*Objects*, 
  business-oriented objects, which stand for what to do, i.e., users, products, transactions, locations, articles....; 

*Interactions*, 
  beared with objects, which define how to do, i.e., request, responses, UI, UE, HCI.... 

***Three Layers II***
----
*Modules* , 

*Controllers* ,

*Views*

***Three Layers III***
----
*Objects* , 

*Handlers* ,

*Drivers*

***Three Instances***
----
*-PHP* , 

*-Java* ,

*-Aspx*

----

# An Example Module (User)

##user module, 用户模块

###0. create table, 建表
```sql
create table gmis_usertbl(
  id int(11) not null auto_increment,
  iname char(32) not null default '',
  email char(32) not null default '',
  password char(64) not null default '',
  ibirthday date not null default '0000-00-00',
  igroup tinyint(1) not null default 0,
  istate tinyint(1) not null default 1,
  inserttime datetime not null default '0000-00-00 00:00:00',
  updatetime datetime not null default '0000-00-00 00:00:00',
  primary key k1(id),
  unique index k2(email)
);
```

###1. create module class, 创建对象类
mod/user.class.php

继承  inc/webapp.class.php 

实现   inc/webapp.interface.php 


###2. create controller, 创建控制器
ctrl/user.php

引入 mod/user.class 并实例化

根据 $act 区分不同的代码模块

  act=signin

  act=signup

  act=update

  act=logout

  act=my

在控制器中处理逻辑，然后指定要加载的模板，引入 smarty

###3. create view, 创建视图页面
view/default/signin.html

其中 view 是模块目录， default 是默认风格

  view/default/signup.html

  view/default/update.html

  view/default/logout.html

  view/default/my.html

###4. define routing, 在入口定义模板
/index.php?mod=user&act=xxxx

