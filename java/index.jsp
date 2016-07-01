<%
/* -GWA2 is ported into Java
 * Wadelau@ufqi.com
 * v0.1
 * Thu Jun  9 14:02:51 CST 2016
 */

// the application entry...

//-  entry header
%><%@include file="./comm/header.inc.jsp"%><%


//- main logic
mod = request.getParameter("mod");
act = request.getParameter("act");
if(mod == null){ mod = ""; }else{ mod = mod.trim(); }
if(act == null){ act = ""; }else{ act = act.trim(); }
if(mod.equals("")){
  mod = "index";    
}

data.put("mod", mod);
data.put("act", act);


/*
 * Due to 
 * 1) issues of performance and security of java.lang.reflection,
 * 		We do not use it as routing or dynamic module invoking at present.
 * 2) issues of performance and seperated runtime environment of dispatcher forward,
 * 		we do not use it as page embedded for routing at present.
 * Though dynamic dispatcher include, similiar to the 2nd one,
 *  it will trigger two instances of a single request, it still is better than
 *		wrap all entries in a single jsp servlet.
 */

//- some logic loading 
StringBuffer modf = new StringBuffer(appdir).append("/ctrl/").append(mod).append(".jsp");
String modfs = modf.toString();
outx.append("/index: ctrl:["+modfs+"]\n");
String realModfs = application.getRealPath(modfs);
outx.append("/index: realpath:["+realModfs+"]\n");

if((new File(realModfs)).exists()){

	//- collect runtime data into request
	HashMap prtPage = new HashMap();
	prtPage.put("data", data);
	prtPage.put("outx", outx);
	prtPage.put("mod", mod);
	prtPage.put("act", act);
	prtPage.put("smttpl", smttpl);
	prtPage.put("fmt", fmt);

	request.setAttribute("prtPage", prtPage);

	//- process of another instance	
	request.getRequestDispatcher(modfs).include(request, response);

	//- restore runtime data into response
	prtPage = (HashMap)request.getAttribute("prtPage");

	//- response headers from child page
	if(true){
		Iterator entries = prtPage.entrySet().iterator();
		while (entries.hasNext()) {
			Map.Entry entry = (Map.Entry) entries.next();
			String key = (String)entry.getKey();
			if(key.indexOf("response") >= 0){
				Object value = entry.getValue();
				outx.append("Key = " + key + ", Value = " + value);
				String[] setArr = key.split("::"); 
				if(setArr[1].equals("setHeader")){ // prtPage.put("response::setHeader::Location", "/?mod=user&act=signin");
					response.setHeader(setArr[2], (String)value);
				}
				else if(setArr[1].equals("addCookie")){ // prtPage.put("response::addCookie::", "COOKIE_BODY");
					response.addCookie((javax.servlet.http.Cookie)value);
				}
				else if(setArr[1].equals("sendError")){ // prtPage.put("response::sendError::", "HTTP_Error_CODE");
					response.sendError((int)value);
				}
				else if(setArr[1].equals("setStatus")){ // prtPage.put("response::setStatus::", "HTTP_Error_CODE");
					response.sendError((int)value);
				}
			}
			else{
				//out.println("not resp Key = " + key );
			}
		}
	}

	//-- test for extra validator
	if(false){
		java.util.Collection eNames = response.getHeaderNames();
		java.util.Iterator ei = eNames.iterator();
		while (ei.hasNext()) {
			String name = (String) ei.next();
			String value = (String)(response.getHeader(name));

			outx.append("\nresponse: k:["+name+"] v:["+value+"]\n");

		}
	}

	
}
else{

	//- no exist//- continue this way
	outx = new StringBuffer("\n/index: Unknown mod:["+mod+"] with act:["+act+"] modfs:["+modfs+"]. 1606110925.\n");	
	//- #todo: log

}

//- something shared across the app, out of comm/header
if(true){
	
	%><%@include file="./ctrl/ctrl.inc.jsp"%><%

}


//- footer
%><%@include file="./comm/footer.inc.jsp"%><%

%>
