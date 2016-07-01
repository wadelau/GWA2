<%
/* DB and others Connection confisg, for all settings.
 * conn config, connecting, connection pool, long/short connections
 * v0.1
 * wadelau@ufqi.com
 * since Wed Jul 13 18:20:28 UTC 2011
 * Ported into Java by wadelau@ufqi.com, June 28, 2016
 */


//package com.ufqi.gwa2;


//import java.util.HashMap;

//import com.ufqi.gwa2.Config;

%><%!

public final static class Conn {

	
	class DbConnMaster{
		
		//- @todo
		String myHost = "";
		int myPort = 0;
		String myUser = "";
		String myPwd = "";
		String myDb = "";
		
		public DbConnMaster(){
			
			this.myHost = (String)Config.get("dbhost");
			this.myPort = Integer.valueOf((String)Config.get("dbport"));
			this.myUser = (String)Config.get("dbuser");
			this.myPwd = (String)Config.get("dbpassword");
			this.myDb = (String)Config.get("dbname");
			
		}
		
	}
	
	
	static class DbConnSlave{
		
		//- @todo
		
	}
	
	
	static class CacheConnMaster{
		
		//- @todo
		
	}
	
	
}

%>