<%
/* By this way, a request will trigger the second instance,
 * which may be an overheat on performace, but can be extended to a large scale
 * noted by wadelau @ Fri Jun 17 06:46:42 CST 2016
 */

%><%@include file="./ctrlheader.inc"%><%

//- main busi logic

//- outx and data should added up and should not out print in the child pages
outx.append("\nbgn: output in /ctrl/index. @"+(new java.util.Date())+"\n");

act = act.equals("") ? "index" : act;

if(act.equals("index")){

	outx.append("/ctrl/index: succ. get act:["+act+"] with mod:["+mod+"]\n");

	data.put("time-"+mod+"-"+act, "we are now at "+(new Date()));

}
else{

	outx.append("/ctrl/index: fail. reach Unknown act:["+act+"] with mod:["+mod+"]\n");

}

outx.append("\nend: appending to outx in /ctrl/index."+(new java.util.Date()) + "\n");

/*
 * Transfer http headers to parent page
 * response.setHeader("Location", "/?mod=user&act=signin");
 * this will not work in 'include' mode, alternative way as below:
 */
prtPage.put("response::setHeader::Location", "/?mod=user&act=signin"); 
/* format: 
 *	reseponse::Method::Key, Value
 * e.g.
 *	"response::addCookie::", "COOKIE_BODY"
 *	"response::sendError::", "HTTP_Error_CODE"
 */

//- response headers
if(false){
	java.util.Collection eNames = response.getHeaderNames();
	java.util.Iterator ei = eNames.iterator();
	while (ei.hasNext()) {
		String name = (String) ei.next();
		String value = (String)(response.getHeader(name));

		outx.append("\nctrl/index: response: k:["+name+"] v:["+value+"]\n");

	}
}

//- output

if(smttpl.equals("")){
	smttpl = "homepage.html";	
}

%><%

%><%@include file="./ctrlfooter.inc"%><%

%>
