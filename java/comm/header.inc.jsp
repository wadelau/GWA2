<%
//- app header

%><%@include file="./preheader.inc.jsp"%><%

%><%@include file="../mod/User.class.jsp"%><%

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
	//outx.append("\n\n" + m.keySet() +"=" +m.values()+"\n\n");
	//- jdk 8
	//m.keySet().forEach(k, v) -> out.println("system: k:["+k+"] v:["+v+"]");
	
	Iterator entries = m.entrySet().iterator();
	while (entries.hasNext()) {
		Map.Entry entry = (Map.Entry) entries.next();
		String key = (String)entry.getKey();
		Object value = entry.getValue();
		outx.append("key:["+key+"] value:["+value+"]\n");
	}
	
}



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
