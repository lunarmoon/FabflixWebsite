import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionManager {

	private static String username = "classta";
	private static String password = "classta";
	private static Connection sessionConnection;
	
	public static Connection getSessionConnection() throws Exception
	{
		if (sessionConnection == null || sessionConnection.isClosed())
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			sessionConnection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb_project4_grading?useSSL=false", username, password);
		}
		
		return sessionConnection;
	}
	
	public static void closeSessionConnection() throws Exception
	{
		if (sessionConnection != null && !sessionConnection.isClosed())
		{
			sessionConnection.close();
			sessionConnection = null;
		}
	}

	public String getUsername() 
	{
		return username;
	}

	public String getPassword() 
	{
		return password;
	}
}
