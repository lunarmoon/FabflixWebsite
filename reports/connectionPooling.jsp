<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<TITLE>Connection Pooling</TITLE>
	<HEAD>
	<BODY>
		<p>
			The connection pooling was done by modifying 
			the context.xml file to include the JDBC resource.
			The file web.xml also had a resource-ref added to it to include
			JDBC.
			
			In the code, such as in browse.jsp, anytime a connection is made,
			The resource is looked up, and a connection is grabbed from the connection pool.
			After it is done, the connection, resultset, and statement are closed so they can be used by others accessing
			the connection pool.
			
		</p>
	</BODY>
</HTML>
