<%
//- embedded in all ctrls
%><%@include file="../comm/preheader.inc.jsp"%><%

//- inherit crsPage from caller
HashMap crsPage = (HashMap)request.getAttribute("crsPage");

outx = (StringBuffer)crsPage.get("outx");
data = (HashMap)crsPage.get("data");

mod = (String)crsPage.get("mod");
act = (String)crsPage.get("act");
smttpl = (String)crsPage.get("smttpl");
fmt = (String)crsPage.get("fmt");
url = (String)crsPage.get("url");

%>
