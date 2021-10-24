<%@page 
language="java" 
pageEncoding="UTF-8"
trimDirectiveWhitespaces="true"%><%
/* By this way, a request will trigger the second instance,
 * which may be an overheat on performace, but can be extended to a large scale
 * noted by wadelau @ Fri Jun 17 06:46:42 CST 2016
  * need pageEncoding for non-ascill characters in the source code, e.g. Chinese, Japanese, Russia... 17:29 2020-07-29
 */

%><%@include file="./ctrlheader.inc.jsp"%><%

//- vars
List<FileItem> formItems = null; // in case of file uploads
if(act.equals("partner2")){ //- specific actions limited
	//- trans parameters if multipart for file upload, see inc/FileSystem
	if (ServletFileUpload.isMultipartContent(request)) {
		debug("ctr/item: submit form is multipart!");
		ServletFileUpload sfileupld = new ServletFileUpload((new DiskFileItemFactory()));
		formItems = sfileupld.parseRequest(request); // can only be parsed once!
		if (formItems != null && formItems.size() > 0){
			String iname, ivalue; byte[] bytes; Object lastVal;
			for (FileItem item : formItems){
				// processes only fields that are common form fields
				if (item.isFormField()){
					bytes = item.getFieldName().getBytes("ISO-8859-1"); // why 8859?
					iname = new String(bytes, "UTF-8");
					bytes = item.getString().getBytes("ISO-8859-1");
					ivalue = new String(bytes, "UTF-8");
					lastVal = request.getAttribute(iname);
					if(lastVal != null){ 
						// checkbox or multiple select
						if(lastVal instanceof String[]){
							String[] tmpArr = (String[])lastVal;
							String[] tmpArr2 = new String[tmpArr.length+1];
							for(int si=0; si<tmpArr.length; si++){
								tmpArr2[si] = tmpArr[si];
							}
							tmpArr2[tmpArr.length] = ivalue;
							request.setAttribute(iname, tmpArr2);
						}
						else{
							String[] tmpArr = new String[2];
							tmpArr[0] = String.valueOf(lastVal); tmpArr[1] = ivalue;
							request.setAttribute(iname, tmpArr);
						}
					}
					else{
						request.setAttribute(iname, ivalue);
					}
					//debug("ctrl/user: iname:"+iname+", ivalue:"+ivalue+" lastVal:"+lastVal);
				}
				else{
					debug("ctrl/user: not form field: iname:"+item.getFieldName()+", ivalue:"+item.getString().length());
				}
			}
		}
	}
	else{
		debug("ctr/item: not multipart.");
	}
}

//- main busi logic

//- outx and data should added up and should not out print in the child pages
outx.append("\n\tbgn: output in /ctrl/index. @"+(new java.util.Date())+"\n");

act = act.equals("") ? "index" : act;
if(act.equals("index")){
	outx.append("\t/ctrl/index: succ. get act:["+act+"] with mod:["+mod+"]\n");
	data.put("time-"+mod+"-"+act, "we are now at "+(new Date()));
}
else{
	outx.append("\n\t/ctrl/index: fail. reach Unknown act:["+act+"] with mod:["+mod+"]\n");
}

outx.append("\n\tend: appending to outx in /ctrl/index."+(new java.util.Date()) + "\n");

/*
 * Transfer http headers to parent page
 * response.setHeader("Location", "/?mod=user&act=signin");
 * this will not work in 'include' mode, alternative way as below:
 */
//crsPage.put("response::setHeader::Location", url+"&mod=user&act=signin"); 
/* format: 
 *	reseponse::Method::Key, Value
 * e.g.
 *	"response::addCookie::", "COOKIE_BODY"
 *	"response::sendError::", "HTTP_Error_CODE"
 */

//- output
if(fmt.equals("") && mytpl.equals("")){
	mytpl = "homepage.html";
}

%><%
%><%@include file="./ctrlfooter.inc.jsp"%><%
%>