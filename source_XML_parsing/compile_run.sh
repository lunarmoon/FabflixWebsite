cd /var/lib/tomcat7/webapps/fabflix/source_XML_parsing
javac -classpath ".:/var/lib/tomcat7/webapps/fabflix/WEB-INF/lib/servlet-api.jar:/var/lib/tomcat7/webapps/fabflix/WEB-INF/lib/mysql-connector-java-5.1.38-bin.jar:/var/lib/tomcat7/webapps/fabflix/WEB-INF/lib/javax.servlet-api-3.1.0.jar" *.java
java -cp ".:/var/lib/tomcat7/webapps/fabflix/WEB-INF/lib/servlet-api.jar:/var/lib/tomcat7/webapps/fabflix/WEB-INF/lib/mysql-connector-java-5.1.38-bin.jar:/var/lib/tomcat7/webapps/fabflix/WEB-INF/lib/javax.servlet-api-3.1.0.jar" Main


