<%
//import java.util.HashMap;

/* DB Driver, MySql, implements DbDriver.
 * v0.1
 * wadelau@gmail.com
 * since Wed Jul 13 18:22:06 UTC 2011
 * Thu Sep 11 16:34:20 CST 2014
 * Ported into Java by wadelau@ufqi.com, June 28, 2016s
 */

//package com.ufqi.gwa2;


//import java.util.HashMap;

//import com.ufqi.gwa2.Conn;
//import com.ufqi.gwa2.MySql;

%><%@page import="javax.sql.DataSource,java.sql.DriverManager,java.sql.ResultSet,java.sql.PreparedStatement"%><%

%><%!

public final class MySql implements DbDriver {


	private String myHost = "";
	private int myPort = 3306;
	private String myUser = "";
	private String myPwd = "";
	private String myDb = "";

	protected Connection dbConn = null;
	

	public MySql(DbConn dbConf){
		
		this.myHost = dbConf.myHost;	
		this.myPort = dbConf.myPort; 
		this.myUser = dbConf.myUser; 
		this.myPwd = dbConf.myPwd; 
		this.myDb = dbConf.myDb; 

		this.dbConn = null; //- init ?
	
	}
	

	//- init connection 
	private void _init(){
	
		try{

			if(this.dbConn == null){
				
				Class.forName("com.mysql.jdbc.Driver"); //- need prior to JDBC 4.0
			    //System.out.println("Driver loaded!");
				this.dbConn = DriverManager.getConnection("jdbc:mysql://" + this.myHost + ":" + this.myPort + "/" + this.myDb + "?" 
						+ "user=" + this.myUser + "&password=" + this.myPwd + "&useSSL=false");
				//this.dbConn = DriverManager.getConnection("jdbc:mysql://"+this.myHost+":"+this.myPort+"/"
				//	+this.myDb, this.myUser, ""+this.myPort);
				
				// - connection pool ?

			}

		}
		catch(Exception ex){
			ex.printStackTrace();	
		}
		finally{
		
			//- release? long connection?  

		}
		
	}
	
	
	//-
	public HashMap query(String sqlstr, HashMap args, Object[] idxArr){
	
		HashMap hm = new HashMap();
		hm.put("readSingle-in-MySql", (new Date()));	

		if(this.dbConn == null){
			this._init();
		}
		
		PreparedStatement pstmt =  null ;
		try{
			
			sqlstr = sqlstr.trim();
			pstmt = this.dbConn.prepareStatement(sqlstr,Statement.RETURN_GENERATED_KEYS);
			ResultSet rs = null ;
			//System.out.println("sqlstr:["+sqlstr+"] pstmt:["+pstmt+"]");
			
			int myj = 1 ;
			for(int myi=0;myi<idxArr.length;myi++){
				//System.out.println("myi:["+myi+"] val:["+String.valueOf(idxArr[myi])+"]");
				//pstmt.setString(myi,String.valueOf(idxArr[myi-1]));
				//pstmt.setObject(myi,idxArr[myi-1]);
				if( idxArr[myi] != null ){
					//pstmt.setObject(myi+1,idxArr[myi]);
					pstmt.setObject(myj,idxArr[myi]);
					myj++;
				}
			}
							
			int affectrows = pstmt.executeUpdate();
			if(affectrows > 0){
				rs = pstmt.getGeneratedKeys();
				if(rs!=null && rs.next()){
					affectrows = rs.getInt(1);
					//System.out.println("rs-1:["+rs.getString(1)+"]");	
					rs.close();
					rs = null ;		
				}
			}
			
			hm.put("0", true);
			hm.put("1", affectrows);
		
		}
		catch (Exception ex){
			hm.put("0", false);
			hm.put("1", 0);
			ex.printStackTrace();
			//System.out.println("err@DBACT.execSQLSafe():"+e);
		}
		finally{
			//free( pstmt ) ; @todo
			//freeConn(); //--- has been moved into the upper method, 20071220
		}
		
		return hm;

	}
	

	//-
	public HashMap readSingle(String sqlstr, HashMap args, Object[] idxArr){
	
		HashMap hm = new HashMap();
		hm.put("readSingle-in-MySql", (new Date()));	

		if(this.dbConn == null){
			this._init();
		}
		
		PreparedStatement pstmt = null ;
		try{
			
			sqlstr = sqlstr.trim();
			if( sqlstr.indexOf(" limit") < 0 ){
				sqlstr += " limit 1 ";
			}

			pstmt = this.dbConn.prepareStatement(sqlstr);
			if( idxArr!=null ){
				int myj = 1 ;
				for( int myi=0;myi<idxArr.length;myi++ ){
					System.out.println("MySql.readSingle: myj:["+myj+"] myi:["+myi+"] idxArr-i:["+idxArr[myi]+"]");
					if( idxArr[myi] != null ){
						//pstmt.setObject(myi+1,idxArr[myi]);
						pstmt.setObject(myj,idxArr[myi]);
						myj++;
					}
					else{
						System.out.println("MySql.readSingle: ???");
					}
				}
			}

			hm.put("0", true);
			hm.put("1", pstmt.executeQuery() );
			
		}
		catch (Exception ex){
			hm.put("0", false);
			ex.printStackTrace();
			//System.out.println("DBACT.getExistSafe():"+e+" sql:["+sqlstr+"]");
		}
		finally{
			//free(pstmt); // @todo
		}
		
		return hm;

	}
	
	
	//-
	public HashMap readBatch(String sqlstr, HashMap args, Object[] idxArr){
	
		HashMap hm = new HashMap();
		hm.put("readSingle-in-MySql", (new Date()));	

		if(this.dbConn == null){
			this._init();
		}
		
		PreparedStatement pstmt =  null ; 
		try{

			pstmt = this.dbConn.prepareStatement(sqlstr);
			if( idxArr!=null ){
				int myj = 1 ;
				for(int myi=0;myi<idxArr.length;myi++){
					if( idxArr[myi] != null ){
						//System.out.println("MySql.readBatch: myj:["+myj+"] myi:["+myi+"] idxArr-i:["+idxArr[myi]+"]");
						//pstmt.setObject(myi+1,idxArr[myi]);
						pstmt.setObject(myj,idxArr[myi]);
						myj++ ;
					}
				}
			}

			hm.put("0", true);
			hm.put("1", pstmt.executeQuery() );
		
		}
		catch (Exception e){
			hm.put("0", false);
			e.printStackTrace();
			System.out.println(e);
		}
		finally{
			//free(pstmt); // @todo
		}
		
		return hm;

	}
	
	
	//-
	public void selectDb(String myDb){
		
		this.myDb = myDb;
		this.query("use " + this.myDb, (new HashMap()), (new Object[]{}));
		
	}
	
	
	//-
	public int getLastInsertedId(){
		
		return 0;
		
	}
	
	
	//- 
	public int getAffectedRows(){
		
		return 0;
		
	}
	
	
}

%>