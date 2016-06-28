/*
 *
 * WebApp Interface definition for all of the implement classes
 * v0.1,
 * wadelau@ufqi.com, 2011-07-10 15:27
 * remedy by wadelau@ufqi.com, 10:12 01 May 2016
 * ported into Java, Sat Jun 18 10:37:19 CST 2016
 *
 */


package com.ufqi.gwa2;


import java.util.HashMap;


public interface WebAppInterface{
	
	public void set(String key, Object value);
	public String get(String key);
	
	public void setTbl(String tbl);
	public String getTbl();
	
	public void setId(String iId);
	public String getId();
	
	public HashMap setBy(String fields, HashMap conditions);
	public HashMap getBy(String fields, HashMap conditions);

	public HashMap execBy(String fields, HashMap conditions);
	public void rmBy(HashMap conditions);
	
	public String toString(Object obj);
	

}

