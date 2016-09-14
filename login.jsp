<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource,
 fabflix.objects.VerifyUtils"
%>

<%@ page isELIgnored="false" %>

<%
    if (null != request.getParameter("loginClicked"))
	{
		String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		boolean valid = VerifyUtils.verify(gRecaptchaResponse);
		if (!valid) {
			String errorString = "Captcha invalid!";
			request.setAttribute("errorMessage", errorString);
		}
		else {
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
				  
				Statement select = connection.createStatement();
				String password = request.getParameter("password");
				String email = request.getParameter("email");
				ResultSet employeeRS = select.executeQuery("SELECT * from employees where email = '" + email + "'" + "and password = '" + password + "'");
				if (employeeRS.next()) {
					request.getSession().setAttribute("logged_in", true);
					request.getSession().setAttribute("isAdmin", true);
					employeeRS.close();
					select.close();
					connection.close();
					response.sendRedirect("_dashboard");
				}
				else {
					employeeRS.close();
					ResultSet rs = select.executeQuery("SELECT * from customers where email = '" + email + "'" + "and password = '" + password +"'");
					if (rs.next()) {
						request.getSession().setAttribute("logged_in", true);
						request.getSession().setAttribute("isAdmin", false);
						rs.close();
						select.close();
						connection.close();
						response.sendRedirect("home");
					}
					else
						request.setAttribute("errorMessage", "Wrong credentials");
				}
			}
			catch (Exception e){
				//do nothing
			}
		}
	}
%>
<HTML>
<HEAD>
	<link href="Style/login.css" rel="stylesheet" /> 
	<title>FabFlix: Login</title>
	<div ALIGN="CENTER" style="font-size: 50px; width: 100%;"><a href="home">FabFlix</a></div>
	<script src='https://www.google.com/recaptcha/api.js'></script>
</HEAD>
<Body>
	<div style="display: block; width: 90%; height: 50px; margin: auto;">
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="search">Search</a></div>
		<div style="display: inline-block; font-size: 32px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="browse">Browse</a></div>
			<div class="topcorner">
		<div style="display: inline-block; font-size: 22px; width: 25%; padding: 0px 18px 0px 18px; text-align: center;"><a href="shoppingcart">Shopping Cart</a></div>
	</div>
	</div>
<H1 ALIGN="CENTER" class="pagename" id="login">Login</H1>
<div style="color:red">${errorMessage}</div>
<p>
	<DIV class="login">
	<FORM
      METHOD="POST">
      	<CENTER>
      		<div id = "formLabels">
	  			<label>Email: <INPUT TYPE="text" NAME="email"></label><BR><BR>
			 	<label>Password: <INPUT TYPE="password" NAME="password"></label><BR><BR>
			    <INPUT TYPE="SUBMIT" name="loginClicked">
		    </div>
		  </CENTER>
		<div class="g-recaptcha" data-sitekey="6Lf4WBgTAAAAAMTGX_-nuVeFGPjYwaDf1WHYxQwS"></div>
</FORM>
	</DIV>
</p>



</body>
</html>

