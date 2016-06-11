<%
//- embedded in ./index

String sid, appdir, siteid, fmt;

HashMap data = new HashMap();

//- tpl engine
//- todo: smarty4java

StringBuffer outx = new StringBuffer("Outx in index@"+(new java.util.Date())); // $out in PHP

outx.append("\ncontextPath:["+request.getContextPath()+"] pathinfo:["+request.getPathInfo()+"]");
outx.append("\nrequestURL:["+request.getRequestURL()+"] servletPath:["+request.getServletPath()+"]");


%><%!
public String HT(){
	
	String ns = "";

	return ns;

}
%>
