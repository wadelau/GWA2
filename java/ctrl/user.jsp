<%
/* controller of user mod
 * v2
 */
%><%@include file="./ctrlheader.inc"%><%

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


%><%

%><%@include file="./ctrlfooter.inc"%><%

%>
