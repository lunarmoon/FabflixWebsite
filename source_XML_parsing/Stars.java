import java.sql.*;
import java.util.ArrayList;
import java.util.Map;

import javax.sql.*;

import java.io.IOException;

import javax.servlet.*;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

public class Stars {
	public String firstName;
	public String lastName;
	public String dob;
	public String photo_url = null;
	public Stars(ArrayList<String> realName){
		this.firstName = realName.get(0);
		this.firstName = this.firstName.replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ");
		this.lastName = realName.get(1);
		this.lastName = this.lastName.replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ");
		
		if(realName.get(2) == "" || realName.get(2) == null){
			this.dob = null;
		}
		else{
		this.dob = realName.get(2) + "-01-01";
		}
		try{
			int x = Integer.parseInt(realName.get(2));
		}
		catch(Exception e){
			this.dob = null;
		}
	}

	public void addStars(){
		try
		{
			Context initCtx = new InitialContext();
             if (initCtx == null) System.out.println ("initCtx is NULL");
		   
	       Context envCtx = (Context) initCtx.lookup("java:comp/env");
            if (envCtx == null) System.out.println ("envCtx is NULL");
			
	       // Look up our data source
	       DataSource ds = (DataSource) envCtx.lookup("jdbc/moviedb");

			if (ds == null)
			   System.out.println ("ds is null.");
      
			  Connection connection = ds.getConnection();
			if (connection == null)
              System.out.println ("dbcon is null.");
		  
			Statement stmt = connection.createStatement();
			String query = "SELECT star_id from stars_in_movies WHERE star_id = 911";
			ResultSet rs = stmt.executeQuery(query);
			int example = rs.getInt(0);
			System.out.println(Integer.toString(example));
			
		}
		catch(Exception e){
			System.out.println("Error: " + e.getMessage());
		}
	}
	void setUpEnvironment(ProcessBuilder builder) {
	    Map<String, String> env = builder.environment();
	    
	}
}
