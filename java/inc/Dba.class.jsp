<%

//import java.util.HashMap;

/* DB Administration, handling all db transations across the site.
 * v0.1
 * wadelau@gmail.com
 * since Wed Jul 13 18:22:06 UTC 2011
 * Thu Sep 11 16:34:20 CST 2014
 * Ported into Java by wadelau@ufqi.com, June 28, 2016s
 */
 

%><%@page import="java.sql.Connection,java.sql.SQLException,java.sql.Statement,java.sql.ResultSetMetaData"%><%
%><%@include file="./MySql.class.jsp"%><%
%><%!

public final class Dba { //- db administrator

	protected DbConn dbConf;
	
	protected DbDriver dbDrv;


	//- constructor	
	public Dba(String hmconf){
	
		hmconf = hmconf==null ? "master" : hmconf;
		this.dbConf = new DbConn(hmconf); 

		String dbDriver = (String)Config.get("dbdriver");
		if(dbDriver.equals("MYSQL")){
			this.dbDrv = new MySql(dbConf);	
		}
		else{
			System.out.println("Dba.class: Unknown dbDriver:["+dbDriver+"]. 1607021745.\n");	
		}

		//System.out.println("Dba.class: dbDriver:["+dbDriver+"] dbc:["+this.dbDrv+"]. 1607021957.\n");	

	}


	//- 
	public HashMap select(String sql, HashMap args){
	
		HashMap hm = new HashMap();
		
		Object[] idxArr = sortObject(sql, args);
		
		HashMap tmpHm = new HashMap();
		boolean hasLimitOne = false;
		if(sql.indexOf("limit 1") > -1 || (args.containsKey("pagesize") && (int)args.get("pagesize") == 1) ){
			hasLimitOne = true;
			tmpHm = this.dbDrv.readSingle(sql, args, idxArr);
		}
		else{
			tmpHm = this.dbDrv.readBatch(sql, args, idxArr);
		}
		
		if((boolean)tmpHm.get("0")){ //- what's for?
			hm.put("0", true);
			try{
				if(hasLimitOne){
					hm.put("1", getInfo((ResultSet)tmpHm.get("1")));	
				}
				else{
					hm.put("1", getRs((ResultSet)tmpHm.get("1")));
				}
			}
			catch(Exception ex){
				ex.printStackTrace();
			}
		}
		else{
			hm.put("0", false);
			hm.put("1", tmpHm.get("1"));
		}
		tmpHm = null; idxArr = null;
		hm.put("read-in-Dba", (new Date()));	

		return hm;
	
	}
	
	
	//- 
	public HashMap update(String sql, HashMap args){
	
		HashMap hm = new HashMap();

		Object[] idxArr = sortObject(sql, args);
		
		HashMap tmpHm = this.dbDrv.query(sql, args, idxArr);
		
		if((boolean)tmpHm.get("0")){
			hm.put("0", true);
			HashMap inHm = new HashMap();
			inHm.put("insertid", tmpHm.get("1"));
			inHm.put("affectedrows", tmpHm.get("1"));
			hm.put("1", inHm);
		}
		else{
			hm.put("0", false);
			hm.put("1", tmpHm.get("1"));
		}

		tmpHm = null; idxArr = null;
		
		hm.put("write-in-Dba", (new Date()));	
		
		return hm;
	
	}
	
	
	//--
	public Object[] sortObject(String sqlstr, HashMap hmvar){
		
		int hmsize=1;
		Object[] obj = new Object[hmsize];
		
		if(hmvar != null){
			int ki=0;
			String k=null;
			hmsize=hmvar.size();
			obj=new Object[hmsize];
			//int whlen=newwh.length();
			sqlstr=" "+sqlstr;
			if(sqlstr.indexOf("insert")>-1 || sqlstr.indexOf("update")>-1){
				sqlstr=sqlstr.replaceAll(",",", ");
			}
			
			int whlen=sqlstr.length();
			Object[] tmpobj=new Object[whlen];
			int tmpindex=-1; HashMap posHm = new HashMap(); 
			int tmpindex2=-1;
			int tmpindex1=-1;
			int tmpki=1;
			int tmpidx=0;
			int selectPos = sqlstr.indexOf("select ");
			int wherePos = sqlstr.indexOf(" where ");
			//Set set=hmvar.keySet();
			Iterator itr=hmvar.keySet().iterator();
			while(itr.hasNext()){
				k=(String)itr.next();
				k = k==null ? "" : k;
				if(k.equals("") || k.equals("orderby") || k.equals("pagesize") 
					|| k.equals("pagenum") || k.equals("groupby")){
					continue;
				}
				else{
					tmpki=1;
					tmpidx=0;
					/* instance: com.ufqi.exp.EXP.java: getRelatedSubject
					 *	Attention: 
					 *		one field matches more than two values, 
					 *		name it as "field.2","field.3", "field.N", etc, as hash key
					 */
					tmpindex1=sqlstr.indexOf("("+k);	
					tmpindex2=sqlstr.indexOf(" "+k);
					while((tmpindex1!=-1 || tmpindex2!=-1)){
						if(tmpindex1==-1){
							tmpindex=tmpindex2;
						}
						else if(tmpindex2==-1){
							tmpindex=tmpindex1;
						}
						else if(tmpindex1!=-1 && tmpindex2!=-1){
							tmpindex = tmpindex1>tmpindex2 ? tmpindex2 : tmpindex1;
						}
						if(tmpindex!=-1){
							boolean hasExist = posHm.get(tmpindex)==null ? false : (boolean)posHm.get(tmpindex);
							if(hasExist){
								//System.out.println("com.ufqi.base.DBACT.java: sortObject-0, k:["
								//	+k+"] tmpindex:["+tmpindex+"] obj:["+tmpobj[tmpindex]+"] tmpki:["
								//	+tmpki+"], existed pos, continue.");	
								tmpindex1=sqlstr.indexOf("("+k, tmpindex1+1);
								tmpindex2=sqlstr.indexOf(" "+k, tmpindex2+1);
								continue;
							}
							if(selectPos > -1 && tmpindex < wherePos){
								//System.out.println("com.ufqi.base.DBACT.java: sortObject-1, k:["
								//	+k+"] tmpindex:["+tmpindex+"] obj:["+tmpobj[tmpindex]+"] tmpki:["+tmpki+"] continue.");	
								posHm.put(tmpindex, true);
								tmpindex1=sqlstr.indexOf("("+k, tmpindex1+1);
								tmpindex2=sqlstr.indexOf(" "+k, tmpindex2+1);
								continue; //- skip in case "select a, b, c where a = ?"; # by wadelau on Sat Nov  3 20:35:46 CST 2012
							}
							if(hmvar.containsKey(k+"."+tmpki)){
								tmpobj[tmpindex]=hmvar.get(k+"."+tmpki);
								/* 
								 *  Attention: 
								 *      one field matches more than two values, 
								 *      name it as "field.2","field.3", "field.N", etc, as hash key
								 *  e.g. in sql: "... where age > ? and age < ? and gender=? ", settings go like:
								 *      $Obj->set('age', 20);
								 *      $obj->set('age.2', 30); # for the second match of 'age'
								 *  Sun Jul 24 21:18:00 UTC 2011
								 *  !! Need space before > or < in this case, Thu Sep 11 16:29:03 CST 2014
								 *  ----- Another Example, 19:48 06 July 2016	
								 *	this.set("pagesize", 10);
									this.set("email", "%hotmail%");
									this.set("email.2", "%163%");
									this.set("realname", "%");
									HashMap userInfo = this.getBy("id, email, updatetime", "(email like ?  or email like ?) and realname like ?");
								 */
							}
							else{
								tmpobj[tmpindex]=hmvar.get(k);
							}
							posHm.put(tmpindex, true);
							//System.out.println("com.ufqi.base.DBACT.java: sortObject-2, k:["
							//		+k+"] tmpindex:["+tmpindex+"] obj:["+tmpobj[tmpindex]+"] tmpki:["+tmpki+"] tidx1:["
							//		+tmpindex1+"] tidx2:["+tmpindex2+"]");	
							tmpki++;
							tmpidx=tmpindex;
							//tmpindex=-1;
							if(tmpindex1>tmpindex){
								tmpindex=tmpindex1;
							}
							else if(tmpindex2>tmpindex){
								tmpindex=tmpindex2;
							}
							if(tmpindex!=tmpidx){
								if(hmvar.containsKey(k+"."+tmpki)){
									tmpobj[tmpindex]=hmvar.get(k+"."+tmpki);
								}
								else{
									tmpobj[tmpindex]=hmvar.get(k);
								}
								posHm.put(tmpindex, true);
								//System.out.println("com.ufqi.base.DBACT.java: sortObject-3, k:["+
								//		k+"] tmpindex:["+tmpindex+"] obj:["+tmpobj[tmpindex]+"] tmpki:["+tmpki+"]  last.");	
								tmpki++;
							}
						}
						tmpindex1=sqlstr.indexOf("("+k, tmpindex1+1); //- tmpindex1 + 1
						tmpindex2=sqlstr.indexOf(" "+k, tmpindex2+1); //- tmpindex2 + 1
					}
				}
			}
			
			tmpindex=0;
			for(ki=0;ki<tmpobj.length;ki++){
				if(tmpobj[ki] != null){
					obj[tmpindex]=tmpobj[ki];
					//System.out.println("Dba.sortObj: ki:["+ki+"] idx:["+tmpindex+"] obj-i:["+obj[tmpindex]
					//		+"] hmvar:["+hmvar.toString()+"]");
					tmpindex++;
				}
				
			}
			//set=null;
			itr=null;
			tmpobj=null;
			
		}
		
		return obj;
	
	}
	
	
	//--- added on 20071124 by wadelau, read single record and save in an hashmap
	/*
	public HashMap getInfo( ResultSet rs ) throws SQLException {
		HashMap hm = null ;
		
		ResultSetMetaData rsmd = rs.getMetaData();
		if( rs.next() ){
			hm = new HashMap();
			int cci = rsmd.getColumnCount() ;
			String fieldname = null  ;
			String fieldvalue = null  ;
			for(int i=1; i<=cci;i++){
				fieldname = rsmd.getColumnName(i) ;
				fieldvalue = rs.getString(i) ; //- fieldname, remedy by wadelau, 13:01 18 July 2016
				fieldname = fieldname.toLowerCase() ;
				hm.put( fieldname,fieldvalue ) ;
			}
		}
		rs.close();
		//System.out.println("WebBean:hm["+hm+"]");
		
		return hm ;
	
	}
	*/

	//--- added on 20071124 by wadelau, read records and save in an hashmap
	//- disabled since 21:49 24 July 2016
	/*
	public HashMap getRs( ResultSet rs ) throws SQLException{
		HashMap hm = new HashMap();
		int count = 0 ;
		
		ResultSetMetaData rsmd = rs.getMetaData() ;
		int icc = rsmd.getColumnCount() ;
		String fieldname = null ;
		String fieldvalue = null ;
		while ( rs.next() ){
			HashMap hmtmp = new HashMap() ;
			for(int i=1; i<=icc; i++ ){
				fieldname = rsmd.getColumnName(i) ;
				
				fieldvalue = rs.getString(i); // rs.getString(fieldname); remedy by wadelau, Sun Jul 17 22:51:13 CST 2016

				fieldname = fieldname.toLowerCase() ;
				hmtmp.put(fieldname, fieldvalue);
			}
			hm.put(""+count,hmtmp);
			count++;
		}
		
		hm.put("count",""+count);
		rs.close();
		
		return hm ;
	
	}
	*/
	
}


//- define for all drivers
public interface DbDriver{
	
	//- @todo in Impls

	//private void _init();

	public HashMap query(String sql, HashMap args, Object[] idxArr);

	public HashMap readSingle(String sql, HashMap args, Object[] idxArr);
	
	public HashMap readBatch(String sql, HashMap args, Object[] idxArr);
	
	public void selectDb(String myDb);
	
	public int getLastInsertedId();
	
	public int getAffectedRows();
	

}
%>
