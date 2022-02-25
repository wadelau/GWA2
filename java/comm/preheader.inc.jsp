<%@page 
import="java.util.*,
java.text.SimpleDateFormat,
java.io.File,
java.util.concurrent.ConcurrentHashMap,
com.ufqi.gwa2.mod.Base62x"
language="java" 
pageEncoding="UTF-8" 
session="false" 
trimDirectiveWhitespaces="true"%><%
/*
 * Tomcat-9 and below, base servlet with package prefix: javax.servlet.*
 * Tomcat-10 and above, base servlet with package prefix: jakarta.servlet.*
 * What to do with GWA2 for this change?
 * Help from Tomcat-10:  Java EE applications designed for Tomcat 9 and earlier may be placed in the $CATALINA_BASE/webapps-javaee directory and Tomcat will automatically convert them to Jakarta EE and copy them to the webapps directory.  
 * https://github.com/apache/tomcat-jakartaee-migration
 */
//-  preheader, embedded in all
System.setProperty("user.timezone", "GMT+0000"); // set -Duser.timezone="GMT+0000" in jvm start script
System.setProperty("sun.jnu.encoding", "UTF-8");
System.setProperty("file.encoding", "UTF-8"); //- set " -Dfile.encoding=utf8 " in jvm start script
request.setCharacterEncoding("UTF-8");

//- global objects only
//- all I/O toolsets
%><%@include file="./Wht.tools.inc.jsp"%><%
//- global configs
%><%@include file="../inc/Config.class.jsp"%><%
//- parent of all objects
%><%@include file="../inc/WebApp.class.jsp"%><%
//- user
%><%@include file="../mod/User.class.jsp"%><%
//- language
%><%@include file="../mod/Language.class.jsp"%><%
//- template
%><%@include file="../mod/HanjstTemplate.class.jsp"%><%

//- global variables across the app, embedded in two types of files: /index, /ctrl/xxx
//- need to init before manipulate
%><%!static ConcurrentHashMap globalDataHolder;%><%
//- local variables inside a thread, as of inside a method
String sid, appdir, siteid, fmt, mytpl, mod, act, rtvdir, url, userid;
ConcurrentHashMap data; StringBuffer outx; User user; Language lang; HanjstTemplate hanjst; 

globalDataHolder = new ConcurrentHashMap(); //- shared cross all threads, inside a process
data = new ConcurrentHashMap(); //- for tpl data container, locally, inside a thread
outx = new StringBuffer(); //- same as $out in -PHP for row strings output

%><%!
//- write/read global data into/from a thread-safe holder, 09:18 2022-02-24
//- see comm/footer
public static void globalData(String key, Object value){ //- write
	String dataKey = "GWA2-" + ProcessHandle.current().pid() + "-" + Thread.currentThread().getId();
	ConcurrentHashMap hmData = (ConcurrentHashMap)globalDataHolder.get(dataKey);
	if(hmData == null){ hmData = new ConcurrentHashMap(); }
	hmData.put(key, (value==null?"":value));
	globalDataHolder.put(dataKey, hmData);
}
public static Object globalData(String key){ //- read
	String dataKey = "GWA2-" + ProcessHandle.current().pid() + "-" + Thread.currentThread().getId();
	ConcurrentHashMap hmData = (ConcurrentHashMap)globalDataHolder.get(dataKey);
	if(hmData == null){ hmData = new ConcurrentHashMap(); }
	Object obj;
	if(key == null || key.equals("")){ obj = hmData; }
	else{ obj = hmData.get(key); }
	return obj;
}

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
		//- simple, concise
		System.out.println(s.toString());
		//- robust
		//(new Throwable(s.toString())).printStackTrace();
	}
	else if(output.equals("1")){
		//((new javax.servlet.http.HttpServletResponse()).getWriter()).println(ss); //write(ss);
		//- robust
        (new Throwable(s.toString())).printStackTrace();
	}
	else{
		//- robust
		s.append("comm/header.inc.jsp: unsupported output:["+output+"] 1607182227.");
		(new Throwable(s.toString())).printStackTrace();
	}
	s = null;
}
//-
public static void debug(HashMap obj){
	debug((Object)obj, null, null);
}
//-
public static void debug(String obj){
	debug((Object)obj, null, null);
}

%>