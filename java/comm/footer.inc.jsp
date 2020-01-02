<%
//- embedded in ./index, work with ./comm/header
//- output and finalize the response

if(fmt.equals("")){
	if(mytpl.equals("")){
		out.println(outx);
	}
	else{
        //- Hanjst template engine
        if(hanjst == null){ hanjst = new HanjstTemplate(); }
		//- mytpl
        //debug("mytpl:"+mytpl);
		data.put("mytpl", mytpl);
		data.put("url", url);
		String resrcPathPrefix = (String)Config.get("resrc_path_prefix");
		data.put("resrcPathPrefix", resrcPathPrefix);
		data.put("sid", sid);
		data.put("userid", user.getId());

		//- tpl handler
        //- 1) wrap data into JSON; 2) load tpl from files or cache; 3) output JSON or tpl contents
        String viewdir = (String)data.get("viewdir"); // "view/default";
        String hanjstJsonDataTag = "HANJST_JSON_DATA"; //- same with original tpl
        String tpldir = (String)data.get("tpldir"); //appdir + "/" + viewdir;
        String tplcont = "";
		
		boolean needDispIndex = (boolean)Config.get("template_display_index");
		Object tmpDispIndex = data.get("template_display_index");
        if(tmpDispIndex != null){
            if((boolean)tmpDispIndex){
                needDispIndex = true;
            }
            else{
                needDispIndex = false;
            }
        }
		if(needDispIndex){ 
			//- embedded in index.html
            tplcont = hanjst.readTemplate("index.html", tpldir, viewdir);
            String intplcont = hanjst.readTemplate(mytpl, tpldir, viewdir);
            data.put("embedtpl", intplcont); // same with tpl
		}
		else{
			//- standalone, possible with innertpl -> embedtpl
            tplcont = hanjst.readTemplate(mytpl, tpldir, viewdir);
            String innertpl = (String)data.get("innertpl");
            if(innertpl != null && !innertpl.equals("")){
                String intplcont = hanjst.readTemplate(innertpl, tpldir, viewdir);
                data.put("embedtpl", intplcont);  
            }
		}
		tplcont = tplcont==null ? "" : tplcont;
        String jsondata = hanjst.map2Json(data);

        //- replaces
        tplcont = hanjst.replaceElement(tplcont, (HashMap)data.get("outReplaceList"));
		tplcont = tplcont.replace(hanjstJsonDataTag, jsondata);
		
		//- @todo cache final tpls ?
		out.println("<!--" + outx +" \n -->" + tplcont); 
	
	}
}
else{
	if(fmt.equals("json")){
		GsonBuilder gsonMapBuilder = new GsonBuilder();
		Gson gsonObject = gsonMapBuilder.create();
		out.println(gsonObject.toJson(data));
		//- out put json
	}
	else{
		outx.append("<!-- Unknown fmt:["+fmt+"]. 1606261946. -->");
		out.println(outx.toString());
	}
}

//- set lang if reqtLang
if(lang.getLang2Cookie()){
	Cookie mycki = new Cookie(user.getCookieSid(),
		user.generateSecureId(request)+"."+lang.getTag()); //- sid and userId
	mycki.setMaxAge(86400*1*1); //- a single day
	mycki.setPath("/");
	response.addCookie(mycki);
	//crsPage.put("response::addCookie::", mycki); //- in ctrls of include
}

%><%@include file="./aftfooter.inc.jsp"%>