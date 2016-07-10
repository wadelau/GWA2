<%
//- something included in all modes across the app
//- exec, 2/2
includeCtrl();

%><%!
//- define, 1/2
public void includeCtrl(){
	
	if(true){ //-  something shared across the app

		//-
		//- page header and footer

		sid = "" + (new java.util.Random()).nextInt();

		//outx.append("\t/ctrl/include: sid:["+sid+"]\n");

		data.put("sid", sid);

		data.put("time", (new Date()));


	}


}

%>
