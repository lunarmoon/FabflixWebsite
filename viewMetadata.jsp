<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.ArrayList,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource"
%>
<%@ page isELIgnored="false" %>


<html>
	<head>
		<script type="text/javascript" src="autoComplete.js"> </script>
		<title>View Metadata</title>
		<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
	</head>
	<body>
		<div style="display: block; width: 90%; height: 50px; margin: auto;">
			<div style="display: inline-block; font-size: 32px; width: 45%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
			<div style="display: inline-block; font-size: 32px; width: 45%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
			<div class="topcorner" style="position: absolute; top: 0px; right: 0px;">
				<div style="display: inline-block; font-size: 16px; width: 200px; padding: 10px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
			</div>
		</div>
		        <div style="font-size: 12px; display: inline-block;">
                <div>
                        <form method="GET" action="search">
                                <input type='text' onChange="autoComplete(this);" onkeypress ="this.onchange()" oninput="this.onchange()" onpaste="this.onchange()" class='searchBar' name="title" style="width:100%;"/>
                                <input type="Submit" value="Search" name="searchClicked">
                        </form></br>
                </div>
                <div style="background-color: white;">
                        <ul class="searchResults" style="list-style-type: none; padding:0; margin:0;">
                        </ul>
                </div>
        </div>
<%
	if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	if (!(Boolean)request.getSession().getAttribute("isAdmin"))
		out.println("<h1 class=&quot;error&quot; style=&quot;color: #ff0000;&quot;>You are not authorized to view this page.</h1>");

	try{
			Context initCtx = new InitialContext();
				if (initCtx == null) out.println ("initCtx is NULL");
			   
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
				if (envCtx == null) out.println ("envCtx is NULL");
				
			// Look up our data source
			DataSource ds = (DataSource) envCtx.lookup("jdbc/moviedbpool");

			if (ds == null)
				out.println ("ds is null.");
		  
			Connection connection = ds.getConnection();
			if (connection == null)
				out.println ("dbcon is null.");

			try {
			DatabaseMetaData metadata = connection.getMetaData();
			String table[] = { "TABLE" };
			ResultSet result = metadata.getTables(null, null, null, table);
			
			ArrayList<String> tables = new ArrayList<String>();
			while (result.next())
				tables.add(result.getString("TABLE_NAME"));

			for (String tableName : tables)
			{
				out.println("<table border>");
				out.println("<tr>" + tableName + "</tr>");
				result = metadata.getColumns(null, null, tableName, null);
				while (result.next())
				{
					out.println("<tr>");
					out.println("<td>" + result.getString("COLUMN_NAME") + "</td>");
					out.println("<td>" + result.getString("TYPE_NAME") + "</td>");
					out.println("</tr>");
				}
				out.println("</table>");
				out.println("</br>");
			}
		}
		catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
		catch (Exception e)
	{
		out.println("<div color='#ff0000'>Could not complete query.</div>");
		e.printStackTrace();
	}
%>



		<a href="_dashboard"><div>Back to Dashboard</div></a>
	</body>
</html>

<script>
	$(document).ready(function(){
		$('a')
	});
</script>
