<%@page import="java.sql.*,
javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 javax.naming.InitialContext,
 javax.naming.Context,
 java.io.*,
 java.net.*,
 java.text.*,
 java.util.ArrayList,
 javax.sql.DataSource,
 fabflix.objects.MovieObject"
 
 %>
<%@ page isELIgnored="false" %>

<%
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");

	if (null != request.getParameter("searchClicked"))
	{
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
			  
			Statement stmt = connection.createStatement();
			String firstname = request.getParameter("fName");
				if (firstname == null)
					firstname = "";
			String lastname = request.getParameter("lName");
				if (lastname == null)
					lastname = "";
			String title = request.getParameter("title");
				if (title == null)
					title = "";
			String director = request.getParameter("director");
				if (director == null)
					director = "";
			String year = request.getParameter("year");
				if (year == null)
					year = "";	
			String order = "title";

			String findYear;
			if (year == "")
				findYear = "year > 0";
			else
				findYear = "year = " + year;
			
			String query = "select distinct "
				+ "stars_in_movies.star_id, stars_in_movies.movie_id, title, year, director, genres.name as genre, banner_url, trailer_url, first_name, last_name, dob, photo_url "
				+ "from stars inner join stars_in_movies on stars.id = stars_in_movies.star_id "
				+ "join movies on stars_in_movies.movie_id = movies.id "
				+ "join genres_in_movies on genres_in_movies.movie_id = movies.id "
				+ "join genres on genres_in_movies.genre_id = genres.id";
			
			query = "select pr.* from (" + query + ") as pr where first_name like '%" + firstname + "%'";
			query = "select ps.* from (" + query + ") as ps where last_name like '%" + lastname + "%'";
			query = "select pt.* from (" + query + ") as pt where title like '%" + title + "%'";
			query = "select qr.* from (" + query + ") as qr where director like '%" + director + "%'";
			query = "select qs.* from (" + query + ") as qs where " + findYear;
			query += " order by " + order;
			
			ResultSet rs = stmt.executeQuery(query);
			ArrayList<MovieObject> movieObjects = new ArrayList<MovieObject>();
			while(rs.next())
			{
				boolean foundFlag = false;
				boolean snFlag = false;
				boolean sidFlag = false;
				boolean genFlag = false;
				int mov_id = rs.getInt("movie_id");
				String m_title = rs.getString("title");
				int m_year = rs.getInt("year");
				String m_director = rs.getString("director");
				String m_fn = rs.getString("first_name");
				String m_ln = rs.getString("last_name");
				int star_id = rs.getInt("star_id");
				String genre = rs.getString("genre");
				
				for (int i = 0; i < movieObjects.size(); i++)
				{
					if (movieObjects.get(i).getId() == mov_id)
					{
						for (String sn : movieObjects.get(i).getStarNames())
							if (sn.equals(m_fn + " " + m_ln))
								snFlag = true;
						for (int sid : movieObjects.get(i).getStarIds())
							if (sid == star_id)
								sidFlag = true;
						for (String gen : movieObjects.get(i).getGenres())
							if (gen.equals(genre))
								genFlag = true;
						if (!snFlag)
							movieObjects.get(i).addStarName(m_fn + " " + m_ln);
						if (!sidFlag)
							movieObjects.get(i).addStarId(star_id);
						if (!genFlag)
							movieObjects.get(i).addGenre(genre);
						foundFlag = true;
					}
				}
				if (!foundFlag)
				{
					movieObjects.add(new MovieObject(mov_id, m_title, m_year, m_director));
					movieObjects.get(movieObjects.size() -1).addStarName(m_fn + " " + m_ln);
					movieObjects.get(movieObjects.size() -1).addStarId(star_id);
					movieObjects.get(movieObjects.size() -1).addGenre(genre);
				}
			}
			rs.close();
			stmt.close();
			connection.close();
			
			request.getSession().setAttribute("movieObjects", movieObjects);
			response.sendRedirect("movielist?page=1");
		}
		catch (Exception e)
		{
			out.println("<div color='#ff0000'>Could not complete query.</div>");
		}
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
		<link href="Style/search.css" rel="stylesheet" /> 
<HEAD>
	<script type="text/javascript" src="autoComplete.js"> </script>
  <TITLE>FabFlix: Search for Movies</TITLE>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
</HEAD>
<div class="topcorner">
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart"><font color="white">Shopping Cart</font color></a></div></div>
<BODY>
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
<H1 ALIGN="CENTER"><font color="white">Search Movie Database</font color></H1>
<FORM 
      METHOD="GET">
	  <h2><span>Enter Relevant Information:</span><br/><br></h2>
	  First Name:&nbsp;<input type="text" name="fName"></input><br/>
	  Last Name:&nbsp;<input type="text" name="lName"></input><br/>
	  Director:&nbsp;&nbsp; &nbsp; <input type="text" name="director"></input><br/>
	  Movie Title:<input type="text" name="title"></input><br/>
	  Year Made:&nbsp;<INPUT TYPE="TEXT" name="year"></input><BR/>
	  <input type="hidden" name="page" value="1"></input>
  <CENTER>
    <INPUT TYPE="SUBMIT" VALUE="Submit Search" name="searchClicked">
  </CENTER>
</FORM>
</body>
</BODY>
</HTML>
