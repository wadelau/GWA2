<%
/* User class for user center 
 * v0.1,
 * wadelau@ufqi.com,
 * Sat Jun 18 10:28:02 CST 2016
 */

//package com.ufqi.mod;

//import java.util.HashMap;

//import com.ufqi.gwa2.WebApp;

%><%@include file="../inc/WebApp.class.jsp"%><%

%><%!

public class User extends WebApp{
	

	//- constructor ?
	public User(){
	
		dba = new Dba("");
		this.setTbl("gwa2_info_usertbl");


	}


	public String hiUser(){
	
		this.set("pagesize", 10);
		this.set("email", "%lzx%");
		this.set("email.2", "%163%");
		this.set("realname", "%");
		this.set("orderby", "id desc");
		
		HashMap userInfo = this.getBy("id, email, realname, updatetime", "(email like ?  or email like ?) and realname like ?");

		userInfo.put("read-in-User", (new Date()));	

		return (String)this.get("iname") + ", Welcome! "+ userInfo.toString();

	}
	

}

%>