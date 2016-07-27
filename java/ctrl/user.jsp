<%
/* controller of user mod
 * v2
 */
%><%@include file="./ctrlheader.inc.jsp"%><%

%><% // @include file="../mod/User.class.jsp" //- relocated to comm/preheader.inc

%><%

%><%@include file="../mod/News.class.jsp"%><%


//- objects

News news = new News();


//- actions

user.set("iname", "Wadelau");
user.set("email", "%par%");

outx.append("\n\tctrl/user: iname:["+user.get("iname")+"] dbname-from-conf:["
		+ Config.get("dbname")+"] hiuser:["+user.hiUser()+"]\n");


//- main busi logic

if(act.equals("signin")){
	//--
	outx.append("\toutx "+act+" in ctr/user\n");
	crsPage.put("response::setHeader::Location", url + "&mod=user&act=dosignin");

}
else if(act.equals("dosignin")){
	 
	outx.append("\toutx "+act+" in ctr/user\n");
	
	String email = "lzx"+(new java.util.Random()).nextInt();
	
	user.set("email", email);
	user.set("realname", "Zhenxing Liu");
	user.set("orderby", "id desc");
	user.set("pagesize", 5);
	HashMap hm = user.setBy("email,realname, updatetime", null);

	outx.append("\twrite-in-ctrl/user-insert: return hm:["+hm.toString()+"]\n\n");
	
	user.set("email", email);
	user.set("realname", "--#-\"--'\'"+(new java.util.Random()).nextInt());
	hm = user.setBy("realname, updatetime", "email=?");

	outx.append("\twrite-in-ctrl/user-update: return hm:["+hm.toString()+"]");

	smttpl = "user.html";
	
}
else{
	
	outx.append("outx unknown act:["+act+"] in ctr/user\n");

}


//- tpl
if(fmt.equals("") && smttpl.equals("")){
	
	smttpl = "user.html";
	
}

%><%

%><%@include file="./ctrlfooter.inc.jsp"%><%

%>
