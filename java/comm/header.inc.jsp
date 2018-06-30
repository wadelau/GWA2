<%
//- app header

%><%@include file="./preheader.inc.jsp"%><%

//outx.append("\n\tcomm/header: contextPath:["+request.getContextPath()+"] pathinfo:["+request.getPathInfo()+"]");

rtvdir = request.getServletPath();
appdir = application.getRealPath(rtvdir);

if(true){
	rtvdir = rtvdir.substring(0, rtvdir.lastIndexOf('/')); 
	int ipos = appdir.lastIndexOf('/');
	appdir = appdir.substring(0, (ipos==-1 ? 0 : ipos));
	if(appdir.equals("")){ //- in case of Windows
		appdir = (getServletContext().getRealPath("/"));
		appdir = appdir.replaceAll("\\\\", "/");
		appdir = appdir.substring(0, appdir.length()-1);
		appdir += "" + rtvdir;
	}
}
outx.append("\n\tcomm/header: requestURL:["+request.getRequestURL()+"] servletPath:["+request.getServletPath()
		+"] rtvdir:["
		+rtvdir+"] appdir:["+appdir+"] 1607100803.\n"); //- appdir:["+appdir+"] 

rtvdir = rtvdir.equals("") ? "." : rtvdir;

sid = Wht.get(request, "sid");
if(sid.equals("")){ sid = (new java.util.Random()).nextInt(999999); }
url = rtvdir + "/?sid=" + sid; 

user = new User();

fmt = Wht.get(request, "fmt");
//- set header according to fmt
response.setCharacterEncoding("utf-8");
if(fmt.equals("")){
	response.setContentType("text/html;charset=utf-8");
}
else{
	if(fmt.equals("xml")){
		response.setContentType("text/xml;charset=utf-8");
	}
	else if(fmt.equals("json")){
		response.setContentType("application/json;charset=utf-8");
	}
	else{
		debug("comm/header: unsupported fmt:["+fmt+"]");
	}
}

smttpl = "";

%>