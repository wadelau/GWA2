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
%><%@include file="./comm/header.inc"%><%


//- main logic
mod = request.getParameter("mod");
act = request.getParameter("act");
if(mod == null){ mod = ""; }else{ mod = mod.trim(); }
if(act == null){ act = ""; }else{ act = act.trim(); }
if(mod.equals("")){
  mod = "index";    
}

data.put("mod", mod);
data.put("act", act);


/*
 * Due to issues of performance and security of java.lang.reflection,
 * We do not use it as routing or dynamic module invoking at present.
 */

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

//- something shared across the app
if(true){
	
	%><%@include file="./ctrl/include.jsp"%><%

}


//- footer
%><%@include file="./comm/footer.inc"%><%

%>
