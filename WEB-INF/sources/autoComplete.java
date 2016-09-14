import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.ArrayList;
import javax.sql.*;
import java.sql.*;
import javax.naming.InitialContext;
import javax.naming.Context;
import fabflix.objects.MovieObject;

public class autoComplete extends HttpServlet {

  public void doGet(HttpServletRequest req, HttpServletResponse res)
                               throws ServletException, IOException {
	String[] tokens = ((String)req.getParameter("query")).split(" ");
	
	String query = "select * from movies where movies.title like ";
	int i = 0;
	if (i < tokens.length - 1)
		query += "'" + tokens[i] + " %' or movies.title like '% " + tokens[i] + "' or movies.title like " + "'% " + tokens[i] + " %'";
	else
		query += "'% " + tokens[i] + "%'";
	String alias = "a";
	for (i = 1; i < tokens.length; i++)
	{
		query = "select " + alias + ".* from (" + query + ") as " + alias + " where " + alias + ".title like ";
		if (i < tokens.length - 1)
			query += "'" + tokens[i] + " %' or " + alias + ".title like '% " + tokens[i] + "' or " + alias + ".title like '% " + tokens[i] + " %'";
		else
			query += "'% " + tokens[i] + "%'";
		alias += "a";
	}
	query += " LIMIT 4";
	try {
	    Context initCtx = new InitialContext();
		 if (initCtx == null) System.out.println ("initCtx is NULL");
	   
	   Context envCtx = (Context) initCtx.lookup("java:comp/env");
		if (envCtx == null) System.out.println ("envCtx is NULL");
		
	   // Look up our data source
	   DataSource ds = (DataSource) envCtx.lookup("jdbc/moviedbpool");

		if (ds == null)
		   System.out.println ("ds is null.");

		  Connection connection = ds.getConnection();
		if (connection == null)
		   System.out.println ("dbcon is null.");
				  
		Statement stmt = connection.createStatement();
		ArrayList<MovieObject> movieObjects = new ArrayList<MovieObject>();
		ResultSet rs = stmt.executeQuery(query);
		while (rs.next())
		{
			int mov_id = rs.getInt("id");
			String m_title = rs.getString("title");
			int m_year = rs.getInt("year");
			String m_director = rs.getString("director");
			movieObjects.add(new MovieObject(mov_id, m_title, m_year, m_director));
		}
		
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();
		for (int j = 0; j < movieObjects.size(); j++)
		{
			out.println("<li style=\"border: 1px solid black;\"><a href=\"moviePage?movieid="+ movieObjects.get(j).getId() + "\">" + movieObjects.get(j).getTitle() + "</a></li>");
		}
		
		rs.close();
		stmt.close();
		connection.close();
		
	}
	catch (Exception e) {
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();
		out.println(e.getMessage());
		out.println(query);
	}



    //out.println("Hello World" + Calendar.getInstance().get(Calendar.SECOND));
  }
}

