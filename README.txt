IP: 54.201.138.105
FabFlix Team 24

1. To compile the java files, cd into the "WEB-INF/sources" folder in the root directory.
2. Run the command
	javac -cp ".:../lib/servlet-api.jar:../lib/mysql-connector-java-5.1.38-bin.jar" MovieObject.java
3. Copy the generated MovieObject.class file into "WEB-INF/classes/fabflix/objects"
4. Run the command
	javac -cp ".:../lib/servlet-api.jar:../lib/mysql-connector-java-5.1.38-bin.jar:../lib/javax.json-1.0.jar:../lib/recaptcha4j-0.0.7.jar" MyConstants.java VerifyUtils.java
5. Copy the generated MyConstants.class and VerifyUtils.class files into "WEB-INF/classes/fabflix/objects"
6. Run the command
	javac -cp ".:../lib/servlet-api.jar:../lib/mysql-connector-java-5.1.38-bin.jar:../classes" movieHover.java autoComplete.java
7. Copy the generated movieHover.class and autoComplete.class files to "WEB-INF/classes"
8. Reload the app

Assumptions about the data: 
Since stars only had a birthyear after being mapped to actors63.xml we assigned
everyone the birthmonth and day of January, 1 (1-1).
For director names in movies we assigned each movie the director labeled under
<dirn> since that is the director that finished the movie. We left it as is sin$
there was an incomplete mapping in people55.xml, and since they only typically $
the first letter of the first name and last name we didn't want to force a mapp$
cause errors. 
We mapped the actors in casts124.xml to actors63.xml and only inserted the ones
we could find in  actors63.xml since we wanted just real names. Professor Chen
also mentioned this here:
https://piazza.com/class/iiz6fpzlkoo2v?cid=277
