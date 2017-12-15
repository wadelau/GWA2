
## jdk1.7 required ##
need jdk1.7+
	
	tested on Resin 4.0+, Tomcat 8.0+

<<<<<<< HEAD
## com.mysql.jdbc.driver 
put its jar in appserver_home/lib

## org.lilystudio.smarty4j 
put its jar in appserver_home/lib

## asm is required for smarty4j
put its jar in appserver_home/lib

## mysql, smarty4j and asm jars
are stored in ./memo for backup
=======
## third parties jars required  ##
com.mysql.jdbc.driver,

org.lilystudio.smarty4j,

org.objectweb.asm,

	are required, please put them in appserver_home/lib usually,
	
	copies of these jars are stored in ./memo for backup

## force to use UTF-8 ##
if os language is not set to unicode or utf-8, 

	please append -Dfile.encoding=UTF8 to its start script of appserver,
	
	usually in appserver_home/bin
>>>>>>> origin/master
