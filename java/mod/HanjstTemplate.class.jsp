<%
/* Template class for Hanjst 
 * v0.1,
 * wadelau@ufqi.com, Xenxin@ufqi.com
 * Fri Jan  4 01:59:34 UTC 2019
 * work with GWA2 in Java
 */

%><%@page import="com.google.gson.Gson,
com.google.gson.GsonBuilder"
%><%!

public class HanjstTemplate extends WebApp{
	
	private static final String Log_Tag = "mod/Template ";
    private String[] repPathTags = new String[]{"images", "css", "js", "pics"};
	
	//- constructor ?
	public HanjstTemplate(){
		//- for constructor override
		//this(new HashMap());
        //- @todo
	}

    //- read tpl contents
	public String readTemplate(String mytpl, String tpldir, String viewdir){
		String tplcont = "";
		final String tmpTpl = tpldir+"/"+mytpl;
		HashMap hmtmp = this.getBy("file:", null, (new HashMap(){{put("file", tmpTpl);}}));
		if((boolean)hmtmp.get(0)){
			tplcont = (String)hmtmp.get(1);
			tplcont = this.replacePath(tplcont, viewdir);
		}
		return tplcont;
	}
	
	//- HashMap 2 JSON
    public String map2Json(ConcurrentHashMap hmdata){
        String rtnStr = "";
        GsonBuilder gsonMapBuilder = new GsonBuilder();
        Gson gsonObject = gsonMapBuilder.create();
        rtnStr = gsonObject.toJson(hmdata);
        return rtnStr;
    }
	//- JSON string2Map 07:58 2022-03-06, why here, read json config?
	public HashMap string2Map(String respStr){
		HashMap hmResult = new HashMap();
		GsonBuilder gsonMapBuilder = new GsonBuilder();
		Gson gsonObject = gsonMapBuilder.create();
		HashMap hmResult2 = gsonObject.fromJson(respStr, HashMap.class);
		//debug(logTag+" string2Map: respStr:"+respStr+" hmResult2:"+hmResult2);
		hmResult = hmResult2;
		return hmResult;
	}
	//- 11:53 2022-01-24, why here?
	public HashMap csv2Map(String listStr){
		HashMap hmResult = new HashMap(100);
		String[] lineArr = listStr.trim().split("\n"); //- why trim?
		String[] firstLineArr = lineArr[0].trim().split(",");;
		int arrSize = lineArr.length; String[] tmpArr = new String[firstLineArr.length];
		HashMap hmTmp = new HashMap(); int j = 0;
		//arrSize = 10;
		for(int i=1; i<arrSize; i++){
			tmpArr = lineArr[i].trim().split(",");
			hmTmp = new HashMap(); j = 0;
			//debug(logTag+" csv2Map: line:["+lineArr[i]+"]");
			for(String key : firstLineArr){
				hmTmp.put(key, tmpArr[j]); 
				//debug(logTag+" csv2Map: key:["+key+"] arr-j:["+tmpArr[j]+"]");
				j++;
			}
			hmResult.put(""+(i-1), hmTmp);
		}
		return hmResult;
	}

    //- replace resrc path
    public String replacePath(String tplcont, String viewdir){
		tplcont = tplcont==null ? "" : tplcont;
        String[] repTags = this.repPathTags; 
        for(int ti=0; ti<repTags.length; ti++){
			if(repTags[ti]!=null && !repTags[ti].equals("")){
				if(tplcont.indexOf("'"+repTags[ti]+"/") > -1){
					tplcont = tplcont.replaceAll("'"+repTags[ti]+"/", "'"+viewdir+"/"+repTags[ti]+"/");
				}
				if(tplcont.indexOf("\""+repTags[ti]+"/") > -1){
					tplcont = tplcont.replaceAll("\""+repTags[ti]+"/",  "\""+viewdir +"/"+repTags[ti]+"/"); 
				}
				if(tplcont.indexOf("./"+repTags[ti]+"/") > -1){
					tplcont = tplcont.replaceAll("./"+repTags[ti]+"/",  viewdir +"/"+repTags[ti]+"/");
				}
			}
        }
        return tplcont;
    }
	
	//- replace elements
	public String replaceElement(String tplcont, HashMap replaceList){
		tplcont = tplcont==null ? "" : tplcont;
		if(replaceList == null){
			return tplcont;
		}
		else{
			//debug(tplcont); debug(replaceList);
			String tmpks = null;
			for(Object tmpk : replaceList.keySet()){
				tmpks = (String)tmpk;
				if(tplcont.indexOf(tmpks) > -1){
					tplcont = tplcont.replaceAll(tmpks, String.valueOf(replaceList.get(tmpk)));
				}
			}
		}
		return tplcont;
	}

}
%>