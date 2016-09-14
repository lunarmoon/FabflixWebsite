import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.List;
import java.util.ArrayList;
public class MovieDAO {
	Connection connection;
	Statement stmt;
	private int numResults;
	public MovieDAO(){
	}
	
	public List<Movie> findMovies(String firstname, String lastname, String director, String title, String year, int offset, int numResults)
	{
		String loginUser="testuser";
		String loginPswd="testpass";
		String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
		List<Movie> list = new ArrayList<Movie>();
		String query = "SELECT SQL_CALC_FOUND_ROWS * movies.id as m_id, stars.id as s_id, from movies join stars "
           		+ "where stars.last_name like '%" + lastname + "%'"
           		+ "and stars.first_name like '%" + firstname + "%'"
           		+ "and movies.director like '%" + director + "%'"
           		+ "and movies.title like '%" + title + "%'";
		if (year != "")
			query += "and movies.year = " + year;
        query += "LIMIT" + offset + ", " + numResults;
        try
        {
        	Class.forName("com.mysql.jdbc.Driver").newInstance();

            connection = DriverManager.getConnection(loginUrl, loginUser, loginPswd);
            // Declare our statement
            stmt = connection.createStatement();
            
	        ResultSet rs = stmt.executeQuery(query);
	        while (rs.next() )
	        {
	        	Movie mov = new Movie();
	        	mov.addStar(rs.getString("first_name"), rs.getString("last_name"));
	            mov.setDirector(rs.getString("director"));
	            mov.setYear(rs.getInt("year"));
	            mov.setTitle(rs.getString("title"));
	        }
        }
        catch (SQLException e) {
        	e.printStackTrace();
        }
        catch(Exception e) {
        	e.printStackTrace();
        }
        return list;
	}
	
	public int getNumRecords()
	{
		return numResults;
	}
}