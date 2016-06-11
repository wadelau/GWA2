<%
//
// the application entry...
/* -GWA2 is ported into Java
 * Wadelau@ufqi.com
 * v0.1
 * Thu Jun  9 14:02:51 CST 2016
 * Method in a class should be limited under 16KB
 */
//
%><%@page import="
java.util.Date, java.util.HashMap,
com.ufqi.gwa2.WTool,
" pageEncoding="utf-8"%><% 


//- header
%><%
//@include file="./inc/WTool.java" //?
%><%
%><%@include file="./comm/header.inc"%><%


//- main logic
String mod = request.getParameter("mod");
String act = request.getParameter("act");
if(mod == null){ mod = ""; }else{ mod = mod.trim(); }
if(act == null){ act = ""; }else{ act = act.trim(); }
if(mod.equals("")){
  mod = "index";    
}

data.put("mod", mod);
data.put("act", act);

if(mod.equals("index")){

	%><%@include file="./ctrl/index.jsp"%><%

}
else if(mod.equals("user")){
	
	%><%@include file="./ctrl/user.jsp"%><%
	
}
else{

	outx = new StringBuffer("Unknown mod:["+mod+"]. 1606110925.");	
	out.println(outx);
	return;
	//-todo: log
}

//- footer
%><%@include file="./comm/footer.inc"%><%

/*
$data['mod'] = $mod;
$data['act'] = $act;
$data['baseurl'] = $baseurl;

if(file_exists("./ctrl/".$mod.".php")){
	include("./ctrl/".$mod.".php");
}
else{
	print "ERROR.";	
	error_log(__FILE__.": found error mod:[$mod]");
	exit(0);
}

$smttpl_orig = $smttpl;

if($mod != 'index'){
  include("./ctrl/index.php"); # here is buggy, any unshared business logic should not be placed in index mod.
}

# footer.inc file
include("./comm/footer.inc");

# add more ---

*/
%>
