<%!
//- something included in all modes across the app
//- define
public void includeCtrl(){
	
	if(true){ //-  something shared across the app

		//-
		//- page header and footer

		sid = "" + (new java.util.Random()).nextInt();

		outx.append("sid:["+sid+"]");


	}


}

%><%

//- exec
includeCtrl();

%>
