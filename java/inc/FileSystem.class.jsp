<%

/* File Driver, Linux, implements FileDriver
 * v0.1
 * wadelau@gmail.com, Xenxin@ufqi.com
 * since Wed Jul 13 18:22:06 UTC 2011
 * Ported into Java by wadelau@ufqi.com, Thu Dec 27 08:58:24 UTC 2018
 */

%><%@page import="java.io.*"%><%

%><%!

public final class FileSystem implements FileDriver {


    private final static String Log_Tag = "inc/FileSystem ";

    //- constructor
	public FileSystem(FileConn fileConf){
        //- @todo		
	
	}

    //- destructor
    public void finalize(){
        //- @todo
    }

	//-
	public HashMap read(String myfile, HashMap args){
	
		HashMap hm = new HashMap();
        String contents = "";
        try{
            BufferedReader br = new BufferedReader( new FileReader( myfile) ) ;
            String tmp = br.readLine();
            StringBuffer sbf = new StringBuffer(contents);
            while( tmp != null ){
                sbf.append(tmp);
                sbf.append("\n");
                tmp = br.readLine() ;
            }
            contents = sbf.toString(); br = null ;

			hm.put(0, true);
			hm.put(1, contents);
		
		}
		catch (Exception ex){
			hm.put(0, false);
			hm.put(1, 0);
			ex.printStackTrace();
		}
		finally{
		}
		
		return hm;

	}
	

	//-
	public HashMap write(String myfile, String contents, HashMap args){
	
		HashMap hm = new HashMap();
        HashMap hmtmp = new HashMap();		

        try{
            FileWriter newfw = new FileWriter( myfile) ;
            newfw.write( contents ) ;
            newfw.flush() ;
            newfw.close();
            newfw = null ;
            
            hm.put(0, true);
            hmtmp.put(0, myfile);
            hm.put(1, hmtmp); //- hm[1][0]
		}
		catch (Exception ex){
			hm.put(0, false);
			hmtmp.put(0, "No Record. 1906241109.");
			hm.put(1, hmtmp); //- hm[1][0]
			ex.printStackTrace();
		}
		finally{
		}
		
		return hm;

	}
	
	
	//-
	public boolean open(String myfile){
        //- @todo
        boolean hasOpened = false;

        return hasOpened;
    } 


    //-
    public void close(){
        //- when to make hard close or soft close to pool?
        //- @todo
    }
	
	
}

%>
