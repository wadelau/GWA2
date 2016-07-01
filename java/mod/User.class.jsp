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


	public String hiUser(){
	
		return (String)this.get("iname") + ", Welcome!";

	}
	

}

%>
