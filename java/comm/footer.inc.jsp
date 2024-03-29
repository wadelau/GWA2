<%@page 
language="java" 
pageEncoding="UTF-8"%><%
//- embedded in ./index, work with ./comm/header
//- output and finalize the response

if(fmt.equals("")){
	if(mytpl.equals("")){
		out.println(outx);
	}
	else{
        //- Hanjst template engine
        hanjst = new HanjstTemplate();
		//- global data merging into local data, 13:10 2022-02-24, see comm/preheader
		if(true){
			ConcurrentHashMap hmGlobal = (ConcurrentHashMap)globalData(""); //- read all with this threadId
			for(Object objKey : hmGlobal.keySet()){
				data.put(objKey, hmGlobal.get(objKey));
			}
		}
		//- mytpl
        //debug("mytpl:"+mytpl);
		data.put("mytpl", mytpl);
		data.put("url", url);
		data.put("resrcPathPrefix", Wht.getString(Config.getConf(), "resrc_path_prefix"));
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
		//- try tpl cache first
		boolean enableTplCache = false; boolean tplCacheReady = true;
		String tplCacheKey = "hanjst_tpl_cache_key_main_"+viewdir+"_"; 
		int tplCacheExpire = (int)Config.get("cacheexpire"); 
		if(!(boolean)Config.get("is_debug") && (boolean)Config.get("enable_cache")){ enableTplCache = true; }
		else{ tplCacheReady = false;}
		HashMap hmtpl = null; String intplcont = "";
		HashMap hmReplace = (HashMap)data.get("outReplaceList"); 
		if(hmReplace==null){ hmReplace = new HashMap(); }
		if(needDispIndex){ 
			//- embedded in index.html
			if(enableTplCache){
				hmtpl = hanjst.getBy("cache:", "", Wht.initHashMap("key", tplCacheKey));
				if(!(boolean)hmtpl.get(0)){ tplCacheReady = false; }
				else{ tplcont = (String)hmtpl.get(1); }
				if(tplCacheReady){
					hmtpl = hanjst.getBy("cache:", "", Wht.initHashMap("key", tplCacheKey+mytpl));
					if((boolean)hmtpl.get(0)){
						intplcont = (String)hmtpl.get(1);
					}
					else{ tplCacheReady = false; }
				}
			}
			if(!tplCacheReady){
				tplcont = hanjst.readTemplate("index.html", tpldir, viewdir);
				intplcont = hanjst.readTemplate(mytpl, tpldir, viewdir);
				if(enableTplCache){
					HashMap cacheArgs = Wht.initHashMap("key,expire", tplCacheKey+","+tplCacheExpire);
					cacheArgs.put("value", tplcont);
					hmtpl = hanjst.setBy("cache:", "", cacheArgs);
					cacheArgs.put("key", tplCacheKey+mytpl);
					cacheArgs.put("value", intplcont);
					hmtpl = hanjst.setBy("cache:", "", cacheArgs);
				}
			}
			intplcont = hanjst.replaceElement(intplcont, hmReplace);
			data.put("embedtpl", intplcont); // same with tpl
		}
		else{
			//- standalone, possible with innertpl
			String innertpl = (String)data.get("innertpl");
			if(enableTplCache){
				hmtpl = hanjst.getBy("cache:", "", Wht.initHashMap("key", tplCacheKey+mytpl));
				if(!(boolean)hmtpl.get(0)){ tplCacheReady = false; }
				else{ tplcont = (String)hmtpl.get(1); }
				if(tplCacheReady){
					if(innertpl != null && !innertpl.equals("")){
						hmtpl = hanjst.getBy("cache:", "", Wht.initHashMap("key", tplCacheKey+innertpl));
						if((boolean)hmtpl.get(0)){ 
							intplcont = (String)hmtpl.get(1); 
						}
						else{ tplCacheReady = false; }
					}
				}
			}
			if(!tplCacheReady){
				tplcont = hanjst.readTemplate(mytpl, tpldir, viewdir);
				if(innertpl != null && !innertpl.equals("")){
					intplcont = hanjst.readTemplate(innertpl, tpldir, viewdir);
				}
				if(enableTplCache){
					HashMap cacheArgs = Wht.initHashMap("key,expire", tplCacheKey+mytpl+","+tplCacheExpire);
					cacheArgs.put("value", tplcont);
					hmtpl = hanjst.setBy("cache:", "", cacheArgs);
					if(innertpl != null && !innertpl.equals("")){
						cacheArgs.put("key", tplCacheKey+innertpl);
						cacheArgs.put("value", intplcont);
						hmtpl = hanjst.setBy("cache:", "", cacheArgs);
					}
				}
			}
			intplcont = hanjst.replaceElement(intplcont, hmReplace);
			data.put("innertpl", intplcont);
		}
		tplcont = tplcont==null ? "" : tplcont;
		data.put("outReplaceList", (new HashMap())); //- reset to empty
        String jsondata = hanjst.map2Json(data);

        //- replaces
        tplcont = hanjst.replaceElement(tplcont, hmReplace);
		tplcont = tplcont.replace(hanjstJsonDataTag, jsondata);
		
		//- print out contents
		out.println(tplcont + "<!--" + outx +" \n -->"); 
	
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
if(lang != null && lang.getLang2Cookie()){
	Cookie mycki = new Cookie(user.getCookieSid(),
	user.generateSid(request)+"."+lang.getTag()); //- sid and userId
	mycki.setMaxAge(86400*1*1); //- a single day
	mycki.setPath("/");
	response.addCookie(mycki);
	//crsPage.put("response::addCookie::", mycki); //- in ctrls of include
}

%><%@include file="./aftfooter.inc.jsp"%>