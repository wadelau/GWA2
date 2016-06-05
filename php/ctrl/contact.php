<?php

# controlling of homepage


//$_SESSION['language'] = $language;

//include_once($appdir."/ctrl/include/language.php");


#下面是中文表对应的class
include_once($appdir."/mod/ads.class.php");
include_once($appdir."/mod/addressadmin.class.php");
include_once($appdir."/mod/contact.class.php");


# some other stuff

//增加广告展示数据
  $adplace = 'contactfdk';
  include('include/ads.php');


//增加地址管理数据

  include('include/addressadmin.php');
  //print_r($hm_addresses);
  
if($act == "dosendmsg")
{
    $name = $_POST['name'];
	$email = $_POST['email'];
    $message = $_POST['message'];
	
	$contact = new Contact();
	$contact->set("name", $name);
	$contact->set("email", $email);
	$contact->set("content", $message);
	$hm = $contact->setBy('name, email, content', null);
	if( $hm[0]==1 ) { 
	} else {
		alert("修改失败，请联系我们!");
	}
}

if($out == '' && $smttpl == ''){ # if other module do not define a smttpl and $conf['display_style_smttpl']? 
	     
	$smttpl = 'contact.html';
}

?>
