import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import com.mysql.jdbc.ResultSetMetaData;


public class QueryWriter {
	private Connection conn;
	private HashMap<String,String> library;
	
	public QueryWriter () {
		try
		{
			conn = ConnectionManager.getSessionConnection();
			//conn.setCatalog("moviedb");
			conn.setCatalog("moviedb_project4_grading");
			conn.setAutoCommit(true);
			
		}
		catch (Exception e) {
			System.out.println(e);
		}
		library = new HashMap<String, String>();
	}
	
	public int writeStar(Stars star){
		PreparedStatement ps;
		int id = -1;
		try {
			Statement select = conn.createStatement();
			ResultSet rs = select.executeQuery("SELECT id from stars where first_name = '" + star.firstName + "' and last_name = '" + star.lastName+"'");
			
			ResultSetMetaData rsmd = (ResultSetMetaData) rs.getMetaData();
			while(rs.next()){
				for(int i =1; i <= rsmd.getColumnCount();i++){
					id = Integer.parseInt(rs.getString(i));
				}
			}
			if(id == -1){
				if(star.dob != null){
				ps = conn.prepareStatement("INSERT INTO stars values(null,'" + star.firstName + "','" + star.lastName + "','" + star.dob + "',null);" );
				}
				else{
					ps = conn.prepareStatement("INSERT INTO stars values(null,'" + star.firstName + "','" + star.lastName + "'," + star.dob + ",null);" );
				}
				ps.execute();
				rs = ps.getResultSet();

				rs = select.executeQuery("SELECT id from stars where first_name = '" + star.firstName + "' and last_name = '" + star.lastName +"'");
				rsmd = (ResultSetMetaData) rs.getMetaData();
				while(rs.next()){
					for(int i =1; i <= rsmd.getColumnCount();i++){
						id = Integer.parseInt(rs.getString(i));
					}
				}
			}
			else{

			}

		} catch (Exception e) {
			//System.out.println(star.firstName + " " + star.lastName);
			System.out.println(e);
		}

		return id;
	}
	public void writeStarsInMovies(int actorID, int movieID){
		PreparedStatement ps;
		int id = -1;
		try {
			Statement select = conn.createStatement();
			ResultSet rs = select.executeQuery("SELECT star_id from stars_in_movies where star_id= " + actorID + " and movie_id = " + movieID +";");
			ResultSetMetaData rsmd = (ResultSetMetaData) rs.getMetaData();
			while(rs.next()){
				for(int i =1; i <= rsmd.getColumnCount();i++){
					id = Integer.parseInt(rs.getString(i));
				}
			}
			if(id == -1){
				ps = conn.prepareStatement("INSERT INTO stars_in_movies values(" + actorID + "," + movieID + ");" );
				ps.execute();
				rs = ps.getResultSet();

				}
			
		} catch (Exception e) {
			//System.out.println(e);
			//System.out.println(actorID + " " + movieID + " ");
		}
	}
	
	public void writeGenresInMovies(int genreID, int movieID){
		PreparedStatement ps;
		int id = -1;
		try {
			Statement select = conn.createStatement();
			ResultSet rs = select.executeQuery("SELECT genre_id from genres_in_movies where genre_id= " + genreID + " and movie_id = " + movieID +";");
			ResultSetMetaData rsmd = (ResultSetMetaData) rs.getMetaData();
			while(rs.next()){
				for(int i =1; i <= rsmd.getColumnCount();i++){
					id = Integer.parseInt(rs.getString(i));
				}
			}
			if(id == -1){
				ps = conn.prepareStatement("INSERT INTO genres_in_movies values(" + genreID + "," + movieID + ");" );
				ps.execute();
				rs = ps.getResultSet();
				}
			
		} catch (Exception e) {
			System.out.println(e);
			//System.out.println(genreID + " " + movieID);
		}
	}	
	public int writeMovie(Movie movie){
		PreparedStatement ps;
		int id = -1;
		try {
			Statement select = conn.createStatement();
			ResultSet rs = select.executeQuery("SELECT id from movies where title= '" + movie.title + "' and director = '" + movie.director +"'");
			ResultSetMetaData rsmd = (ResultSetMetaData) rs.getMetaData();
			while(rs.next()){
				for(int i =1; i <= rsmd.getColumnCount();i++){
					id = Integer.parseInt(rs.getString(i));
				}
			}
			if(id == -1){
				ps = conn.prepareStatement("INSERT INTO movies values(null,'" + movie.title + "'," + movie.year + ",'" + movie.director + "',null,null);" );
				ps.execute();
				rs = ps.getResultSet();

				rs = select.executeQuery("SELECT id from movies where title= '" + movie.title + "' and director = '" + movie.director +"'");
				rsmd = (ResultSetMetaData) rs.getMetaData();
				while(rs.next()){
					for(int i =1; i <= rsmd.getColumnCount();i++){
						id = Integer.parseInt(rs.getString(i));
					}
				}
			}
		} catch (Exception e) {
			//System.out.println(e);
			//System.out.println(movie.title + " " + movie.year + " " + movie.director);
		}

		return id;
	}
	
	public int writeGenre(String genre){
		PreparedStatement ps;
		int id = -1;
		try {
			Statement select = conn.createStatement();
			ResultSet rs = select.executeQuery("SELECT id from genres where name= '" + genre.replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ") + "'");
			ResultSetMetaData rsmd = (ResultSetMetaData) rs.getMetaData();
			while(rs.next()){
				for(int i =1; i <= rsmd.getColumnCount();i++){
					id = Integer.parseInt(rs.getString(i));
				}
			}
			if(id == -1){
				ps = conn.prepareStatement("INSERT INTO genres values(null,'" + genre.replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ") + "')");
				ps.execute();
				rs = ps.getResultSet();

				rs = select.executeQuery("SELECT id from genres where name= '" + genre.replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ") + "'");
				rsmd = (ResultSetMetaData) rs.getMetaData();
				while(rs.next()){
					for(int i =1; i <= rsmd.getColumnCount();i++){
						id = Integer.parseInt(rs.getString(i));
					}
				}
			}
		} catch (Exception e) {
			System.out.println(e);
			//System.out.println(movie.title + " " + movie.year + " " + movie.director);
		}

		return id;
	}

}
