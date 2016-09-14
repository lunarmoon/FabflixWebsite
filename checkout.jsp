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
 java.util.Date,
 java.util.Hashtable,
 java.util.Enumeration,
 javax.sql.DataSource,
 fabflix.objects.MovieObject"
 
 %>
<%@ page isELIgnored="false" %>

<%
    if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");

	if (null != request.getParameter("checkoutClicked"))
	{
		boolean checkedOut = false;
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
			String lastname = request.getParameter("lName");
			String ccNum = request.getParameter("ccNum");
			String expYear = request.getParameter("expYear");
			String expMonth = request.getParameter("expMonth");
			String expDay = request.getParameter("expDay");

			String query = "SELECT * FROM creditcards WHERE "
					+ "id = '" + ccNum + "' AND "
					+ "first_name = '" + firstname + "' AND "
					+ "last_name = '" + lastname + "' AND "
					+ "expiration = '" + expYear + "-" + expMonth + "-" + expDay + "'";
					
			ResultSet rs = stmt.executeQuery(query);
			
			if (rs.next())
			{
				query = "SELECT * from customers "
											+"WHERE first_name = '" + firstname + "' AND " 
											+"last_name = '" + lastname + "' AND "
											+"cc_id = '" + ccNum + "'";
				rs = stmt.executeQuery(query);
				if (rs.next())
				{
					DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					Date dateobj = new Date();
					int customer_id = rs.getInt("id");
					Hashtable<Integer, Integer> movieAmounts = (Hashtable<Integer, Integer>) request.getSession().getAttribute("cartMovieIds");
					Enumeration ids = movieAmounts.keys();
					while (ids.hasMoreElements())
					{
						int id = (Integer)ids.nextElement();
						for (int i = 0; i < movieAmounts.get(id); i++) {
							query = String.format("INSERT INTO sales VALUES(NULL, %d, %d, '%s')", customer_id, id, df.format(dateobj));
							stmt.executeUpdate(query);
							out.println(query);
						}
					}
					
					request.getSession().setAttribute("cartMovieIds", null);
					checkedOut = true;
				}
			}
			
			
			rs.close();
			stmt.close();
			connection.close();
			if (checkedOut)
				response.sendRedirect("home");
			else
				request.setAttribute("errorMessage", "Wrong Customer Info. Please try again.");
		}
		catch (Exception e)
		{
			out.println("<div color='#ff0000'>Could not complete query. " + e.getMessage() + "</div>");
		}
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
		<link href="Style/shoppingcart.css" rel="stylesheet" /> 
<HEAD>
  <TITLE>Checkout</TITLE>
        <script type="text/javascript" src="autoComplete.js"> </script>
</HEAD>

<BODY>
<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
<H1 ALIGN="CENTER">Checkout</H1>
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
<div style="color:red">${errorMessage}</div>
<FORM
      METHOD="POST">
	  <span>Criteria</span><br/>
	  First Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="fName"></input><br/>
	  Last Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="lName"></input><br/>
	  Credit Card:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="ccNum"></input><br/>
	  Expiration Year:&nbsp;&nbsp;<input type="text" name="expYear"></input><br/>
	  Expiration Month:<input type="text" name="expMonth"></input><br/>
	  Expiration Day:&nbsp;&nbsp;&nbsp;<input type="text" name="expDay"></input><br/>
  <CENTER>
    <INPUT TYPE="SUBMIT" VALUE="Submit" name="checkoutClicked">
  </CENTER>
</FORM>

</BODY>
</HTML>
