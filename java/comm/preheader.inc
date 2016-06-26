<%
//-  preheader, embedded in all
%><%@page import="
java.util.Date, java.util.HashMap,
com.ufqi.gwa2.Wht,
" pageEncoding="utf-8"%><% 


//- global variables across the app, embedded in two types of files: /index, /ctrl/xxx
//- need to init before manipulate
%><%!String sid, appdir, siteid, fmt, smttpl, mod, act;
HashMap data; StringBuffer outx; %><%

data = new HashMap();

outx = new StringBuffer();

%>
