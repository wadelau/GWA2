<%

%><%@include file="./WebApp.interface.jsp"%><%
%><%@include file="./Config.class.jsp"%><%!
%><%@include file="./Conn.class.jsp"%><%!
%><%@include file="./Dba.class.jsp"%><%!
%><%@include file="./Cachea.class.jsp"%><%!

public class WebApp implements WebAppInterface{
	
	private HashMap hm = new HashMap(); //- runtime container, local, regional
	public HashMap hmf = new HashMap(); //- persistent storage, global
	private String myId = "id";
	private String myIdName = "myId";

	Dba dba = null;
	Cachea cachea = null;

	//- constructor
	public WebApp(String cfg){
		//- cfg in json? or "a=b; c=d; e=f"
		//- db
		if(this.dba == null){
			String dbconf = "";
			if(cfg != null && cfg.indexOf("dbconf") > -1){
				dbconf = ""; // @todo
				this.set("dbconf", dbconf);
			}
			this.dba = new Dba(dbconf);
		}
		
		//- cache
		if((boolean)Config.get("enable_cache")){
			if(this.cachea == null){
				String cacheconf = "";
				//@todo cfg.cacheconf
				this.set("cacheconf", cacheconf);
				this.cachea = new Cachea(cacheconf);
			}
		}
		
	}
	
	
	//-
	public WebApp(){
		// @todo
		//- dba
		if(this.dba == null){
			this.dba = new Dba("");
		}
		
		//- cachea
		if((boolean)Config.get("enable_cache")){
			this.cachea = new Cachea("");
		}

	}
	
	//-
	public void set(String k, Object v){
		
		this.hmf.put(k, v);
		
	}

	//-
	public String get(String k){
	
		String tmp = (String)this.hmf.get(k);
		return tmp==null ? "" : tmp;

	}
	
	//-
	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array); in GWA2 PHP
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 * update by extending to readObject by wadelau, Sat May  7 11:06:37 CST 2016
	 */
	public HashMap getBy(String fields, String args){
	
		HashMap hm = new HashMap();

		StringBuffer sqls = new StringBuffer();
		boolean hasLimitOne = false;
		int pageNum = 1; //- default pagenum set to "1", unless pre set in hmvar, 20080903
		int pageSize = 0; //- default pagesize set to "0", unless pre set in hmvar, "0" means all, no limit, 20080903
		if(this.hmf.containsKey("pagenum")){
			pageNum = (int)this.hmf.get("pagenum");
		}
		if(this.hmf.containsKey("pagesize")){
			pageSize = (int)this.hmf.get("pagesize");
		}
		
		sqls.append("select ").append(fields).append(" from ").append(this.getTbl()).append(" where ");
		if(args == null || args.equals("")){
			if(this.getId().contentEquals("")){
				sqls.append(" 1=1 ");
			}
			else{
				sqls.append(this.myId).append("=?");
				hasLimitOne = true;
			}
		}
		else{
			sqls.append(args);
		}
		
		if(this.hmf.containsKey("groupby")){
			sqls.append(" group by ").append(this.hmf.get("groupby"));
		}
		if(this.hmf.containsKey("orderby")){
			sqls.append(" order by ").append(this.hmf.get("orderby"));
		}
		if(hasLimitOne){
			sqls.append(" limit 1");
		}
		else{
			if(pageSize == 0){
				pageSize = 99999;
			}
			sqls.append(" limit ").append((pageNum-1)*pageSize).append(", ").append(pageSize);
		}
		
		hm = this.dba.select(sqls.toString(), this.hmf);	
		
		hm.put("read-in-WebApp", (new Date()) + " sql:["+sqls.toString()+"]");	

		System.out.println("WebApp.getBy: sql:["+sqls.toString()+"]");
		
		sqls = null; fields = null; args = null;
		
		return hm;

	}


	//-
	/* 
	 * mandatory return $hm = (0 => true|false, 1 => string|array); in GWA2 PHP
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 * update by extending to writeObject by wadelau, Sat May  7 11:06:37 CST 2016
	 */
	public HashMap setBy(String fields, String args){
	
		HashMap hm = new HashMap();
		
		StringBuffer sqls = new StringBuffer();
		boolean isUpdate = false;
		if(this.getId().equals("") && (args == null || args.equals(""))){
			sqls.append("insert into ").append(this.getTbl()).append(" set ");
		}
		else{
			sqls.append("update ").append(this.getTbl()).append(" set ");
			isUpdate = true;
		}
		String[] fieldArr = fields.split(",");
		for(String f: fieldArr){
			//String f = fieldArr[i];
			f = f==null ? "" : f.trim();
			if(Wht.inString(f, "updatetime,inserttime,createtime")){
				sqls.append(f).append("=NOW(), ");
				this.hmf.remove(f);
			}
			else{
				sqls.append(f).append("=?, ");
			}
		}
		
		int sqlsLen = sqls.length();
		sqls.delete(sqlsLen-2, sqlsLen); //- drop ", "
		
		boolean isSqlReady = true;
		if(args == null || args.equals("")){
			if(this.getId().equals("")){
				if(isUpdate){
					System.out.println("WebApp.setBy: unconditonal update is forbidden. 1607072133.");
					hm.put("0", false);
					hm.put("1", (new HashMap()).put("error", "unconditonal update is forbidden. 1607072133."));
					isSqlReady = false;
				}
			}
			else{
				sqls.append(" where ").append(this.myId).append("=?");
			}
		}
		else{
			sqls.append(" where ").append(args);
		}
		
		if(isSqlReady){
			if(!this.getId().equals("")){
				this.hmf.put("pagesize", 1);
			}
			
			hm = this.dba.update(sqls.toString(), this.hmf);
			
			hm.put("isupdate", isUpdate);
		
		}
		
		hm.put("write-in-WebApp", (new Date()) + " sql:["+sqls.toString()+"]");	

		System.out.println("WebApp.setBy: sql:["+sqls.toString()+"]");
		
		sqls = null; args = null; fields = null;
		
		return hm;

	}


	//- initial added on Mon Jan 23 12:20:24 GMT 2012 by wadelau@ufqi.com
	//- reported from GWA2PHP by wadelau, Sun Jul 17 22:13:39 CST 2016
	public HashMap execBy(String sql, String args){
	
		HashMap hm = new HashMap();

		args = args==null ? "" : args;
		String sqlx = null;
		int pos = -1;
		if(sql == null){
			hm.put("0", false);
			hm.put("1", (new HashMap()).put("error", "sql:["+sql+"] is null. 1607172158.")); 
		}
		else{
			sqlx = sql.trim().toUpperCase();
			pos = sqlx.indexOf("SELECT ");
			if(pos == 0){
				//- normal	
			}
			else{
				pos = sqlx.indexOf("DESC ");
				if(pos == 0){
					//-normal
				}
				else{
					pos = sqlx.indexOf("SHOW ");	
				}
			}
		}
		
		if(!args.equals("")){
			if(sqlx.indexOf(" WHERE") > -1){
				sql += args;	
			}
			else{
				sql += " where " + args;	
			}
		}

		if(pos == 0){
			//- read mode
			hm = this.dba.select(sql, this.hmf);	
		}
		else{
			//- write mode
			hm = this.dba.update(sql, this.hmf);
		}
		System.out.println("WebApp.execBy: sql:["+sql+"]");

		sql = null; sqlx = null; args = null;

		return hm;

	} 


	/*
	 * mandatory return $hm = (0 => true|false, 1 => string|array);
	 * Thu Jul 21 11:31:47 UTC 2011, wadelau@gmail.com
	 * reported by wadelau@ufqi.com, Sun Jul 17 22:15:17 CST 2016
	 */
	public HashMap rmBy(String args){
		
		HashMap hm = new HashMap();
		args = args==null ? "" : args;

		boolean isSqlReady = false;
		StringBuffer sqlb = new StringBuffer("delete from ");
		sqlb.append(this.getTbl()).append(" where ");

		if(!args.equals("")){
			if(this.getId().equals("")){
				hm.put(0, false);
				hm.put(1, (new HashMap()).put("error", "unconditional deletion is strictly forbidden. stop it. sql:["+
					sqlb.toString()+"] conditions:["+ args + "]"));
			}
			else{
				sqlb.append(this.myId).append("=?");
				isSqlReady = true;
				
			}
		}
		else{
			sqlb.append(args);
			isSqlReady = true;
		}
		
		if(isSqlReady){
			System.out.println("WebApp.rmBy: sql:["+sqlb.toString()+"]");
			hm = this.dba.update(sqlb.toString(), this.hmf);	
			if(!this.getId().equals("")){
				this.setId("");		
			}
		}

		sqlb = null; args = null;

		return hm;

	}

	
	//-
	public String getTbl(){
		
		return this.get("tbl");
		
	}
	
	//-
	public void setTbl(String tbl){
		
		this.set("tbl", tbl);
		if(this.dba == null){
			this.dba = new Dba("");
		}
		
	}

	
	//-
	public String getId(){

		String xId = this.get(this.myId);
		if(!xId.equals("")){
			return xId;
		}
		else{
			String xIdName = this.get(this.myIdName);
			if(!xIdName.equals("")){
				xId = this.get(xIdName);
				this.setMyId(xIdName);
				return xId;
			}
			else{
				return "";
			}
		}

	}
	
	//-
	public void setId(String id){
		
		this.set(this.myId, id);
		
	}
	
	//-
	public void setMyId(String myId){
		
		this.myId = myId;
		this.set(this.myIdName, myId);
		
	}

	//-
	//- export properties to hashmap
	//- for cross-page object, refer to mod/User fromHm
	//- wadelau@ufqi.com, Tue Jul 26 22:56:54 CST 2016
	public HashMap toHash(){
	
		return this.hmf;

	}

	
}

%>
