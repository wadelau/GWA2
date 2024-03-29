## -GWA2 in -Java

General Web Application Architecture (GWA2) has been implemented in Java, which helps developers make web applications in pure Java Servlet, i.e. Java Server-Side Programming.

## JDK1.7 required ##
need jdk1.7+
	tested on Resin 4.0+, Tomcat 8.0+
	
	2020 later, recommended  
		jdk-11.0+, Tomcat-9.0+

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

## For not root dir with Tomcat

if running with symbolic link(soft link, need restart):
    
	$tomcatDir/conf//conf/context.xml :
    <Resources allowLinking="true"></Resources>

append classpaths to environments (need restart):
	
    $tomcatDir/conf/catalina/catalina.properties :
    shared.loader="/www/webroot/pages/work/WEB-INF/classes","/www/webroot/pages/work/WEB-INF/lib/*.jar"

## Coding in Eclipse as Dynamic Java Web Application

Keep subdirectories:
	.setting
	WebContent

### For Eclipse since 2020, to exclude unexpected folders in project tree view:
	Right-click a project folder in Project Explorer tree and go to "Properties".
	Resource -> Resource Filters.
	Add as many exclusion filters for files/folders as you like.
	
## Source file format: Unix, UTF-8, No BOM
if no such source file format, please put the line in each ctrl script:
	<%@page language="java" pageEncoding="UTF-8"%>
	
	Otherwise, it will raise illegal characters in page out.
	
## trim whitespaces for response
	add  trimDirectiveWhitespaces="true" to each controller to remove end-of-line / empty line in reponse.
	
	<%@page language="java" pageEncoding="UTF-8" 
		autoFlush="true" session="false" 
		trimDirectiveWhitespaces="true"%>
	
	alternative approach, use rm eol shell script for each JSP file on server:
		sizeinbyte=`ls -la $file | awk '{ print $5; }'`;
		sizeinbyte=`expr $sizeinbyte - 1`;
		lastchar=`tail -c 1 $file`;
		/usr/bin/xxd -l $sizeinbyte $file | xxd -r > $file.tmp ;
		/bin/mv -f $file.tmp $file ;
	