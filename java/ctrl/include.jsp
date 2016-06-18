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

		outx.append("/ctrl/include: sid:["+sid+"]");


	}


}

%>
