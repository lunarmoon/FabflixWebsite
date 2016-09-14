

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class MovieSearch
 */
public class MovieSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private static int start;
    private static int resultsPerPage;
    public MovieSearch() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String loginUser="testuser";
		String loginPswd="testpass";
		String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
        response.setContentType("text/html"); 
		PrintWriter out = response.getWriter();
		
        out.println("<HTML><HEAD><TITLE>MovieDB</TITLE></HEAD>");
        out.println("<BODY><H1>MovieDB</H1>");
		
		String firstname = request.getParameter("fName");
		String lastname = request.getParameter("lName");
		String director = request.getParameter("director");
		String title = request.getParameter("title");
		String year = request.getParameter("year");
		
		int start = 0;
		int end = 0;
		int page = 1;
		resultsPerPage=20;
		int offset = 0;
		if (request.getParameter("page") != null)
			page = Integer.parseInt(request.getParameter("page"));
		offset = (page - 1) * resultsPerPage;
		//List<Movie> list = new ArrayList<Movie>();
		String query = "SELECT *, movies.id as m_id, stars.id as s_id from movies inner join stars inner join stars_in_movies "
           		+ "where stars.last_name like '%" + lastname + "%'"
           		+ "and stars.first_name like '%" + firstname + "%'"
           		+ "and movies.director like '%" + director + "%'"
           		+ "and movies.title like '%" + title + "%'";
		String rowCountQuery = "SELECT count(*) as total from movies inner join stars inner join stars_in_movies "
           		+ "where stars.last_name like '%" + lastname + "%'"
           		+ "and stars.first_name like '%" + firstname + "%'"
           		+ "and movies.director like '%" + director + "%'"
           		+ "and movies.title like '%" + title + "%'";
		if (year != "")
		{
			query += "and movies.year = " + year;
			rowCountQuery += "and movies.year = " + year;
		}
		query += "LIMIT " + resultsPerPage + " OFFSET " + offset;
        try
        {
        	Class.forName("com.mysql.jdbc.Driver").newInstance();

            Connection connection = DriverManager.getConnection(loginUrl, loginUser, loginPswd);
            // Declare our statement
            Statement stmt = connection.createStatement();
            Statement stmt2 = connection.createStatement();
            
	        ResultSet rCount = stmt2.executeQuery(rowCountQuery);
	        //int totalResults = rCount.getInt("total");
	        ResultSet rs = stmt.executeQuery(query);
        	out.println("<table>");

	        while (rs.next() )
	        {
	        	String m_fn = rs.getString("first_name");
	        	String m_ln = rs.getString("last_name");
	        	String m_dir = rs.getString("director");
	        	String m_title = rs.getString("title");
	        	out.println("<tr>");
	        	out.println("<td>" + m_fn + "</td>");
	        	out.println("<td>" + m_ln + "</td>");
	        	out.println("<td>" + m_dir + "</td>");
	        	out.println("<td>" + m_title + "</td>");
	        	out.println("</tr>");
	        }
	        out.println("</table>");
	        out.println("<br/><br/><br/><br/>");
	        out.println("<a href='movielist?"
	        		+ "fName=" + firstname
	        		+ "&lName=" + lastname
	        		+ "&director=" + director
	        		+ "&title=" + title
	        		+ "&year="+ year + "&page=" + (page + 1) + "'>Next</a>");
	        out.println("</body></html>");
	        rs.close();
        }
        catch (SQLException e) {
        	e.printStackTrace();
        }
        catch(Exception e) {
        	e.printStackTrace();
        }
		
		/*MovieDAO dao = new MovieDAO();
		List<Movie> list = dao.findMovies(firstname, lastname, director, title, year, (page-1)*resultsPerPage, resultsPerPage);
		int numResults = dao.getNumRecords();
		int numPages = (int) Math.ceil(numResults * 1.0 / resultsPerPage);
		
		request.setAttribute("movieList", list);
		request.setAttribute("numPages", numPages);
		request.setAttribute("currentPage", page);
		RequestDispatcher view = request.getRequestDispatcher("display.jsp");
		view.forward(request,  response);*/
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}
}
