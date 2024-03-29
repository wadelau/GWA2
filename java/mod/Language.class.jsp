<%
/* Language for i18n 
 * v0.1,
 * wadelau@ufqi.com,
 * 08:38 Saturday, April 20, 2019
 */
%><%!
public class Language extends WebApp{
	
	//- variables
	private String language = "en";
	private String country = "HK";
	private final String langDir = "../lang"; // @todo
	private ResourceBundle lang = null;
	private boolean needSetLang = false;
	private HashMap dictMap = new HashMap();
	private HashMap dictMapKey = new HashMap();
	private final String dictInfoTbl = "dict_infotbl";
	private final String dictDetailTbl = "dict_detailtbl";
	private final String logTag = "mod/Language ";
	
	//- constructor ?
	public Language(){
		//- for constructor override
		this(new HashMap());
	}
	
	//-
	public Language(HashMap langconf){
		if(langconf == null){ langconf = new HashMap(); }
		if(langconf.containsKey("language")){
			this.language = (String)langconf.get("language");
		}
		if(langconf.containsKey("country")){
			this.country = (String)langconf.get("country");
		}
		Locale mylocale = new Locale(this.language, this.country);
		lang = ResourceBundle.getBundle("LanguageBundle", mylocale);
	}
	
	//-
	public String get(String k){
		//return lang.getString(k); //- if properties in \\uxxxx�� @todo
		String tmps = lang.getString(k);
		try{
			tmps = new String(tmps.getBytes(), "UTF-8");
		}
		catch(Exception ex1310){
			ex1310.printStackTrace();
		}
		return tmps;
	}
	
	//-
	public String getTag(){
		return this.language + "-" + this.country;
	}
	
	//-
	public void addLang2Cookie(boolean needIt){
		this.needSetLang = needIt;
	}
	
	//-
	public boolean getLang2Cookie(){
		return this.needSetLang;
	}
	
	//- get k->v pairs from dictDetailTbl, with ivalue->ikey
	public HashMap getDictList(String myk){
		HashMap hmrtn = new HashMap();
		int dictSize = this.dictMap.size();
		if(dictSize < 1){
			this.dictMap = _initDictMap();
		}
		if(this.dictMap.containsKey(myk)){
			hmrtn = (HashMap)this.dictMap.get(myk);
		}
		return hmrtn;
	}
	//- get k->v pairs from dictDetailTbl, with ikey->ivalue
	public HashMap getDictListByKey(String myk){
		HashMap hmrtn = new HashMap();
		int dictSize = this.dictMapKey.size();
		if(dictSize < 1){
			this.dictMapKey = _initDictMapByKey();
		}
		if(this.dictMapKey.containsKey(myk)){
			hmrtn = (HashMap)this.dictMapKey.get(myk);
		}
		return hmrtn;
	}
	
	//-
	private HashMap _initDictMap(){
		//- with pair of ivalue->ikey
		return this._initDictMapX(0);
	}
	//-
	private HashMap _initDictMapByKey(){
		//- pair of ikey->ivalue, 10:26 2021-11-05
		return this._initDictMapX(1);
	}
	//- init the dict map
	private HashMap _initDictMapX(int myType){
		HashMap hmrtn = new HashMap();
		hmrtn = this.execBy("select * from "+this.dictDetailTbl+" where 1=1", "", 
			(new HashMap(){{ put("key", "dict-detail-list"); }}));
        HashMap hmtmp2 = new HashMap();
		if((boolean)hmrtn.get(0)){
			hmrtn = (HashMap)hmrtn.get(1);
			HashMap hmtmp = null; HashMap hmtmp3 = null;
			Object tmpk; 
			for(Object k : hmrtn.keySet()){
				hmtmp = (HashMap)hmrtn.get(k);
				tmpk = hmtmp.get("itype");
				if(hmtmp2.containsKey(tmpk)){
					hmtmp3 = (HashMap)hmtmp2.get(tmpk);
				}
				else{
					hmtmp3 = new HashMap();
				}
				if(myType==0){
					hmtmp3.put(hmtmp.get("ivalue"), hmtmp.get("ikey"));
				}
				else if(myType==1){
					hmtmp3.put(hmtmp.get("ikey"), hmtmp.get("ivalue"));
				}
				hmtmp2.put(tmpk, hmtmp3);
			}
            hmtmp = null; hmtmp3 = null; 
		}
		hmrtn = hmtmp2; hmtmp2 = null;
		//debug(logTag+"_initDictMap: hmrtn:"+hmrtn);
		return hmrtn;
	}
	
} %>