/**
 #
 # This class, mysql.class, and all of db drivers' classes are working with dba.class, 
 #  which is coordinator between db and objects.
 # Rewrited by Wadelau@ufqi.com, 18:35 21 May 2016
 * Ported into Java by wadelau@ufqi.com on June 28, 2016
 # 
 */

package com.ufqi.gwa2;


public final class Config {

	private static conf = new HashMap();
	
	
	public static void set(String key, Object obj){
		
		this.conf.put(key, obj);
	
	}
	
	
	public static Object get(String key){
	
		return this.conf.get(key);
		
	}
	
	
	public static void setConf(HashMap myConf){
		
		//- @todo
		
	}
	
	
	public static HashMap getConf(){
		
		
		return this.conf;
		
	}
	
	
}

//- where to initialize in a app-global container?
