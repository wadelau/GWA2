<%
/**
 #
 # This class, mysql.class, and all of db drivers' classes are working with dba.class, 
 #  which is coordinator between db and objects.
 # Rewrited by Wadelau@ufqi.com, 18:35 21 May 2016
 * Ported into Java by wadelau@ufqi.com on June 28, 2016
 # 
 */

//package com.ufqi.gwa2;

//- exec

HashMap hmconf = new HashMap();

//- db info
hmconf.put("dbhost", "192.168.0.241");
hmconf.put("dbport", 3306);
hmconf.put("dbuser", "gwa2dbuser");

hmconf.put("dbpassword", "gwa2dbpwd");
hmconf.put("dbname", "gwa2");
hmconf.put("dbdriver", "mysql");
hmconf.put("db_enable_utf8_affirm", false);


//- init config

Config.setConf(hmconf);

%><%!

//- define

public final static class Config {

	private static HashMap conf = new HashMap();
	
	
	public static void set(String key, Object obj){
		
		Config.conf.put(key, obj);
	
	}
	
	
	public static Object get(String key){
	
		return Config.conf.get(key);
		
	}
	
	
	public static void setConf(HashMap myConf){
		
		//- @todo
		Iterator entries = myConf.entrySet().iterator();
		while (entries.hasNext()) {
			Map.Entry entry = (Map.Entry) entries.next();
			String key = (String)entry.getKey();
			Object value = entry.getValue();
			Config.set(key, value);
		}
		
	}
	
	
	public static HashMap getConf(){
		
		
		return Config.conf;
		
	}
	
	
}

//- where to initialize in a app-global container?

%>