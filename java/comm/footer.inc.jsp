<%
//- embedded in ./index, work with ./comm/header
//- output and finalize the response

outx.append("\n\toutput in comm/footer: "+(new Date())+" smttpl:["+smttpl+"]\n");


if(fmt.equals("")){

	//- @todo

	if(smttpl.equals("")){
		
		out.println(outx);
		
	}
	else{

		//- smttpl
		data.put("smttpl", smttpl);

		//- tpl engine
		Engine smartyEngine = new Engine();

		smartyEngine.setTemplatePath(appdir); 
		smartyEngine.setEncoding("utf-8");
		smartyEngine.setDebug(true);
		Template mytpl = null;
		Context tplcontext = new Context();

		if((boolean)Config.get("template_display_index")){ 
			//- embedded in index.html
			mytpl = smartyEngine.getTemplate("/view/default/index.html");
			tplcontext.set("smttpl", smttpl);
		}
		else{
			//- standalone
			mytpl = smartyEngine.getTemplate("view/default/"+smttpl);
		}

		Iterator ei = data.keySet().iterator();
		String obj = null;
		while(ei.hasNext()){
			obj = (String)ei.next();
			tplcontext.set(obj, data.get(obj));	
		}

		java.io.ByteArrayOutputStream tplout = new java.io.ByteArrayOutputStream();
		mytpl.merge(tplcontext, tplout);
		
		String tplcont = tplout.toString(); //-"utf-8"

		String[] repTags = new String[]{"images", "css", "js", "pics"};
		for(int ti=0; ti<repTags.length; ti++){
			outx.append("ti:["+ti+"] reptag:["+repTags[ti]+"]");
			tplcont = tplcont.replaceAll(repTags[ti]+"/", "view/default/"+repTags[ti]+"/");	
		}

		//- @todo cache replaced tpl ?
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
