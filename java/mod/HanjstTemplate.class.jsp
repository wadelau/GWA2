<%
/* Template class for Hanjst 
 * v0.1,
 * wadelau@ufqi.com, Xenxin@ufqi.com
 * Fri Jan  4 01:59:34 UTC 2019
 */

%><%@page import="com.google.gson.Gson,
com.google.gson.GsonBuilder"
%><% // @include file="../inc/WebApp.class.jsp" //- relocated into comm/preheader.inc
%><%
%><%!

public class HanjstTemplate extends WebApp{
	
	private static final String Log_Tag = "mod/Template ";
	
	//- constructor ?
	public HanjstTemplate(){
		//- for constructor override
		//this(new HashMap());
        //- @todo
	}

    //-
    public String map2Json(HashMap hmdata){
        String rtnStr = "";
        GsonBuilder gsonMapBuilder = new GsonBuilder();
        Gson gsonObject = gsonMapBuilder.create();

        rtnStr = gsonObject.toJson(hmdata);

        return rtnStr;
    }

}
%>
