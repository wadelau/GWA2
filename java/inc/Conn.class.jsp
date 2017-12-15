<%
/* Connections configures, for all settings.
 * conn config, connecting, connection pool, long/short connections
 * v0.1
 * wadelau@ufqi.com
 * since Wed Jul 13 18:20:28 UTC 2011
 * Ported into Java by wadelau@ufqi.com, June 28, 2016
 */


%><%!
//-
public class DbConn{
	
	//- connection poll?
	String myHost = "";
	int myPort = 0;
	String myUser = "";
	String myPwd = "";
	String myDb = "";
	String myDriver = "MYSQL";
	
	public DbConn(String dbServer){
		
		if(dbServer == null || dbServer.equals("")){
			dbServer = "master";	
		}

		if(dbServer.equals("master")){
			//- master
			this.myHost = (String)Config.get("dbhost"); //- inc/Config.class
			this.myPort = (Integer)Config.get("dbport");
			this.myUser = (String)Config.get("dbuser");
			this.myPwd = (String)Config.get("dbpassword");
			this.myDb = (String)Config.get("dbname");
			this.myDriver = (String)Config.get("dbdriver");
		}
		else if(dbServer.equals("slave")){
			//- slave	

		}
		else{
			System.out.println("Unknown dbServer:["+dbServer+"]. 1607021811.");	
		}
		
	}
	
}

//-
public static class CacheConn{
	
	//- @todo, socket pool, config, connection
	
}

//-
public static class SessionConn{
	
	//- @todo, socket pool
	
}


%>
