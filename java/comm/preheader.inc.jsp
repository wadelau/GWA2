<%@page 
import="java.util.Date,
java.util.HashMap,
java.util.Map,
java.util.Iterator,
java.io.File,
org.lilystudio.smarty4j.Context,
org.lilystudio.smarty4j.Engine,
org.lilystudio.smarty4j.Template" 
language="java" 
pageEncoding="UTF-8"%><%

//-  preheader, embedded in all

System.setProperty("sun.jnu.encoding", "UTF-8");
System.setProperty("file.encoding", "UTF-8"); //- set " -Dfile.encoding=utf8 " in jvm start script
request.setCharacterEncoding("UTF-8");

%><%@include file="./Wht.tools.inc.jsp"%><%

//- global variables across the app, embedded in two types of files: /index, /ctrl/xxx
//- need to init before manipulate
%><%!String sid, appdir, siteid, fmt, smttpl, mod, act, rtvdir, url;
HashMap data; StringBuffer outx; %><%

data = new HashMap(); //- for tpl data container

outx = new StringBuffer(); //- for $out in -PHP

%>
