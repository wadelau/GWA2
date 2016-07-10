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

public boolean isClass(String className){
	
    try{
        Class.forName(className);
        return true;
    }
    catch (final ClassNotFoundException e){
        return false;
    }
    
}

%>
