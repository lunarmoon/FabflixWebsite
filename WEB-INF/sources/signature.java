
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;


public class signature extends HttpServlet
{
    public String getServletInfo()
    {
       return "Submission servlet";
    }

// Use http GET         
public void doGet(HttpServletRequest    request,  HttpServletResponse    response)
	 throws  IOException, ServletException                            {
			  // Output stream to STDOUT
			  PrintWriter    out = response.getWriter();
			  out.println(SignatureReader.getSignature("C:\\apache-tomcat-8.0.30\\webapps\\FabFlix\\"));
			  out.close();
	 }
}