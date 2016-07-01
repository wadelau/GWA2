<%
/* controller of user mod
 * v2
 */
%><%@include file="./ctrlheader.inc.jsp"%><%

%><%@include file="../mod/User.class.jsp"%><%



User user = new User();

user.set("iname", "Wadelau");

outx.append("ctrl/user: iname:["+user.get("iname")+"] dbname-from-conf:["+Config.get("dbname")+"]\n");


//- main busi logic

if(act.equals("signin")){
	//--
	outx.append("outx "+act+" in ctr/user\n");

}
else if(act.equals("dosignin")){
	 
	outx.append("outx "+act+" in ctr/user\n");

}
else{
	
	outx.append("outx unknown act:["+act+"] in ctr/user\n");

}


//- tpl
if(fmt.equals("")){
	
	smttpl = "user.html";
	
}

%><%

%><%@include file="./ctrlfooter.inc.jsp"%><%

%>
