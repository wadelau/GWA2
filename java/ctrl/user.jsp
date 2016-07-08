<%
/* controller of user mod
 * v2
 */
%><%@include file="./ctrlheader.inc.jsp"%><%

%><%@include file="../mod/User.class.jsp"%><%



User user = new User();

user.set("iname", "Wadelau");
user.set("email", "%par%");

outx.append("ctrl/user: iname:["+user.get("iname")+"] dbname-from-conf:["
		+ Config.get("dbname")+"] hiuser:["+user.hiUser()+"]\n");


//- main busi logic

if(act.equals("signin")){
	//--
	outx.append("outx "+act+" in ctr/user\n");

}
else if(act.equals("dosignin")){
	 
	outx.append("outx "+act+" in ctr/user\n");
	
	String email = "lzx"+(new java.util.Random()).nextInt();
	
	user.set("email", email);
	user.set("realname", "Zhenxing Liu");
	HashMap hm = user.setBy("email,realname, updatetime", null);

	outx.append("write-in-ctrl/user-insert: return hm:["+hm.toString()+"]\n\n");
	
	user.set("email", email);
	user.set("realname", "--#-\"--'\'"+(new java.util.Random()).nextInt());
	hm = user.setBy("realname, updatetime", "email=?");

	outx.append("write-in-ctrl/user-update: return hm:["+hm.toString()+"]");
	
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