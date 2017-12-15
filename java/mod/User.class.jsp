<%
/* User class for user center 
 * v0.1,
 * wadelau@ufqi.com,
 * Sat Jun 18 10:28:02 CST 2016
 */

%><% // @include file="../inc/WebApp.class.jsp" //- relocated into comm/preheader.inc

%><%

%><%!

public class User extends WebApp{
	

	//- constructor ?
	public User(){
	
		dba = new Dba("");
		this.setTbl("gwa2_info_usertbl");


	}

	//-
	//- restore an object from hashmap, refer to WebApp.toHash
	//- wadelau@ufqi.com,  Thu Jul 28 03:46:17 CST 2016
	public User(HashMap fromHm){
		// @todo
		fromHm = fromHm==null ? (new HashMap()) : fromHm;
		Iterator entries = fromHm.entrySet().iterator();
		while (entries.hasNext()) {
			Map.Entry entry = (Map.Entry) entries.next();
			String key = (String)entry.getKey();
			Object value = entry.getValue();
			System.out.println("WebApp/Constructor: restore: key:["+key+"] value:["+value+"]\n");
			this.set(key, value);
		}
		entries = null;
	
		//- dba
		if(this.dba == null){
			this.dba = new Dba(this.get("dbconf"));
		}
		
		//- cachea
		if((boolean)Config.get("enable_cache")){
			this.cachea = new Cachea(this.get("cacheconf"));
		}

	}

	//-
	public String hiUser(){
	
		this.set("pagesize", 10);
		this.set("email", "%lzx%");
		this.set("email.2", "%163%");
		this.set("realname", "%");
		this.set("orderby", "id desc");
		
		HashMap userInfo = this.getBy("id, email, realname, updatetime", "(email like ?  or email like ?) and realname like ?");

		userInfo.put("read-in-User-timestamp", (new Date()) + "userinfo:["+userInfo.toString()+"]");	

		HashMap userInfo2 = this.execBy("desc "+this.getTbl(), null);
		userInfo.put("read-in-User-by-execBy", userInfo2);

		this.setId("136");
		userInfo2 = this.rmBy("id=?");
		userInfo.put("delete-in-User-by-rmBy", userInfo2);

		return (String)this.get("iname") + ", Welcome! "+ userInfo.toString();

	}

	

}

%>
