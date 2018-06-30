<%@page 
import="java.util.Date,
java.util.HashMap,
java.util.Map,
java.util.Iterator,
java.util.Arrays,
java.util.Random,
java.text.SimpleDateFormat,
java.io.File,
org.lilystudio.smarty4j.Context,
org.lilystudio.smarty4j.Engine,
org.lilystudio.smarty4j.Template"
language="java" 
pageEncoding="UTF-8"%><%

//- import="_jsp._dev._gwa2test._java._inc.*" 

//-  preheader, embedded in all

System.setProperty("sun.jnu.encoding", "UTF-8");
System.setProperty("file.encoding", "UTF-8"); //- set " -Dfile.encoding=utf8 " in jvm start script
request.setCharacterEncoding("UTF-8");

//- all I/O toolsets
%><%@include file="./Wht.tools.inc.jsp"%><%
//- global configs
%><%@include file="./Config.class.jsp"%><%!
//- parent of all objects
%><%@include file="../inc/WebApp.class.jsp"%><%
//- user
%><%@include file="../mod/User.class.jsp"%><%

//- global variables across the app, embedded in two types of files: /index, /ctrl/xxx
//- need to init before manipulate
%><%!String sid, appdir, siteid, fmt, smttpl, mod, act, rtvdir, url;
HashMap data; StringBuffer outx; User user; %><%

data = new HashMap(); //- for tpl data container

outx = new StringBuffer(); //- for $out in -PHP

%><%!
/*
* # write log in a simple approach
* # by wadelau@ufqi.com, Sat Oct 17 17:38:26 CST 2015
* # e.g.
* # debug($user);
* # debug($user, 'userinfo');  # with tag 'userinfo'
* # debug($user, 'userinfo', 1); # with tag 'userinfo' and in backend and frontend
*  reported into GWA2 Java by wadelau, 19:43 18 July 2016
*/
public static void debug(Object obj, String tag, String output){
	
	StringBuffer s = new StringBuffer((new Date()).toString());
	s.append(" ");
	
	tag = tag==null ? "" : tag;
	if(!tag.equals("")){
		s.append(tag).append(":[");
	}
	
	if(obj == null){
		s.append("");
	}
	else{
		s.append(obj.toString());
	}
	
	if(!tag.equals("")){
		s.append("]");
	}
	
	output = output==null ? "" : output;
	if(output.equals("") || output.equals("0")){
		System.out.println(s.toString());
	}
	else if(output.equals("1")){
		String ss = s.toString();
		System.out.println(ss);
		//((new javax.servlet.http.HttpServletResponse()).getWriter()).println(ss); //write(ss);
	}
	else{
		//-
		System.out.println("comm/header.inc.jsp: unsupported output:["+output+"] 1607182227.");
		(new Throwable()).printStackTrace();
		
	}
    
}

public static void debug(HashMap obj){
	
	debug((Object)obj, null, null);
	
}


public static void debug(String obj){
	
	debug((Object)obj, null, null);
	
}

//- for urlencode / escape, etc
%><%@include file="../mod/Base62x.class.jsp"%>