<%
/*
 * @abstract: Web and/or HTTP Tools, some utils in common in the sys
 * @author: wadelau@hotmail.com
 * @since: 2009-01-09 09:21
 * @update: Fri Jun 10 10:57:21 CST 2016, revised for -GWA2
 * @ver: 0.2
 */

%><%!

public final static class Wht{

	/*
	 * get,stead of request.getParameter 
	 * @param HTTPRequest, request
	 * @param String, fieldkey
	 * @return String, formated fieldvalue 	
	 */
	public static String get(HttpServletRequest request, String field){
		
		return Wht._enSafe(request.getParameter(field));

	}

	/*
	 * getHeader,stead of request.getHeader 
	 * @param HTTPRequest, request
	 * @param String, fieldkey
	 * @return String, formated fieldvalue 	
	 */
	public static String getHeader(HttpServletRequest request, String field){

		return Wht._enSafe(request.getHeader(field));	

	}

	/*
	 * getURI,stead of request.getRequestURI 
	 * @param HTTPRequest, request
	 * @return String, formated uri	
	 */
	public static String getURI(HttpServletRequest request){

		return request.getRequestURI()==null?"":request.getRequestURI();	

	}

	/*
	 * getQuery,stead of request.getQueryString 
	 * @param HTTPRequest, request
	 * @return String, formated querystring	
	 */
	public static String getQuery(HttpServletRequest request){

		String params = Wht._enSafe(request.getQueryString());
		if(params.contentEquals("")) {}
		else { params = "?" + params; }
		
		return params;

	}

	/*
	 * ensafe user input
	 */
	private static String _enSafe(String s){
	
		s = s==null ? "" : s;
		s = s.replaceAll("<", "&lt;");
		s = s.replaceAll("\"", "&quot;");

		return s;

	}

	/*
	 * parseInt, instead of Integer.parseInt
	 * @param String, numberInString
	 * @return int, int
	 * @failed with a return value -1 
	 */
	public static int parseInt(String numstr){

		if(numstr.equals("")){
			return -1;
		}

		try	{
			return Integer.parseInt(numstr);
		}
		catch(Exception ex){
			ex.printStackTrace();
		}

		return -1;

	}

	/*
	 * inString, find where the string in another string, which separated by ","
	 * @param String haystack, the string list
	 * @reurn boolean true|false, if yes true, then false
	 */
	public static boolean inString(String needle,String haystack){

		boolean matched=false;
		if( haystack==null || haystack.equals("") || needle==null || needle.equals("")){
			return matched; 
		}
		else{
			int ipos = haystack.indexOf(needle);
			if(ipos > -1){
				matched = true;
			}
			//System.out.println("Wht.inString: needle:["+needle+"] hays:["+haystack+"] matched:["+matched+"]");
		}
		return matched;

	}

	/*
	 * inList, find where the needle in haystack, which separated by separator
	 * @param String haystack, the string list
	 * @reurn boolean true|false, if yes true, then false
	 */
	public static boolean inList(String needle,String haystack, String sep){

		boolean matched=false;
		if( haystack==null || haystack.equals("") || needle==null || needle.equals("")){
			return matched; 
		}
		else{
			if(sep == null){
				sep = ""; //- String.indexOf	
			}	
			if(!haystack.startsWith(sep)){
				haystack = sep + haystack;
			}
			if(!haystack.endsWith(sep)){
				haystack += sep;
			}
			if(haystack.indexOf(sep + needle + sep)>-1){
				matched=true;
			}
		}

		return matched;

	}

	/*
	 * startsWith, batchly java.lang.String.startsWith, with haystack split by "|"
	 * @param String needle, which will be used to search with
	 * @param String haystack, which will be used in
	 * @return boolean true|false
	 */
	public static boolean startsWith(String needle,String haystack){

		boolean matched=false;
		if(needle==null || haystack==null || haystack.equals("")){
			return matched;
		}	
		else{
			java.util.regex.Pattern regp=java.util.regex.Pattern.compile("^("+haystack+").*");
			java.util.regex.Matcher regm=regp.matcher(needle);
			if(regm.matches()){
				matched=true;
			}
			regp=null;
			regm=null;
		}

		return matched;

	}

	/*
	 * endsWith, batchly java.lang.String.endsWith, with haystack split by "|"
	 * @param String needle, which will be used to search with
	 * @param String haystack, which will be used in
	 * @return boolean true|false
	 */
	public static boolean endsWith(String needle,String haystack)
	{
		boolean matched=false;
		if(needle==null || haystack==null || haystack.equals("")){
			return matched;
		}	
		else{
			java.util.regex.Pattern regp=java.util.regex.Pattern.compile(".*("+haystack+")$");
			java.util.regex.Matcher regm=regp.matcher(needle);
			if(regm.matches()){
				matched=true;
			}
			regp=null;
			regm=null;
		}

		return matched;

	}

	//
	//-- some special functional methods
	//

	/*
	 * collectUA
	 * @param HttpServletRequest request
	 * @param String profile
	 * @return String mobtype	
	 */
	public static String collectUA(HttpServletRequest request, String profile) {

		//-- collecting user-agenct in very beginning, added on 20090108
		String mobtype = getHeader(request,"User-Agent");
		if (mobtype.equals("") || ( mobtype.startsWith("Java") )){
			mobtype=get(request,"myua");
		}
		String hdua = getHeader(request,"ua");
		if(!hdua.equals("") ){
			mobtype = hdua;
		}

		return mobtype;

	}
	
	/*
	 * collectIP
	 * @param HttpServletRequest request
	 * @return String ip
	 */
	public static String collectIP(HttpServletRequest request){

		String remoteip=request.getRemoteAddr();
		if (remoteip.startsWith("127.0")){
			remoteip=get(request,"myip");
		}
		if(remoteip.equals("") && request.getHeader("X-Forwarded-For")!=null){
			remoteip=request.getHeader("X-Forwarded-For");
		}

		return remoteip;

	}


	/*
	 * checkClientUA
	 * @param String myua, my current user-agent
	 * @param String targetua, expecting user-agent
	 * @param HttpServletRequest request
	 */
	public static boolean checkClientUA(String myua, String targetua, HttpServletRequest request) {
		//--check whether a special ua is some kind of client in very beginning, added on 20090108
		boolean matched=false;

		if(getHeader(request,"User-Agent").equals("")){
			if(!myua.equals("")){
				if(myua.toUpperCase().startsWith(targetua)){
					matched=true;
				}
			}	
		}

		return matched;

	}
	
	//-
	//- check whether a class has been loaded
	public boolean isClass(String className){
	
		try{
			Class.forName(className);
			return true;
		}
		catch (final ClassNotFoundException e){
			return false;
		}
		
}

}

%>