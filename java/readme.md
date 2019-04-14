## -GWA2 in -Java

General Web Application Architecture (GWA2) has been implemented in Java, which helps developers make web applications in pure Java Servlet, i.e. Java Server-Side Programming.

## JDK1.7 required ##
need jdk1.7+
	
	tested on Resin 4.0+, Tomcat 8.0+

## Third parties jars required  ##
com.mysql.jdbc.driver,

com.google.gson,

	are required, please put them in appserver_home/lib usually,
	
	copies of these jars are stored in ./memo and/or ./WEB-INF/lib for backup

## Force to use UTF-8 ##
if os language is not set to unicode or utf-8, 

	please append -Dfile.encoding=UTF8 to its start script of appserver,
	
	usually in appserver_home/bin
	
	see [GWA2Java i18n](http://ufqi.com/blog/gwa2-java-i18n/) for more details.
