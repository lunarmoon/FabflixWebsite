<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.ArrayList,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource,
 fabflix.objects.MovieObject"
%>
<%@ page isELIgnored="false" %>

<%
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	
	if (null != request.getParameter("genreClicked") || null != request.getParameter("characterClicked")) {
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
		
		String query = "";
		
		if (request.getParameter("genreClicked") != null) {
			query = "SELECT DISTINCT movies.* "
								+ "FROM movies "
									+ "JOIN genres_in_movies "
										+ "ON movies.id = genres_in_movies.movie_id "
									+ "JOIN genres "
										+ "ON genres_in_movies.genre_id = " + request.getParameter("genre");
		}
		
		else if (request.getParameter("characterClicked") != null) {
			query = "SELECT DISTINCT * FROM movies "
						+ "WHERE upper(title) LIKE '" + request.getParameter("character") + "%'";
			
		}
		
		ResultSet rs = stmt.executeQuery(query);
		ArrayList<MovieObject> movieObjects = new ArrayList<MovieObject>();
		while(rs.next())
		{
			int id = rs.getInt("id");
			String title = rs.getString("title");
			int year = rs.getInt("year");
			String director = rs.getString("director");
			String banner_url = rs.getString("banner_url");
			
			movieObjects.add(new MovieObject(id, title, year, director));
			if (movieObjects.size() > 0)
				movieObjects.get(movieObjects.size() - 1).setBannerURL(banner_url);
		}
		
		rs.close();
		
		for (MovieObject mv : movieObjects) {
			query = "SELECT DISTINCT genres.name "
							+ "FROM genres "
								+ "JOIN genres_in_movies "
									+ "ON genres.id = genres_in_movies.genre_id "
								+ "JOIN movies "
									+ "ON genres_in_movies.movie_id = " + mv.getId();
									
			rs = stmt.executeQuery(query);
			while(rs.next())
				mv.addGenre(rs.getString("genres.name"));
			rs.close();
			
			query = "SELECT DISTINCT stars.first_name, stars.last_name, stars.id "
						+"FROM stars "
							+"JOIN stars_in_movies "
								+"ON stars.id = stars_in_movies.star_id "
							+"JOIN movies "
								+"ON stars_in_movies.movie_id = " + mv.getId();
			
			rs = stmt.executeQuery(query);
			while(rs.next()) {
				mv.addStarName(rs.getString("stars.first_name") + " " + rs.getString("stars.last_name"));
				mv.addStarId(rs.getInt("stars.id"));				
			}
		}
		
		
		rs.close();
		stmt.close();
		connection.close();
		
		request.getSession().setAttribute("movieObjects", movieObjects);
		response.sendRedirect("movielist?page=1");
	}
%>
<HTML>
		<link href="Style/browse.css" rel="stylesheet" /> 
<HEAD>
	<script type="text/javascript" src="autoComplete.js"> </script>
	<title>FabFlix: Browse for Movies</title>
		<div class="topcorner">
		<div style="display: inline-block; font-size: 22px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart"><font color="white">Shopping Cart</font color></a></div>
	</div>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
</HEAD>
<Body>
	<div class="options">
	<div style="display: block; width: 90%; height: 50px; margin: auto;">
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search"><font color="white">Search</font color></a></div>
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse"><font color="white">Browse</font color></a></div>
		<%
			if ((Boolean)request.getSession().getAttribute("isAdmin"))
				out.println("<div style=\"display: inline-block; font-size: 16px; width: 200px; padding: 10px 18px 0px 18px; text-align: center;\"><a href=\"_dashboard\">Employee Dashboard</a></div>");
		%>
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
	<h1><font color="white">Browse By Genre: </h1><form method="GET">
<form method="GET">
	<select	name="genre">
		<%
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
				String query = "SELECT * FROM genres ORDER BY name";
				
				ResultSet rs = stmt.executeQuery(query);
				
				while(rs.next())
				{
					out.println("<option value=\"" + rs.getInt("id") + "\">" + rs.getString("name") + "</option>");
				}			
				
				rs.close();
				stmt.close();
				connection.close();
			}
			catch (Exception e) {
				out.println("<div color='#ff0000'>" + e.getMessage() + "</div>");
			}
		%>
		
	</select>
	<input type="SUBMIT" value="Submit" name="genreClicked">
</form>

	<h2><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		Or <br><br></h2>
	<h1><font color="white">Browse By Movie Title:</font color></h1></font color>
<form method="GET">
	<select	name="character">
		<%
			for(int i = (int)'A'; i <= (int)'Z'; i++)
			{
				out.println("<option value=\"" + (char) i + "\">" + (char) i + "</option>");
			}
			
			for(int i = 0; i <= 9; i++)
			{
				out.println("<option value=\"" + i + "\">" + i + "</option>");
			}
		%>
		
	</select>
	<input type="SUBMIT" value="Submit" name="characterClicked">
	<input type="hidden" value="1" name="page"></input>
</form>
</div>
</body>
</html>

