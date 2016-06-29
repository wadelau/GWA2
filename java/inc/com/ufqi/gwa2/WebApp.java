/* WebApp class, as a web application's parent for all subclass 
 * v0.1,
 * wadelau@ufqi.com, 2011-07-12 22:41
 * Sun Jul 17 10:16:03 UTC 2011
 * Mon Jan 23 12:14:15 GMT 2012
 * 08:42 Sunday, June 14, 2015
 * Sat Aug  8 11:22:40 CST 2015
 * ported into Java, Sat Jun 18 10:38:41 CST 2016
 *
 */

package com.ufqi.gwa2;


import java.util.HashMap;


import com.ufqi.gwa2.WebAppInterface;
import com.ufqi.gwa2.Config;
import com.ufqi.gwa2.Dba; //- db admin
import com.ufqi.gwa2.Sessiona; //- session admin
import com.ufqi.gwa2.Cachea; //- cache admin
import com.ufqi.gwa2.Filea;


public class WebApp implements WebAppInterface{
	

	protected HashMap hmf = new HashMap();


	//- constructor?


	
	public void set(String k, Object v){
		
		this.hmf.put(k, v);
		
	}


	public String get(String k){
	
		return (String)this.hmf.get(k);

	}



}

