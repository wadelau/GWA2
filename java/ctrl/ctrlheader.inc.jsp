<%
//- embedded in all ctrls
%><%@include file="../comm/preheader.inc.jsp"%><%

//- inherit crsPage from caller
HashMap crsPage = (HashMap)request.getAttribute("crsPage");

outx = (StringBuffer)crsPage.get("outx");
data = (HashMap)crsPage.get("data");

user = new User((HashMap)crsPage.get("user"));
	outx.append("ctrl/ctrlheader: time-from-index: ["+user.get("time-in-index")+"]");

mod = (String)crsPage.get("mod");
act = (String)crsPage.get("act");
smttpl = (String)crsPage.get("smttpl");
fmt = (String)crsPage.get("fmt");
url = (String)crsPage.get("url");

%>
