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
		<title>Employee Dashboard</title>
		<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
		</head>
	<body>
		<div style="display: block; width: 90%; height: 50px; margin: auto;">
			<div style="display: inline-block; font-size: 32px; width: 45%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
			<div style="display: inline-block; font-size: 32px; width: 45%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
			<div class="topcorner" style="position: absolute; top: 0px; right: 0px;">
				<div style="display: inline-block; font-size: 16px; width: 200px; padding: 10px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
			<%
				if ((Boolean)request.getSession().getAttribute("isAdmin"))
					out.println("<div style=\"display: inline-block; font-size: 16px; width: 200px; padding: 10px 18px 0px 18px; text-align: center;\"><a href=\"_dashboard\">Employee Dashboard</a></div>");
			%>
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
		out.println("<h1 class=&quot;error&quot; style=&quot;#ff0000;&quot;>You are not authorized to view this page.</h1>");
	else
	{
		if (null != request.getParameter("seeMeta"))
			response.sendRedirect("_viewmeta");
		if (null != request.getParameter("insert"))
			response.sendRedirect("_insert");
		if (null != request.getParameter("insMov"))
			response.sendRedirect("_insertMovie");


		out.println("<div style=\"width: 100%; height: 50px;\"></div>"
		+ "Welcome to the dashboard."
		+ "Functions:<br/><br/>"
		+ "<form method=\"GET\">"
		+	"<button type=\"submit\" value=\"1\" name=\"insert\">Insert a new star into the Database</button>"
		+ "</form>"
		+ "<form method=\"GET\">"
		+	"<button type=\"submit\" value=\"1\" name=\"seeMeta\">See Movie Database metadata</button>"
		+ "</form>"
		+ "<form method=\"GET\">"
		+	"<button type=\"submit\" value=\"1\" name=\"insMov\">Insert a new movie to the Database</button>"
		+ "</form>");
	}
		%>
	</body>
</html>
