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
	
	
</style>
<html>
	<head>
		<script type="text/javascript" src="autoComplete.js"> </script>
		<title>Insert a Star</title>
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
<%!
	/**
		Functions written for usage in insertions.
	**/
	
	public boolean dateCheck(String date)
	{
		boolean check = false;
		if (date.equals("NULL"))
			return true;
		String[] parts = date.split("/");
		if (parts.length == 3)
		{
			for (String part : parts)
			{
				try{
					Integer.parseInt(part);
					check = true;
				}
				catch (Exception e)
				{
					return false;
				}
			}
		}
		return check;
	}
	
	public String dateFormat(String date)
	{
		String buffer = "'";
		String[] parts = date.split("/");
		if (parts.length == 3)
		{
			buffer += parts[2] + "/" + parts[0] + "/" + parts[1] + "'";
		}
		return buffer;
	}
%>
	
<%
	if (request.getSession().getAttribute("logged_in") == null)
		response.sendRedirect("login");
	if (!(Boolean)request.getSession().getAttribute("isAdmin"))
		out.println("<div class=\"error\">You are not authorized to view this page.</div>");
	int star_id = 0;
	boolean dupe = false;
	if (null != request.getParameter("surgicalInsertion"))
		if (request.getParameter("ID").equals(""))
			out.println("<div class=\"error\">Please enter an ID for your new star.</div>");
		else
			try {
				star_id = Integer.parseInt(request.getParameter("ID"));
				String f_name = "'" + request.getParameter("fName") + "'";
				String l_name = "'" + request.getParameter("lName") + "'";
				String d_ob = request.getParameter("dob");
				String p_url = "'" + request.getParameter("photo") + "'";
				
				/*If no last name given, set first as last name, clear first.*/
				if (!f_name.equals("''") && l_name.equals("''")){
					l_name = f_name;
					f_name = "";
				}
				if (d_ob.equals(""))
					d_ob = "NULL";
				
				if (!d_ob.equals("NULL") && !dateCheck(d_ob))
					out.println("<h1>Invalid date format.</h1>");
				else
				{
					if (!d_ob.equals("NULL"))
						d_ob = dateFormat(d_ob);
					if (p_url.equals("''"))
						p_url = "NULL";
					
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
					
					String checkQuery = "select id from stars where id = " + star_id;
					ResultSet checkRs = stmt.executeQuery(checkQuery);
					if (checkRs.next())
					{
						dupe = true;
					}
					if (dupe)
						out.println("<div class=\"error\">This ID already exists in the database.</div>");
					checkRs.close();
					if (!dupe)
					{
						String insertQuery = "insert into stars values("
							+ star_id + ", " + f_name + ", " + l_name + ", " + d_ob + ", " + p_url + ")";
						stmt.executeUpdate(insertQuery);
						out.println("<div class=\"error\">Successfully added star to database.</div>");
					}
					stmt.close();
					connection.close();
				}
			}
			catch (Exception e)
			{
				out.println(e);
				out.println("<div class=\"error\">Invalid ID.</div>");
			}
%>
	<form method="POST" action="_insert">
		<div class="form-container">
			<h3><span>Enter Relevant Information:</span><br/><br></h3>
			<div class="info-input"><span style="color: red;">* </span>ID:</div><input type="text" name="ID"></input><br/>
			<div class="info-input">First Name:</div><input type="text" name="fName"></input><br/>
			<div class="info-input">Last Name:</div><input type="text" name="lName"></input><br/>
			<div class="info-input">Date of Birth (MM/DD/YYYY):</div><input type="text" name="dob"></input><br/>
			<div class="info-input">Photo URL:</div><INPUT TYPE="TEXT" name="photo"></input><BR/>
			<input type="submit" value="Insert to Database" name="surgicalInsertion"></input>
		</div>
	</form>
	<span style="color: red; font-size: 11px;">* Required Fields</span>


		<a href="_dashboard"><div>Back to Dashboard</div></a>
	</body>
</html>
