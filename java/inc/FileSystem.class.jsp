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
	// upload settings
    private final static String UPLOAD_DIRECTORY = "./upld";
    private final static int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    private final static int MAX_FILE_SIZE      = 1024 * 1024 * 4; // 4MB
    private final static int MAX_REQUEST_SIZE   = 1024 * 1024 * 40; // 40MB
    
	//- constructor default
	public FileSystem(){
		this((new FileConn("")));
	}
	
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
	
	/** rm, delete file
     *  @param String relativePath
     */
    public HashMap rm(String filePath){
    	boolean isSucc = false;
		String path = ""; String error = "";
		if(filePath != null && !filePath.equals("")){
			path = getServletContext().getRealPath("") 
				+ File.separator + filePath.replace("/", File.separator);
			debug(Log_Tag+"rm: path:"+path);
			File f = new File(path);
			if(f.exists() && f.isFile()){
				f.delete();
				isSucc = true;
			}
			else{
				error = "Not exists or not file. 202009020947.";
			}
		}
		else{
			debug(Log_Tag+"rm: empty path:"+path);
			error = "Empty filename. 202009020958.";
		}
		HashMap hmResult = new HashMap();
		hmResult.put(0, isSucc);
		hmResult.put(1, error);
		return hmResult;
    }
	
	//- upload via http(s)
    /** upload files, multiple files in a single form
     * @param HttpServletRequest request
     * @param String relativePath, like "upload/"
	 * @return HashMap with k/v as fieldName/fileName 
	 * @author wadelau@ufqi, 11:02 2021-10-21
     */
    public HashMap uploadMultiple(HttpServletRequest request, List preFormItems, String relativePath){
    	HashMap htrn = new HashMap();
    	htrn.put(0, false);
    	if (!ServletFileUpload.isMultipartContent(request)) {
            htrn.put(1, "Error: Form must has enctype=multipart/form-data. 202008241226.");
            return htrn;
        }
    	// configures upload settings
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // sets memory threshold - beyond which files are stored in disk
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        // sets temporary location to store files
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
    	//-
        ServletFileUpload upload = new ServletFileUpload(factory);
        // sets maximum size of upload file
        upload.setFileSizeMax(MAX_FILE_SIZE);
        // sets maximum size of request (include file + form data)
        upload.setSizeMax(MAX_REQUEST_SIZE);
        // constructs the directory path to store upload file
        // this path is relative to application's root directory
        String uploadPath = getServletContext().getRealPath("") 
			+ File.separator + UPLOAD_DIRECTORY
			+ File.separator + relativePath.replace("/", File.separator);
        // creates the directory if it does not exist
        debug(Log_Tag+": upload: path:"+uploadPath);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) { uploadDir.mkdirs(); }
		HashMap hmResult = new HashMap();
        try {
            // parses the request's content to extract file data
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = preFormItems; 
			if(formItems == null || formItems.size() ==0){
				formItems = upload.parseRequest(request);
			}
            if (formItems != null && formItems.size() > 0){
                // iterates over form's fields
				String fieldName, itemName, fileName, suffix, filePath;
				File storeFile = null;
				String showPath = UPLOAD_DIRECTORY + File.separator + relativePath;
				if(!relativePath.endsWith(File.separator)){ showPath += File.separator; }
                for (FileItem item : formItems){
                    // processes only fields that are not common form fields
                    if (!item.isFormField()){
						fileName = "";
                        fieldName = item.getFieldName(); itemName = item.getName();
						if(itemName != null && !itemName.equals("")){
							suffix = "";
							if(itemName.lastIndexOf(".")>0){
								suffix = itemName.substring(itemName.lastIndexOf("."), itemName.length());
							}
							fileName = UUID.randomUUID().toString().replaceAll("-","") + suffix;
							filePath = uploadPath + File.separator + fileName;
							debug(Log_Tag+" upload: filePath:"+filePath+" itemName:"+itemName);
							// saves the file on disk
							storeFile = new File(filePath);
							item.write(storeFile);
							fileName = showPath + fileName;
						}
						else{
							fileName = "";
							debug(Log_Tag+"upload: skip empty itemName."+itemName);
						}
						hmResult.put(fieldName, fileName);
                    }
					else{
						//debug(Log_Tag+" upload: form field item:"+item);
					}
                }
            }
			else{
				debug(Log_Tag+" upload: formItems:"+formItems);
			}
        }
        catch (Exception ex) {
            htrn.put(1, "There was an error: " + ex.getMessage()+". 202008241237.");
            return htrn;
        }
        htrn.put(0, true);
        htrn.put(1, hmResult);
        return htrn;
    }
	
	/**
     * @param String relativePath
     * if file exist return true, else return false
     */
    public boolean exists(String relativePath){
    	String path = getServletContext().getRealPath("") + File.separator + relativePath.replace("/", File.separator);
    	File f = new File(path);
    	return f.exists();
    }
}

%>