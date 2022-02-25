<%
//- embedded in all ctrls
%><%@include file="../comm/preheader.inc.jsp"%><%

//- inherit crsPage from caller
HashMap crsPage = (HashMap)request.getAttribute("crsPage");

data = (ConcurrentHashMap)crsPage.get("data");
outx = (StringBuffer)crsPage.get("outx");
user = new User((HashMap)crsPage.get("user"));
	outx.append("ctrl/ctrlheader: time-from-index: ["+user.get("time-in-index")+"]");

mod = (String)crsPage.get("mod");
act = (String)crsPage.get("act");
mytpl = (String)crsPage.get("mytpl");
fmt = (String)crsPage.get("fmt");
url = (String)crsPage.get("url");
sid = (String)crsPage.get("sid");

userid = user.getId();
if(data == null){ data = new ConcurrentHashMap(); }

//- lang again
if(true){
	HashMap langconf = new HashMap();
	langconf.put("language", Wht.getString(data, "language")); 
	langconf.put("country", Wht.getString(data, "languagecountry"));
	lang = new Language(langconf);
}
String innertpl = ""; //- for standalone template with inner child

//- start an inner modfs
try{

%>