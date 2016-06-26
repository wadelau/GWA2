<%
//- embedded in all ctrls
%><%@include file="../comm/preheader.inc"%><%

//- inherit from caller
HashMap prtPage = (HashMap)request.getAttribute("prtPage");

outx = (StringBuffer)prtPage.get("outx");
data = (HashMap)prtPage.get("data");
mod = (String)prtPage.get("mod");
act = (String)prtPage.get("act");
smttpl = (String)prtPage.get("smttpl");
fmt = (String)prtPage.get("fmt");

%>
