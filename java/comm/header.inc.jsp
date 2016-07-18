<%
//- app header

%><%@include file="./preheader.inc.jsp"%><%

%><%@include file="../mod/User.class.jsp"%><%

//outx.append("\n\tcomm/header: contextPath:["+request.getContextPath()+"] pathinfo:["+request.getPathInfo()+"]");

rtvdir = request.getServletPath();
appdir = application.getRealPath(rtvdir);

rtvdir = rtvdir.substring(0, rtvdir.lastIndexOf('/')); 
appdir = appdir.substring(0, appdir.lastIndexOf('/'));

outx.append("\n\tcomm/header: requestURL:["+request.getRequestURL()+"] servletPath:["+request.getServletPath()+"] rtvdir:["+rtvdir+"] 1607100803.\n"); //- appdir:["+appdir+"] 

url = rtvdir + "?sid=" + (new java.util.Random()).nextInt(999999); 


smttpl = "";

fmt = Wht.get(request, "fmt");


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
		s.append(obj.toString();
	}
	
	if(!tag.equals("")){
		s.append("]");
	}
	
	output = output==null ? "" : output;
	if(output.equals("") || output.equals("0")){
		System.out.println(s.toString);
	}
	else if(output.equals("1")){
		String ss = s.toString();
		System.out.println(ss);
		out.println(ss);
	}
	else{
		//-
		System.out.println("comm/header.inc.jsp: unsupported output:["+output+"] 1607182227.");
		(new Throwable()).printStackTrace();
		
	}
    
}

%>
