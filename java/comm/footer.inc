<%
//- embedded in ./index, work with ./comm/header
//- output and finalize the response

outx.append("\n\noutput in comm/footer: "+(new Date()));


out.println(outx);


%><%@include file="./aftfooter.inc"%>
