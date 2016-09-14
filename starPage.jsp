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

<%
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	int star_id = Integer.parseInt(request.getParameter("starid"));
	request.setAttribute("star_id", star_id);
	String movies = "(";
		
	try
		{
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
			String query = "SELECT * from stars_in_movies WHERE star_id =" + star_id;
			
			ResultSet rs = stmt.executeQuery(query);
			
			while (rs.next())
			{
				movies += rs.getInt("movie_id") + ",";
			}
			
			movies = movies.substring(0,movies.length()-1) + ")";
			
			rs.close();
			query = "SELECT id, title FROM movies where id in " + movies;
			rs = stmt.executeQuery(query);
			
			ArrayList<Integer> movie_ids = new ArrayList<Integer>();
			ArrayList<String> movie_titles = new ArrayList<String>();
			
			while (rs.next())
			{
				movie_ids.add(rs.getInt("id"));
				movie_titles.add(rs.getString("title"));
			}
			
			request.setAttribute("movie_ids", movie_ids);
			request.setAttribute("movie_titles", movie_titles);
			
			rs.close();
			
			rs = stmt.executeQuery("SELECT * from stars where id =" + star_id);
			
			rs.next();
			
			request.setAttribute("star_name", rs.getString("first_name") + " " + rs.getString("last_name"));
			request.setAttribute("star_dob", rs.getDate("dob"));
			request.setAttribute("star_photo", rs.getString("photo_url"));
			
			rs.close();
			stmt.close();
			connection.close();
		}
	catch (Exception e) {
		out.println("<div color='#ff0000'>" + e.getMessage() + "</div>");
	}
%>
<HTML>
		<link href="Style/moviepage.css" rel="stylesheet" /> 
<HEAD>
	 <script type="text/javascript" src="autoComplete.js"> </script>
	<title>FabFlix: ${star_name}</title>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
</HEAD>
<Body>
	<div style="display: block; width: 90%; height: 50px; margin: auto;">
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
		<div class="topcorner">
		<div style="display: inline-block; font-size: 22px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
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
<table style="width:100%">
	<tr>
		<th rowspan = "9">
		<img src="${star_photo}" alt="${star_photo} is not available">
		</th>
	</tr>
	<tr>
		<th>Star Name</th>
		<td>${star_name}</td>
	</tr>
	<tr>
		<th>Date of Birth</th>
		<td>${star_dob}</td>
	</tr>
	<tr>
		<th>Star ID</th>
		<td>${star_id}</td>
	</tr>
	<tr>
		<th>Starred in</th>
		<td>
			<%
				try {
					ArrayList<Integer> movie_ids = (ArrayList<Integer>)request.getAttribute("movie_ids");
					ArrayList<String> movie_titles = (ArrayList<String>)request.getAttribute("movie_titles");
					
					for(int i = 0; i < movie_ids.size(); i++) {
						out.print("<a href=\"moviePage?movieid=" + movie_ids.get(i) + "\">" + movie_titles.get(i) + "</a>");
						if (i < movie_ids.size()-1)
							out.println(",");
					}
				}
				catch (Exception e) {
					out.println("<div color='#ff0000'>" + e.getMessage() + "</div>");
				}
			%>
		</td>
	</tr>


</body>
</html>

