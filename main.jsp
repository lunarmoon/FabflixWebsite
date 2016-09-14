<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
<%@ page isELIgnored="false" %>

<%
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
%>
<HTML>
	<link href="Style/main.css" rel="stylesheet" /> 
<HEAD>
	<script type="text/javascript" src="autoComplete.js"> </script>
	<title>FabFlix</title>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
</HEAD>
<Body>
	<H1 ALIGN="CENTER"><font color="red">Select a Way To Find Movies:</13>
	<div class="topcorner">
		<div style="display: inline-block; font-size: 22px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
		<%
			if (request.getSession().getAttribute("isAdmin") != null && (Boolean)request.getSession().getAttribute("isAdmin"))
				out.println("<div style=\"display: inline-block; font-size: 16px; width: 200px; padding: 10px 18px 0px 18px; text-align: center;\"><a href=\"_dashboard\">Employee Dashboard</a></div>");
		%>
	</div>
	<div class="options">
		<div style="display: block; width: 90%; height: 50px; margin: auto;">
			<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search"><font color="white">Search</a></div>
			<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse"><font color="white">Browse</a></div>

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
</body>
</html>

