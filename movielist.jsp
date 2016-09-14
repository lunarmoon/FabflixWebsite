<%@page import="java.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.io.*,
 java.net.*,
 java.text.*,
 java.util.*,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource,
 fabflix.objects.MovieObject"
 
 %>
<%@ page isELIgnored="false" %>

<%
	int pageNum = 1;
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	if (request.getParameter("movieid") != null) {
		int movieid = Integer.parseInt(request.getParameter("movieid"));
		Hashtable<Integer, Integer> movieids = new Hashtable<Integer, Integer>();
		if (request.getSession().getAttribute("cartMovieIds") != null) {
			movieids = (Hashtable<Integer, Integer>)request.getSession().getAttribute("cartMovieIds");
		}
		
		if (movieids.get(movieid) == null)
			movieids.put(movieid, 1);
		else
			movieids.put(movieid, movieids.get(movieid) + 1);
		request.getSession().setAttribute("cartMovieIds", movieids);
		if (request.getParameter("page") != null)
			pageNum = Integer.parseInt(request.getParameter("page"));
		response.sendRedirect("movielist?page=" + pageNum);
	}
%>

<html>
	<link href="Style/movielist.css" rel="stylesheet" /> 
	<head>
		<script type="text/javascript" src="autoComplete.js"> </script>
		<title>Movie Search Results</title>
		<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
	</head>
	<body>
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
		<span>Results per page: </span>
		<form method="GET">
			<select name = "numItems">
				<option value="10">10</option>
				<option value="25">25</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select>
			<input type="SUBMIT" value="Submit" name="nPPClicked"/>
		</form>
		
		<form method="GET">
			<select name = "sortType">
				<option value="Title">Title</option>
				<option value="Year">Year</option>
			</select>
			<select name="order">
				<option value="Ascend">Ascending</option>
				<option value="Descend">Descending</option>
			</select>
			<input type="SUBMIT" value="Submit" name="sortClicked"/>
		</form>
	<a href="shoppingcart">Shopping Cart</a>
	<form name="shoppingCart" method="POST">
		<input type="HIDDEN" name="movieid">
		
		<table border>
			<tr>
				<td text-align="center">Title</td>
				<td text-align="center">Year</td>
				<td text-align='center'>Director</td>
				<td text-align='center'>ID</td>
				<td text-align='center'>Genre</td>
				<td text-align='center'>Starring</td>
			</tr>
	<%
		ArrayList<MovieObject> movieObjects = (ArrayList<MovieObject>) request.getSession().getAttribute("movieObjects");
		String sortType = "Title";
		String order = "Ascend";
		if (request.getParameter("sortClicked") != null)
		{
			sortType = request.getParameter("sortType");
			order = request.getParameter("order");
		}
		if (sortType.equals("Year"))
		{
			if (order.equals("Ascend")) {
				Collections.sort(movieObjects, new Comparator<MovieObject>() {
					public int compare(MovieObject one, MovieObject other) {
						return Integer.compare(one.getYear(),other.getYear());
					}
				}); 
			}
			else if (order.equals("Descend")) {
				Collections.sort(movieObjects, new Comparator<MovieObject>() {
					public int compare(MovieObject one, MovieObject other) {
						return Integer.compare(other.getYear(),one.getYear());
					}
				}); 
			}
		}
		
		else if (sortType.equals("Title"))
		{
			if (order.equals("Ascend")) {
				Collections.sort(movieObjects, new Comparator<MovieObject>() {
					public int compare(MovieObject one, MovieObject other) {
						return one.getTitle().compareTo(other.getTitle());
					}
				}); 
			}
			else if (order.equals("Descend")) {
				Collections.sort(movieObjects, new Comparator<MovieObject>() {
					public int compare(MovieObject one, MovieObject other) {
						return other.getTitle().compareTo(one.getTitle());
					}
				}); 
			}
		}
		int numPerPage = 10;
		if (request.getParameter("numItems") != null)
			numPerPage = Integer.parseInt(request.getParameter("numItems"));
		int maxPages = (int) Math.ceil((double) movieObjects.size() / (double) numPerPage);
		out.println("There are " + maxPages + " pages.  You have " + movieObjects.size() + " results.  Currently showing "
			+ numPerPage + " results per page.");
		pageNum = 1;
		if (request.getParameter("page") != null)
			pageNum = Integer.parseInt(request.getParameter("page"));
		int resStart = (pageNum-1) * numPerPage;
		int resEnd = resStart + numPerPage;
		if (resEnd > movieObjects.size())
			resEnd = movieObjects.size();
		if (movieObjects.size() > 0)
		{
			if (resStart < movieObjects.size())
			{
				for (int k = resStart; k < resEnd; k++) {
					MovieObject mv = movieObjects.get(k);
					out.print("<tr>"
					+ "<td text-align=center>" + "<a href=\"moviePage?movieid=" + mv.getId() + "\" onmouseout=\"hoverImageExit(this)\"onmouseover=\"hoverImage(this, " + mv.getId() + ")\">" + mv.getTitle() + "</a>" + "</td>"
					+ "<td text-align=center>" + mv.getYear() + "</td>"
					+ "<td text-align=center>" + mv.getDirector() + "</td>"
					+ "<td text-align=center>" + mv.getId() + "</td>"
					+ "<td text-align=center>");
					ArrayList<String> genres = mv.getGenres();
					for (int i = 0; i < genres.size(); i++) {
						out.print(genres.get(i));
						if (i < genres.size()-1)
							out.print(", ");
					}
					out.print("</td>" + "<td text-align=center>");
					
					ArrayList<String> star_names = mv.getStarNames();
					ArrayList<Integer> star_ids = mv.getStarIds();
					
					for (int i = 0; i < star_names.size(); i++)
					{
						out.print("<a href=\"starPage?starid=" + star_ids.get(i) + "\">" + star_names.get(i) + "</a>");
						if (i < star_names.size()-1)
							out.print(", ");
					}
					
					out.print("</td>");
					out.print("<td><input type=\"button\" value=\"Add To Cart\"" + "onclick=\"addCart(" + mv.getId() + ")\"></td>");
					
					out.println("</tr>");
				}
			}
		}			
	%>
		</table>
	</form>
	
	<table>
		<tr>
		<%
			String prevP = "movielist?page=" + (pageNum-1);
			String nextP = "movielist?page=" + (pageNum+1);
			if ((pageNum-1) > 0)
				out.println("<td name=&quot;prevClicked&quot; value=&quot;prev&quot;><a href =" + prevP + " >Previous</a></td>");
			if ((pageNum+1) <= maxPages)
				out.println("<td name=&quot;nextClicked&quot; value=&quot;next&quot;><a href =" + nextP + " >Next</a></td>");
		%>
		</tr>
	</table>
	<SCRIPT LANGUAGE="JavaScript">
        function addCart(id)
        {
            document.shoppingCart.movieid.value = id;
            shoppingCart.submit();
        }
		function hoverImageExit(node)
        {
			var infoDiv = document.getElementsByClassName("currentMovieInfo")[0]
			infoDiv.innerHTML = "";
			infoDiv.style.borderStyle = "";
        }
    </SCRIPT>
	
		<SCRIPT LANGUAGE="JavaScript">
        function hoverImage(node, id)
        {
			var ajaxRequest;  // The variable that makes Ajax possible!

			try{
				// Opera 8.0+, Firefox, Safari
				ajaxRequest = new XMLHttpRequest();
			} catch (e){
				// Internet Explorer Browsers
				try{
					ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e) {
					try{
						ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
					} catch (e){
						// Something went wrong
						alert("Your browser broke!");
						return false;
					}
				}
			}
			// Create a function that will receive data sent from the server
			ajaxRequest.onreadystatechange = function(){
				if(ajaxRequest.readyState == 4){
					var rect = node.getBoundingClientRect();
					var infoDiv = document.getElementsByClassName("currentMovieInfo")[0];
					infoDiv.innerHTML = ajaxRequest.responseText;
					infoDiv.style.top = rect.top + 20;
					infoDiv.style.left = rect.left + 40;
					infoDiv.style.borderStyle = "solid";
				}
			}
			
			ajaxRequest.open("GET", "servlet/movieHover?movieId=" + id, true);
			ajaxRequest.send(null);
        }
    </SCRIPT>
	
	<div class="currentMovieInfo" style="position: fixed; background: gray">
	</div>
	</body>
</html>
