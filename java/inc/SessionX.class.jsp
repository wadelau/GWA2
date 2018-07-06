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
	private static final String Data_Sep = "";
	private String Session_Private_Key = "";

	//- constructor
	public SessionX(SessionConn myConn){
		//- @todo
		this.Session_Private_Key = (String)Config.get("sign_key");
	}	
	
	//- methods, public
	//-
	public String generateSid(User user, HttpServletRequest request){
		String sid = "";
		sid = Zeea.md5("inc-SessionX-" + (new Random()).nextInt());
		return sid;
	}
	
	//-
	public HashMap checkSid(User user, HttpServletRequest request, String sid){
        HashMap hmrtn = new HashMap();
        boolean isValid = false;
        //- @todo
        return hmrtn;
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
