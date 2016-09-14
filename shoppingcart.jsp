<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource,
 fabflix.objects.MovieObject,
 java.util.*,
 java.util.List,
 java.util.ArrayList"
%>
<%@ page isELIgnored="false" %>
<%
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	if (request.getSession().getAttribute("cartMovieIds") != null) {
			Hashtable<Integer, Integer> movieAmounts = (Hashtable<Integer, Integer>) request.getSession().getAttribute("cartMovieIds");
			if (request.getParameter("movieid") != null) {
				int movieid = Integer.parseInt(request.getParameter("movieid"));
				int amount = Integer.parseInt(request.getParameter("amount"));
				if (amount > 0)
					movieAmounts.put(movieid, amount);
				else
					movieAmounts.remove(movieid);
				request.getSession().setAttribute("cartMovieIds", movieAmounts);
			}
	}
%>
<HTML>

<HEAD>
	 <script type="text/javascript" src="autoComplete.js"> </script>
	<title>FabFlix: Shopping Cart</title>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
</HEAD>
<div class="topcorner">
			<div style="display: inline-block; font-size: 22px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
		</div>
<Body>
	<div style="display: block; width: 90%; height: 50px; margin: auto;">
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
			<div class="topcorner">

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
	</div>	<link href="Style/shoppingcart.css" rel="stylesheet" /> 
	<h1>Shopping Cart</h1>
	<form name="updateAmount" method="POST">
	<input type="HIDDEN" name="movieid">
	<input type="HIDDEN" name="amount">
	<table>
		<tr>
			<td>Title</td>
			<td>Quantity</td>
		</tr>
<%
    if (request.getSession().getAttribute("cartMovieIds") != null) {
			Hashtable<Integer, Integer> movieAmounts = (Hashtable<Integer, Integer>) request.getSession().getAttribute("cartMovieIds");
			
			Enumeration ids;
			ArrayList<MovieObject> objects = new ArrayList<MovieObject>();
			if (movieAmounts.size() > 0)
				request.setAttribute("checkoutText", "Checkout");
			try {
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
					  
				Statement stmt = connection.createStatement();
				String query = "SELECT * from movies where id in (";
				ids = movieAmounts.keys();
				while (ids.hasMoreElements()) {
					query += ids.nextElement();
					if (ids.hasMoreElements())
						query += ",";
					else
						query +=")";
				}
				
				ResultSet rs = stmt.executeQuery(query);
				
				while(rs.next()) {
					int id = rs.getInt("id");
					String title = rs.getString("title");
					MovieObject temp = new MovieObject(id, title);
					
					objects.add(temp);
				}
				
				for (MovieObject mvObject : objects) {
					out.println("<tr>");
					int id = mvObject.getId();
					String title = mvObject.getTitle();
					out.println("<td><a href=\"moviePage?movieid=" + id + "\">" + title + "</a></td>");
					out.println(String.format("<td><input type=\"text\" id=\"%d\" value=\"%d\"></td>", id, movieAmounts.get(id)));
					out.println(String.format("<td><input type=\"button\" value=\"Update\" onclick=\"%s\"></td>", "updateQuantity(" + id + ")"));
					out.println("</tr>");
				}
				
				rs.close();
				stmt.close();
				connection.close();
			}
			catch (Exception e) {
				out.println("<div color='#ff0000'>Could not complete query.</div>");
			}
		}
	else {
		out.println("No movies in cart.");
	}
%>
</table>
</form>
<SCRIPT LANGUAGE="JavaScript">
	function updateQuantity(id)
	{
		document.updateAmount.movieid.value = id;
		document.updateAmount.amount.value = document.getElementById(id).value;
		updateAmount.submit();
	}
</SCRIPT>
<a href="checkout">${checkoutText}</a>
</body>
</html>

