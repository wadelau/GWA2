<%

%><%@include file="./WebApp.interface.jsp"%><%
%><%@include file="./Config.class.jsp"%><%!
%><%@include file="./Conn.class.jsp"%><%!
%><%@include file="./Dba.class.jsp"%><%!
%><%@include file="./Cachea.class.jsp"%><%!

public class WebApp implements WebAppInterface{
	

	private HashMap hm = new HashMap();
	protected HashMap hmf = new HashMap();

	Dba dba = null;
	Cachea cachea = null;

	//- constructor?


	
	public void set(String k, Object v){
		
		this.hmf.put(k, v);
		
	}


	public String get(String k){
	
		return (String)this.hmf.get(k);

	}



}

%>
