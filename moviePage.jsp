<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.ArrayList,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource,
 java.util.Hashtable"
%>
<%@ page isELIgnored="false" %>
<%
	if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	if (request.getParameter("movieidtoadd") != null) {
		int movieidtoadd = Integer.parseInt(request.getParameter("movieidtoadd"));
		Hashtable<Integer, Integer> movieids = new Hashtable<Integer, Integer>();
		if (request.getSession().getAttribute("cartMovieIds") != null) {
			movieids = (Hashtable<Integer, Integer>)request.getSession().getAttribute("cartMovieIds");
		}
		
		if (movieids.get(movieidtoadd) == null)
			movieids.put(movieidtoadd, 1);
		else
			movieids.put(movieidtoadd, movieids.get(movieidtoadd) + 1);
		request.getSession().setAttribute("cartMovieIds", movieids);
		response.sendRedirect("moviePage?movieid=" + movieidtoadd);
	}
%>
<%
	int movie_id = Integer.parseInt(request.getParameter("movieid"));
	request.setAttribute("movie_id", movie_id);
	String stars = "(";
	String genres = "(";
		
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
			String query = "SELECT * from stars_in_movies WHERE movie_id =" + movie_id;
			
			ResultSet rs = stmt.executeQuery(query);
			
			while (rs.next())
			{
				stars += rs.getInt("star_id") + ",";
			}
			
			rs.close();
			ArrayList<Integer> star_ids = new ArrayList<Integer>();
			ArrayList<String> star_names = new ArrayList<String>();
			
			if (!stars.equals("(")) {
				stars = stars.substring(0,stars.length()-1) + ")";
				query = "SELECT id, first_name, last_name FROM stars where id in " + stars;
				rs = stmt.executeQuery(query);
			
				while (rs.next())
				{
					star_ids.add(rs.getInt("id"));
					star_names.add(rs.getString("first_name") + " " + rs.getString("last_name"));
				}
				rs.close();
			}	
			request.setAttribute("star_ids", star_ids);
			request.setAttribute("star_names", star_names);
			
			
			query = "SELECT * from genres_in_movies WHERE movie_id =" + movie_id;
			
			rs = stmt.executeQuery(query);
			
			while (rs.next())
			{
				genres += rs.getInt("genre_id") + ",";
			}
			rs.close();
			ArrayList<Integer> genre_ids = new ArrayList<Integer>();
			ArrayList<String> genre_names = new ArrayList<String>();
			
			if (!genres.equals("(")) {
				genres = genres.substring(0,genres.length()-1) + ")";
				
				query = "SELECT id, name FROM genres where id in " + genres;
				rs = stmt.executeQuery(query);
			
			
				while (rs.next())
				{
					genre_ids.add(rs.getInt("id"));
					genre_names.add(rs.getString("name"));
				}
				rs.close();
			}
			request.setAttribute("genre_ids", genre_ids);
			request.setAttribute("genre_names", genre_names);
			
			
			rs = stmt.executeQuery("SELECT * from movies where id =" + movie_id);
			
			rs.next();
			
			request.setAttribute("movie_title", rs.getString("title"));
			request.setAttribute("movie_year", rs.getInt("year"));
			request.setAttribute("movie_director", rs.getString("director"));
			request.setAttribute("movie_trailer", rs.getString("trailer_url"));
			request.setAttribute("movie_banner", rs.getString("banner_url"));
			
			rs.close();
			stmt.close();
			connection.close();
		}
	catch (Exception e)
		{
			out.println("<div color='#ff0000'>" + e.getMessage() + stars + "</div>");
		}
	
%>

<HTML>
	<script type="text/javascript" src="autoComplete.js"> </script>	
	<link href="Style/moviepage.css" rel="stylesheet" /> 
	<title>FabFlix: ${movie_title}</title>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
<HEAD>
</HEAD>
<body>
	<div style="display: block; width: 90%; height: 50px; margin: auto;">
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
			<div class="topcorner">
		<div style="display: inline-block; font-size: 22px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
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
			<img src="${movie_banner}" alt="Image not available" >
		</th>
	</tr>
	<tr>
		<th>Title</th>
		<td>${movie_title}</td>
	</tr>
	<tr>
		<th>Year</th>
		<td>${movie_year}</td>
	</tr>
	<tr>
		<th>Director</th>
		<td>${movie_director}</td>
	</tr>
	<tr>
		<th>Movie ID</th>
		<td>${movie_id}</td>
	</tr>
	<tr>
		<th>Stars</th>
		<td>
			<%
				try {
					ArrayList<Integer> star_ids = (ArrayList<Integer>)request.getAttribute("star_ids");
					ArrayList<String> star_names = (ArrayList<String>)request.getAttribute("star_names");
					
					for(int i = 0; i < star_ids.size(); i++) {
						out.print("<a href=\"starPage?starid=" + star_ids.get(i) + "\">" + star_names.get(i) + "</a>");
						if (i < star_ids.size()-1)
							out.println(",");
					}
				}
				catch (Exception e) {
					out.println("<div color='#ff0000'>" + e.getMessage() + "</div>");
				}
			%>
		</td>
	</tr>
	<tr>
		<th>Genre</th>
		<td>
			<%
				try {
					ArrayList<Integer> genre_ids = (ArrayList<Integer>)request.getAttribute("genre_ids");
					ArrayList<String> genre_names = (ArrayList<String>)request.getAttribute("genre_names");
					
					for(int i = 0; i < genre_ids.size(); i++) {
						out.print("<a href=\"browse?genre=" + genre_ids.get(i) + "&genreClicked=true\">" + genre_names.get(i) + "</a>");
						if (i < genre_ids.size()-1)
							out.println(",");
					}
				}
				catch (Exception e) {
					out.println("<div color='#ff0000'>" + e.getMessage() + "</div>");
				}
			%>
		</td>
	</tr>
	<tr>
		<th>Trailer</th>
		<td><a href="${movie_trailer}">Link</a></td>
	</tr>
	<tr>
		<th>Price</th>
		<td><strike>$12.99</strike><font color="red"> $10.99</font color></td>
	</tr>
	<tr>
		<form name="shoppingCart" method="POST">
		<input type="HIDDEN" name="movieidtoadd">
		<%
			out.print("<td><input type=\"button\" value=\"Add To Cart\"" + "onclick=\"addCart(" + request.getAttribute("movie_id") + ")\"></td>");
		%>
		</form>
	</tr>
</table>

<SCRIPT LANGUAGE="JavaScript">
	function addCart(id)
	{
		document.shoppingCart.movieidtoadd.value = id;
		shoppingCart.submit();
	}
</SCRIPT>
</body>
</html>

