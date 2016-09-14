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


<style>
	.error {
		color: red;
	}
	
	.success {
		color: green;
	}
	
	
</style>
<html>
	<head>
		<script type="text/javascript" src="autoComplete.js"> </script>
		<title>Insert a Movie</title>
		<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
	</head>
	<body>
		<div style="display: block; width: 90%; height: 50px; margin: auto;">
			<div style="display: inline-block; font-size: 32px; width: 45%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
			<div style="display: inline-block; font-size: 32px; width: 45%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
			<div class="topcorner" style="position: absolute; top: 0px; right: 0px;">
				<div style="display: block; font-size: 16px; width: 200px; padding: 10px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
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
		out.println("<div class=\"error\">You are not authorized to view this page.</div>");
		
	if (null != request.getParameter("movieInsertion"))
		if (request.getParameter("title").equals("") || request.getParameter("director").equals("") || request.getParameter("year").equals("")
			|| request.getParameter("lName").equals("") ||request.getParameter("genre").equals(""))
			out.println("<div class=\"error\">Missing required fields.</div>");
		else
			try {
				int m_year = Integer.parseInt(request.getParameter("year"));
				String f_name = request.getParameter("fName");
				String l_name = request.getParameter("lName");
				String m_title = request.getParameter("title");
				String m_dir = request.getParameter("director");
				String m_gen = request.getParameter("genre");
				String b_url = request.getParameter("banner");
				String t_url = request.getParameter("trailer");
				
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
				
				CallableStatement cStmt = connection.prepareCall("{call add_movie(?, ?, ?, ?, ?, ?, ?, ?)}");
				cStmt.setString(1, m_title);
				cStmt.setInt(2, m_year);
				cStmt.setString(3, m_dir);
				cStmt.setString(4, b_url);
				cStmt.setString(5, t_url);
				cStmt.setString(6, f_name);
				cStmt.setString(7, l_name);
				cStmt.setString(8, m_gen);
				
				boolean hadResults = cStmt.execute();
				
				if (hadResults)
				{
					out.println("<div class=\"success\">Successfully added movie to database</div>");
					/*
						out.println("Title: " + "<br/>");
						out.println("Director: " + "<br/>")
						out.println("Year: " + "<br/>");
						out.println("Banner URL: " + "<br/>");
						out.println("Trailer URL: " + "<br/>");
						out.println("Genre:" + "<br/>");
						out.println("</div>");
					*/
				}
				else
				out.println("<div class=\"error\">Was not added to database.</div>");
				connection.close();
			}
			catch (SQLException ex)
			{
				out.println(ex);
			}
			catch (Exception e)
			{
				out.println(e);
				out.println("<div class=\"error\">Invalid.</div>");
			}
%>
	<form method="POST" action="_insertMovie">
		<div class="form-container">
			<h3><span>Enter Relevant Information:</span><br/><br></h3>
			<div class="info-input"><span style="color: red;">*</span>Movie Title:</div><input type="text" name="title"></input><br/>
			<div class="info-input"><span style="color: red;">*</span>Director:</div><input type="text" name="director"></input><br/>
			<div class="info-input"><span style="color: red;">*</span>Year:</div><input type="text" name="year"></input><br/>
			<div class="info-input">Starring: First Name:</div><input type="text" name="fName"></input><br/>
			<div class="info-input"><span style="color: red;">*</span>Starring: Last Name:</div><input type="text" name="lName"></input><br/>
			<div class="info-input"><span style="color: red;">*</span>Movie Genre:</div><INPUT TYPE="TEXT" name="genre"></input><BR/>
			<div class="info-input">Movie Banner URL:</div><INPUT TYPE="TEXT" name="banner"></input><BR/>
			<div class="info-input">Movie Trailer URL:</div><INPUT TYPE="TEXT" name="trailer"></input><BR/>
			<input type="submit" value="Insert to Database" name="movieInsertion"></input>
		</div>
	</form>
	<span style="color: red; font-size: 11px;">* Required Fields</span><br/>
	<span style="color: red; font-size: 11px;">* If a star only has one name, add it as <b>last name.</b></span>	


		<a href="_dashboard"><div>Back to Dashboard</div></a>
	</body>
</html>
