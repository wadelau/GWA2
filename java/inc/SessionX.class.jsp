<%
/* 
 * Session Driver, general session
 * v0.1
 * Xenxin@ufqi.com
 * since Fri Jun 29 07:12:38 UTC 2018
 */
%><%@page import="java.util.*"%><%
%><%!

public final class SessionX implements SessionDriver {

	//- variables

	//- constructor
	public SessionX(SessionConn myConn){
		//- @todo

	}	
	
	//- methods, public
	public String generateSid(User user, HttpServletRequest request){
		String sid = "";
		sid = Zeea.md5("inc-SessionX-" + (new Random()).nextInt());
		return sid;
	}

	//-
	public Object get(String key){

		//- @todo
		return (new Object());

	}

	//-
	public boolean set(String key, Object val){
		boolean isSucc = true;

		return isSucc;
	}
	
	//-
	public boolean rm(String key){
		boolean isSucc = true;

		return isSucc;
	}
	

	//- methods, private
	
	
}

%>
