<%@page language="java" pageEncoding="UTF-8" autoFlush="true"%><%
/* -GWA2 is ported into Java
 * Wadelau@ufqi.com
 * v0.1
 * Thu Jun  9 14:02:51 CST 2016
 */

// the application entry...

//-  entry header
%><%@include file="./comm/header.inc.jsp"%><%


//- main logic
mod = Wht.get(request, "mod");
act = Wht.get(request, "act");
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
StringBuffer modf = new StringBuffer(rtvdir).append("/ctrl/").append(mod).append(".jsp");
String modfs = modf.toString();
String realModfs = application.getRealPath(modfs);


if((new File(realModfs)).exists()){

	//- collect runtime data into request
	HashMap crsPage = new HashMap();
	crsPage.put("data", data);
	crsPage.put("outx", outx);
	crsPage.put("mod", mod);
	crsPage.put("act", act);
	crsPage.put("smttpl", smttpl);
	crsPage.put("fmt", fmt);
	crsPage.put("url", url);

	request.setAttribute("crsPage", crsPage);

	//- process of another instance	
	request.getRequestDispatcher(modfs).include(request, response);

	//- restore runtime data into response
	crsPage = (HashMap)request.getAttribute("crsPage");

	//- response headers from child/crs page
	if(true){
		Iterator entries = crsPage.entrySet().iterator();
		while (entries.hasNext()) {
			Map.Entry entry = (Map.Entry) entries.next();
			String key = (String)entry.getKey();
			if(key.indexOf("response") >= 0){
				Object value = entry.getValue();
				outx.append("Key = " + key + ", Value = " + value);
				String[] setArr = key.split("::"); 
				if(setArr[1].equals("setHeader")){ // crsPage.put("response::setHeader::Location", "/?mod=user&act=signin");
					response.setHeader(setArr[2], (String)value);
					if(setArr[2].indexOf("Location") > -1){
						response.setStatus(302);	
					}
				}
				else if(setArr[1].equals("addCookie")){ // crsPage.put("response::addCookie::", "COOKIE_BODY");
					response.addCookie((javax.servlet.http.Cookie)value);
				}
				else if(setArr[1].equals("sendError")){ // crsPage.put("response::sendError::", "HTTP_Error_CODE");
					response.sendError((int)value);
				}
				else if(setArr[1].equals("setStatus")){ // crsPage.put("response::setStatus::", "HTTP_Error_CODE");
					response.sendError((int)value);
				}
			}
			else{
				//out.println("not resp Key = " + key );
			}
		}
	}

	// strings needs to be retrieved explictly 
	mod = (String)crsPage.get("mod");
	act = (String)crsPage.get("act");
	smttpl = (String)crsPage.get("smttpl");
	fmt = (String)crsPage.get("fmt");
	url = (String)crsPage.get("url");
	
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
