<%
//- embedded in ./index

//- global variables across the app
//- need to init before manipulate
%><%!String sid, appdir, siteid, fmt, smttpl, mod, act;
HashMap data; StringBuffer outx;%><%

//- tpl engine
//- todo: smarty4java

data = new HashMap();

outx = new StringBuffer("Outx in index@"+(new java.util.Date())); // $out in PHP

outx.append("\ncontextPath:["+request.getContextPath()+"] pathinfo:["+request.getPathInfo()+"]");
outx.append("\nrequestURL:["+request.getRequestURL()+"] servletPath:["+request.getServletPath()+"]");


%><%!
public String HTX(){
	
	String ns = "";

	return ns;

}
%>
