<%!
//- controller of homepage
//- define
public void indexCtrl(){


	//- something to do
	act = act.equals("") ? "index" : act;

	//- actions
	if(mod.equals("index")){ //- something displayed in homepage only

		if(act.equals("index")){
			
			outx.append("outxi act:["+act+"] in ctrl/index.");

		}
		else{

			outx.append("outx in ctrl/index, unknown act:["+act+"].");

		}

	}

	//- shared funcs relocated into ctrl/include.jsp

	//- tpl
	if(fmt.equals("")){
		smttpl = "homepage.html";
	}

}

%><%

//- exec
indexCtrl();

%>
