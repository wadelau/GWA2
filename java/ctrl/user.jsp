<%!
/* controller of user mod
 */
//- define
public void userCtrl(){

	 //- something to do

	if(act.equals("signin")){
		//--
		outx.append("outx "+act+" in ctr/user");

	}
	else if(act.equals("dosignin")){
		 
		outx.append("outx "+act+" in ctr/user");

	}
	else{
		
		outx.append("outx unknown act:["+act+"] in ctr/user");

	}


	//- tpl

}

%><%
//- exex
userCtrl();

%>
