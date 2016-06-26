<%
//- app header
%><%@include file="./preheader.inc"%><%
%><%@page import="
java.io.File,
"%><%

outx.append("comm/header: Outx in header@"+(new java.util.Date())+", appdir:["+appdir+"]"); // $out in PHP

outx.append("\n\tcomm/header: contextPath:["+request.getContextPath()+"] pathinfo:["+request.getPathInfo()+"]");

appdir = request.getServletPath();
appdir = appdir.substring(0, appdir.lastIndexOf('/')); 

outx.append("\n\tcomm/header: requestURL:["+request.getRequestURL()+"] servletPath:["+request.getServletPath()+"] appdir:["+appdir+"]\n");

//- tpl engine
//- todo: smarty4java

smttpl = "";

fmt = Wht.get(request, "fmt");

//- request headers
if(false){
	java.util.Enumeration eNames = request.getHeaderNames();
	while (eNames.hasMoreElements()) {
		String name = (String) eNames.nextElement();
		String value = (String)(request.getHeader(name));

		outx.append("header: k:["+name+"] v:["+value+"]\n");

	}
}

//- system env
if(false){
	java.util.Properties p = new java.util.Properties();
	p = System.getProperties();
	HashMap m = new HashMap(p);
	outx.append("\n\n" + m.keySet() +"=" +m.values()+"\n\n");
	//- jdk 8
	//m.keySet().forEach(k, v) -> out.println("system: k:["+k+"] v:["+v+"]");
}



%><%!
public String HTX(){
	
	String ns = "";

	return ns;

}
%>
