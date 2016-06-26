<%
//- embedded in ./index, work with ./comm/header
//- output and finalize the response

outx.append("\n\noutput in comm/footer: "+(new Date()));


if(fmt.equals("")){

	//- set header
	//- #todo

	if(smttpl.equals("")){
		out.println(outx);
	}
	else{
		//- smttpl
		data.put("smttpl", smttpl);
		outx.append("comm/footer: output via smttpl:["+smttpl+"]");
		
		//- tpl engine

		out.println("<!--"+outx+"-->");

	}
}
else{

	if(fmt.equals("json")){
	
		//- set header
		//- #todo

		data.put("outx", outx);
		//- out put json


	}
	else{
		outx.append("Unknown fmt:["+fmt+"]. 1606261946.");	
	}

}



%><%@include file="./aftfooter.inc"%>
