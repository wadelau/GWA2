<%
//- embedded in ./index, work with ./comm/header
//- output and finalize the response

outx.append("\n\toutput in comm/footer: "+(new Date())+" mytpl:["+mytpl+"]\n");


if(fmt.equals("")){

	//- @todo

	if(mytpl.equals("")){
		
		out.println(outx);
		
	}
	else{

        //- template engine
        HanjstTemplate hanjst = new HanjstTemplate();

		//- mytpl
        debug("mytpl:"+mytpl);
		data.put("mytpl", mytpl);
		data.put("rtvdir", rtvdir);
		data.put("url", url);
		data.put("sid", sid);
		data.put("userid", user.getId());

		//- tpl handler
        //- 1) wrap data into JSON
        //- 2) load tpl from files or cache
        //- 3) output JSON and tpl contents
        String viewdir = "view/default";
        String hanjstJsonDataTag = "HANJST_JSON_DATA"; //- same with original tpl
        String tpldir = appdir + "/" + viewdir;
        String tplcont = "";
		
		boolean needDispIndex = (boolean)Config.get("template_display_index");
		Object tmpDispIndex = data.get("template_display_index");
        if(tmpDispIndex !=null && (boolean)tmpDispIndex){
            needDispIndex = true;
        }
		if(needDispIndex){ 
			//- embedded in index.html
            HashMap hmtmp = user.getBy("file:", null, (new HashMap(){{put("file", tpldir+"/index.html");}}));
            if((boolean)hmtmp.get(0)){
                tplcont = (String)hmtmp.get(1);
            }
            String intplcont = "";
            hmtmp = user.getBy("file:", null, (new HashMap(){{put("file", tpldir+"/"+mytpl);}}));
            if((boolean)hmtmp.get(0)){
                intplcont = (String)hmtmp.get(1);
            }
            data.put("embedtpl", intplcont); // same with tpl
		}
		else{
			//- standalone
            HashMap hmtmp = user.getBy("file:", null, (new HashMap(){{put("file", tpldir+"/"+ mytpl);}}));
            if((boolean)hmtmp.get(0)){
                tplcont = (String)hmtmp.get(1);
            }
		}
		tplcont = tplcont==null ? "" : tplcont;

        String jsondata = hanjst.map2Json(data);

        //- replaces
        String[] repTags = new String[]{"images", "css", "js", "pics"};
        for(int ti=0; ti<repTags.length; ti++){
            outx.append("ti:["+ti+"] reptag:["+repTags[ti]+"]");
			tplcont = tplcont.replaceAll("'"+repTags[ti]+"/", "'"+viewdir+"/"+repTags[ti]+"/");
            tplcont = tplcont.replaceAll("\""+repTags[ti]+"/",  "\""+viewdir +"/"+repTags[ti]+"/"); 
        }
        tplcont = tplcont.replace(hanjstJsonDataTag, jsondata);

		//- @todo cache final tpls ?
		out.println("<!--" + outx +" \n -->" + tplcont); 
	
	}
}
else{

	if(fmt.equals("json")){
		data.put("outx", outx);
		//- out put json
		

	}
	else{
		outx.append("<!-- Unknown fmt:["+fmt+"]. 1606261946. -->");
		out.println(outx.toString());
	}

}

%><%@include file="./aftfooter.inc.jsp"%>
