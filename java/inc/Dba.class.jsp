<%
//import java.util.HashMap;

/* DB Administration, handling all db transations across the site.
 * v0.1
 * wadelau@gmail.com
 * since Wed Jul 13 18:22:06 UTC 2011
 * Thu Sep 11 16:34:20 CST 2014
 * Ported into Java by wadelau@ufqi.com, June 28, 2016s
 */

%><%@page import="java.sql.Connection,java.sql.SQLException,java.sql.Statement,java.sql.ResultSetMetaData,java.util.HashSet"%><%
%><%@include file="./MySql.class.jsp"%><%
%><%!

public final class Dba { //- db administrator

	protected DbConn dbConf;
	
	protected DbDriver dbDrv;
	private final HashSet<String> Sql_Operator_List = new HashSet<String>(
			java.util.Arrays.asList(new String[]{
				" ","^","~",":","!","/",
				"*","&","%","+","=","|",
				">","<","-","(",")",","
				}
			));

	//- constructor	
	public Dba(String xconf){
	
		xconf = xconf==null ? "master" : xconf;
		this.dbConf = new DbConn(xconf); 

		String dbDriver = "";
		if(xconf.equals("")){
			dbDriver = (String)Config.get("dbdriver");
		}
		else{
			dbDriver = (String)Config.get("dbdriver_"+xconf);
		}
		if(dbDriver.equals("MYSQL")){
			this.dbDrv = new MySql(dbConf);	
		}
		else{
			debug("Dba.class: Unknown dbDriver:["+dbDriver+"]. 1607021745.\n");	
		}
		//System.out.println("Dba.class: dbDriver:["+dbDriver+"] dbc:["+this.dbDrv+"]. 1607021957.\n");	

	}


	//- 
	public HashMap select(String sql, HashMap args){
	
		HashMap hm = new HashMap();
		
		Object[] idxArr = sortObject(sql, args);
		
		HashMap tmpHm = new HashMap();
		boolean hasLimitOne = false;
		int pageSize = 0;
        if(args.containsKey("pagesize")){
                String tmpps = String.valueOf(args.get("pagesize"));
                if(tmpps.equals("")){}else{ pageSize = Integer.parseInt(tmpps); }
        }
		if(sql.indexOf("limit 1 ") > -1 || pageSize == 1 ){
			hasLimitOne = true;
			tmpHm = this.dbDrv.readSingle(sql, args, idxArr);
		}
		else{
			tmpHm = this.dbDrv.readBatch(sql, args, idxArr);
		}
		
		if((boolean)tmpHm.get(0)){ //- what's for?
			hm.put(0, true);
			try{
				if(hasLimitOne){
					hm.put(1, tmpHm.get(1));	
				}
				else{
					hm.put(1, tmpHm.get(1));
				}
			}
			catch(Exception ex){
				ex.printStackTrace();
			}
		}
		else{
			hm.put(0, false);
			hm.put(1, tmpHm.get(1));
		}
		tmpHm = null; idxArr = null;
		//hm.put("read-in-Dba", (new Date()));	

		return hm;
	
	}
	
	
	//- 
	public HashMap update(String sql, HashMap args){
	
		HashMap hm = new HashMap();

		Object[] idxArr = sortObject(sql, args);
		
		HashMap tmpHm = this.dbDrv.query(sql, args, idxArr);
		
		if((boolean)tmpHm.get(0)){
			hm.put(0, true);
			HashMap inHm = new HashMap();
			inHm.put("insertedid", tmpHm.get(1));
			inHm.put("affectedrows", tmpHm.get(1));
			hm.put(1, inHm);
		}
		else{
			hm.put(0, false);
			hm.put(1, tmpHm.get(1));
		}

		tmpHm = null; idxArr = null;
		
		hm.put("write-in-Dba", (new Date()));	
		
		return hm;
	
	}
	
	
	//--
	public Object[] sortObject(String sqlstr, HashMap hmvar){
		
		Object[] obj = new Object[1];
		if(hmvar != null){
			int ki=0;
			String k=null;
			int hmsize=hmvar.size();
			obj=new Object[hmsize+1];
			int sqlLen=sqlstr.length();
			Object[] tmpobj=new Object[sqlLen];
			
			int tmpidx=0;
			int selectPos = sqlstr.indexOf("select ");
			int wherePos = sqlstr.indexOf(" where ");
			HashSet sqloplist = this.Sql_Operator_List;
			int keyLen = 0;
			int keyPos = -1;
			String preK = null;
			String aftK = null;
			
			Iterator itr=hmvar.keySet().iterator();
			while(itr.hasNext()){
				k=(String)itr.next();
				k = k==null ? "" : k;
				if(k.equals("")){
					continue; 
				}
				keyLen = k.length();
				keyPos = sqlstr.indexOf(k);
				if(keyPos > -1){
					while(keyPos != -1){
						preK = sqlstr.substring(keyPos-1, keyPos);
						tmpidx = keyPos + keyLen; tmpidx = tmpidx>=sqlLen ? sqlLen-1 : tmpidx;
						aftK = sqlstr.substring(tmpidx, tmpidx+1);
						if(sqloplist.contains(preK) && sqloplist.contains(aftK)){
							if(selectPos > -1){
								if(keyPos > wherePos){
									tmpobj[keyPos] = k;
								}
								else{
									//- select fields
								}
							}
							else{
								tmpobj[keyPos] = k;
							}
						}
						else{
							//System.out.println("Dba.sortObject: found illegal key preset. k:["+k+"] pos:["
							//		+keyPos+"] preK:["+preK+"] aftK:["+aftK+"] sql:["+sqlstr+"]");
						}
						keyPos = sqlstr.indexOf(k,  tmpidx);
					}
				}
				else{
					//System.out.println("Dba.sortObject: no such key:["+k+"] in sql:["+sqlstr+"]");
				}
			}
			
			int tmpi = 0; Object kiso = null; String kis = null;
			HashMap<String, Integer> kSerial = new HashMap<String, Integer>();
			for(int i=0; i<sqlLen; i++){
				k = (String)tmpobj[i];
				if(k != null){
					kiso = kSerial.get(k);
					kis = kiso==null ? "" : kiso.toString();
					if(kis.equals("")){
						obj[tmpi] = k;
						kSerial.put(k, 1);
					}
					else{
						ki = Integer.valueOf(kis);
						obj[tmpi] = k + "." + (ki+1);
						kSerial.put(k, ki+1);
					}
					tmpi++;
					//System.out.println("tmpi:["+tmpi+"] k:["+k+"]");
				}
			}
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