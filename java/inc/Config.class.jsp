<%
/**
 #
 # This class, Config.class, holding all configures across the app, 
 # Rewrited by Wadelau@ufqi.com, 18:35 21 May 2016
 * Ported into Java by wadelau@ufqi.com on June 28, 2016
 # 
 */


//- exec

if(true){

	HashMap hmconf = new HashMap();

	//- db info
	hmconf.put("dbhost", "localhost");
	hmconf.put("dbport", 3306);
	hmconf.put("dbuser", "");

	hmconf.put("dbpassword", "");
	hmconf.put("dbname", "");
	hmconf.put("dbdriver", "MYSQL"); //- MYSQL, SQLSERVER, ORACLE, INFORMIX, SYBASE
	hmconf.put("db_enable_utf8_affirm", false);

	/*
	hmconf.put("dbhost", "192.168.0.241");
	hmconf.put("dbport", 3306);
	hmconf.put("dbuser", "");

	hmconf.put("dbpassword", "");
	hmconf.put("dbname", "");
	hmconf.put("dbdriver", "MYSQL"); //- MYSQL, SQLSERVER, ORACLE, INFORMIX, SYBASE
	hmconf.put("db_enable_utf8_affirm", false);
	*/

	//- cache
	hmconf.put("enable_cache", false);
	hmconf.put("cachehost", "");
	hmconf.put("cacheport", "");
	hmconf.put("cachedriver", "MEMCACHEX"); //- REDISX, XCACHEX
	hmconf.put("cacheexpire", 30*60);

	//- tpl
	hmconf.put("template_display_index", true); //- true for embedded, false for standalone 


	//- init config

	Config.setConf(hmconf);

}

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
