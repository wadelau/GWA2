<%
/* By this way, a request will trigger the second instance,
 * which may be an overheat on performace, but can be extended to a large scale
 * noted by wadelau @ Fri Jun 17 06:46:42 CST 2016
 */

%><%@include file="./ctrlheader.inc"%><%

//- main busi logic

out.println("\nbgn: output in /ctrl/index. @"+(new java.util.Date())+"\n");

act = act.equals("") ? "index" : act;

if(act.equals("index")){

	outx.append("/ctrl/index: succ. get act:["+act+"] with mod:["+mod+"]\n");

}
else{

	outx.append("/ctrl/index: fail. reach Unknown act:["+act+"] with mod:["+mod+"]\n");

}

outx.append("\nend: appending to outx in /ctrl/index."+(new java.util.Date()) + "\n");

%><%

%><%@include file="./ctrlfooter.inc"%><%

%>
