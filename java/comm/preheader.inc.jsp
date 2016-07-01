<%
//-  preheader, embedded in all
%><%@page import="java.util.Date, java.util.HashMap, java.util.Map,java.util.Iterator,java.io.File" pageEncoding="utf-8"%><%

%><%@include file="./Wht.tools.inc.jsp"%><%

//- global variables across the app, embedded in two types of files: /index, /ctrl/xxx
//- need to init before manipulate
%><%!String sid, appdir, siteid, fmt, smttpl, mod, act;
HashMap data; StringBuffer outx; %><%

data = new HashMap();

outx = new StringBuffer();

%>
