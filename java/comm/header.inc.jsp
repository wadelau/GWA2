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
outx.append("\n\tcomm/header: requestURL:["+request.getRequestURL()+"] servletPath:["+request.getServletPath()+"] rtvdir:["
		+rtvdir+"] appdir:["+appdir+"] 1607100803.\n"); //- appdir:["+appdir+"] 

rtvdir = rtvdir.equals("") ? "." : rtvdir;

url = rtvdir + "/?sid=" + (new java.util.Random()).nextInt(999999); 

user = new User();

smttpl = "";

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

%>
