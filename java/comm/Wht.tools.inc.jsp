<%@page import="java.text.SimpleDateFormat,
java.text.DateFormat,
java.util.Date,
java.util.Calendar"%><%
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
		String tmps = request.getParameter(field);
        if(tmps == null || tmps.equals("")){
			//- float?
			Object obj = request.getAttribute(field);
			if(obj != null 
				&& (obj instanceof Integer || obj instanceof Double 
					|| obj instanceof Float || obj instanceof Long)){
				tmps = String.valueOf(obj);
			}
			else{
				tmps = (String)obj;
			}
        }
        return Wht._enSafe(tmps);
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
	 * getQuery,stead of request.getQueryString , get|post, updt 15:50 2021-03-16
	 * @param HTTPRequest, request
	 * @return String, formated querystring	
	 */
	public static String getQuery(HttpServletRequest request){
		String params = "";
		String sMethod = request.getMethod().toUpperCase();
		if(!sMethod.equals("POST")){
			params = Wht._enSafe(request.getQueryString());
			if(params.contentEquals("")){}
			else { params = "?" + params; }
		}
		else{
			Map hmParams = request.getParameterMap();
			Iterator entries = hmParams.entrySet().iterator();
			String key; String val;
			while (entries.hasNext()) {
				Map.Entry entry = (Map.Entry)entries.next();
				key = (String)entry.getKey();
				val = Wht.get(request, key);
				params += key+"="+val+"&";
			}
			if(!params.equals("")){
				params = "?"+params.substring(0, params.length()-1);
			}
			entries = null; hmParams = null;
		}
		return params;
	}
	//- get array inputs from http request, 15:57 2021-10-17
	//- e.g. check-box, multiple-select
	public static String[] getArray(HttpServletRequest request, String field){
		String[] tmpArr = request.getParameterValues(field);
        if(tmpArr == null || tmpArr.length == 0){
			Object obj = request.getAttribute(field);
			if(obj != null 
				&& (obj instanceof String[])){
				tmpArr = (String[])obj;
			}
			else{
				tmpArr = new String[1]; tmpArr[0] = (String)obj;
			}
        }
		/*
		for(String f : tmpArr){
			debug("comm/Wht: getArray: "+field+" f:"+f+"");
		}
		*/
        return tmpArr;
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
		numstr = numstr== null ? "" : numstr;
		numstr = numstr.equals("null") ? "" : numstr;
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
	
	//-
    public static int parseInt(Object obj){
        if(obj instanceof Double){
			Double myD = (Double)obj;
			return myD.intValue();
		}
		else if(obj instanceof Float){
			Float myF = (Float)obj;
			return myF.intValue();
		}
		else{
			return Wht.parseInt(String.valueOf(obj));
		}
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
	//-
	public static boolean inList(String needle, String haystack){
		return Wht.inList(needle, haystack, ",");
	}

	/*
	 * startsWith, batchly java.lang.String.startsWith, with needle split by "|"
	 * @param String needle, which will be used to search with
	 * @param String haystack, which will be used in
	 * @return boolean true|false
	 */
	public static boolean startsWith(String haystack, String needle){
		boolean matched=false;
		if(needle==null || haystack==null || haystack.equals("")){
			return matched;
		}	
		else{
			if(needle.indexOf("|") > 0){
				java.util.regex.Pattern regp=java.util.regex.Pattern.compile("^("+needle+").*");
				java.util.regex.Matcher regm=regp.matcher(haystack);
				if(regm.matches()){
					matched=true;
				}
				regp=null;
				regm=null;
			}
			else{
				if(haystack.indexOf(needle) == 0){
					matched = true;
				}
			}
		}
		//debug("comm/Wht startsWith: haystack:"+haystack+" needle:"+needle+" matched:"+matched);
		return matched;
	}

	/*
	 * endsWith, batchly java.lang.String.endsWith, with needle split by "|"
	 * @param String needle, which will be used to search with
	 * @param String haystack, which will be used in
	 * @return boolean true|false
	 */
	public static boolean endsWith(String haystack, String needle){
		boolean matched=false;
		if(needle==null || haystack==null || haystack.equals("")){
			return matched;
		}	
		else{
			if(needle.indexOf("|") > 0){
				java.util.regex.Pattern regp=java.util.regex.Pattern.compile(".*("+needle+")$");
				java.util.regex.Matcher regm=regp.matcher(haystack);
				if(regm.matches()){
					matched=true;
				}
				regp=null;
				regm=null;
			}
			else{
				if(haystack.lastIndexOf(needle) == haystack.length()-needle.length()){
					matched = true;
				}
			}
		}
		//debug("comm/Wht endsWith: haystack:"+haystack+" needle:"+needle+" matched:"+matched);
		return matched;
	}
	
	//- judge string content is empty or not
	public static boolean isEmpty(String str){
		return str==null || str.length()==0;
	}
	/*
	 * returns true when the contents of the two strings are not empty and the content is equal
	 * @param String str1
	 * @param String str2
	 * @return boolean true|false
	 */
	public static boolean contentEqual(String str1, String str2){
		if(isEmpty(str1)||isEmpty(str2)){
			return false;
		}
		return str1.equals(str2);
	}
	//-
	public static boolean equals(String s1, String s2){
		return Wht.contentEqual(s1, s2);
	}
	
	//
	//-- some special functional methods
	//

	/*
	 * collectUA
	 * @param HttpServletRequest request
	 * @return String mobtype	
	 */
	public static String collectUA(HttpServletRequest request) {
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
		if(remoteip.equals("")){
			if(request.getHeader("X-Forwarded-For")!=null){
				remoteip=request.getHeader("X-Forwarded-For");
			}
			else{
				remoteip = "0.0.0.0";
			}
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
		if(myua==null || myua.equals("")){
			myua = getHeader(request,"User-Agent");
		}
		if(!myua.equals("")){
			targetua = targetua.toUpperCase();
			if(myua.toUpperCase().indexOf(targetua) > -1){
				matched=true;
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
	
	//- get date in diff days
	public static Date getDay(int adjustDay){
		return getDateDiff(adjustDay*86400);
	}
	//- get date by diff in second
	//- Xenxin, 09:11 Saturday, April 18, 2020
	public static Date getDateDiff(int mySecond){
		Calendar ca = Calendar.getInstance();
		Date now = new Date();
		ca.setTime(now);
		ca.add(Calendar.SECOND, mySecond);
		Date target = ca.getTime();
		now = null; ca = null;
		return target;
	}
	//- get date from string
	public static Date getDate(String dateStr){
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
		Date date = null;
		try{ 
			if(dateStr.length() == 10){
				date = Wht.getDateShort(dateStr);
			}
			else{
				date = formatter.parse(dateStr);
			}
		}
		catch(Exception expt){ expt.printStackTrace(); }
		return date;
	}
	//- get date from string, short
	public static Date getDateShort(String dateStr){
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
		Date date = null;
		try{
			int strLen = dateStr.length();
			if(strLen > 10){
				date = Wht.getDate(dateStr);
			}
			else{
				if(strLen == 8){ 
					dateStr = dateStr.substring(0,4)+"-"+dateStr.substring(4,6)+"-"+dateStr.substring(6,8); 
				}
				date = formatter.parse(dateStr);
			}
		}
		catch(Exception expt){ expt.printStackTrace(); }
		return date;
	}
	
	//- date format
	public static String dateFormat(Date d){
		if(d==null){ d = new Date(); }
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(d);
	}
	//- date format in short, 16:30 2021-03-23
	public static String dateFormatShort(Date d){
		if(d==null){ d = new Date(); }
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		return sdf.format(d);
	}
	
	//- get a string from an object, e.g. HashMap
	public static String getString(Object obj, String myk){
		String s = "";
		if(obj instanceof HashMap){
			HashMap hmobj = (HashMap)obj;
			s = String.valueOf(hmobj.get(myk));
            s = s==null ? "" : s;
            s = s.equals("null") ? "" : s;
		}
		return s;
	}
	//- get a booean from an object, e.g. HashMap
	//- becareful! getBoolean(hm, "0") != getBoolean(hm, 0)
	public static boolean getBoolean(Object obj, String myk){
		boolean tf = false;
		if(obj instanceof HashMap){
			HashMap hmobj = (HashMap)obj;
			Object tmpobj = (Object)hmobj.get(myk);
            if(tmpobj != null){
                tf = (boolean)tmpobj;
            }
		}
		return tf;
	}
	//- get a booean from an object, e.g. HashMap
	//- becareful! getBoolean(hm, "0") != getBoolean(hm, 0)
	public static boolean getBoolean(Object obj, int myk){
		boolean tf = false;
		tf = Wht.getBoolean(obj, ""+myk);
		return tf;
	}
    //- init a hashMap with pairs
    public static HashMap initHashMap(String keys, String values){
        HashMap hmRtn = new HashMap();
        if(keys.indexOf(",") > -1){
            String[] keyArr = keys.split(",");
            String[] valueArr = values.split(","); int ki = 0;
            for(String k : keyArr){
                hmRtn.put(k, valueArr[ki]); ki++;
            }
        }
        else{
            hmRtn.put(keys, values);
        }
        return hmRtn;
    }

    //- rm x chars from end 
    public static String rmEnd(String s, int ilen){
        return s = s.substring(0, s.length()-ilen);
    }
	
	//- set an element into a 2-d map
	public static HashMap set2DMap(ConcurrentHashMap firstMap, String secMapKey, 
			String key, Object val){
		boolean hasDone = false;
		if(firstMap!=null){
			HashMap secMap = (HashMap)firstMap.get(secMapKey);
			if(secMap==null){ secMap = new HashMap(); }
			if(key==null || key.equals("")){
				int secMapSize = secMap.size();
				key = "" + secMapSize;
			}
			secMap.put(key, val);
			firstMap.put(secMapKey, secMap);
			hasDone = true;
		}
		return firstMap;
	}
	
	//- rdmInt
    public static int rdmInt(){
        return Wht.rdmInt(10000);
    }
	//- rdmInt with seed
    public static int rdmInt(int mySeed){
        return ((new java.util.Random()).nextInt((mySeed)));
    }
}
%>