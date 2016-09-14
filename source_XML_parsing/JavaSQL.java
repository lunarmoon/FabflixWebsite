import java.sql.*;
import java.util.Scanner;

public class JavaSQL {
	public static void main(String[] args) throws Exception
	{
		Class.forName("com.mysql.jdbc.Driver").newInstance();	
		String username, password;
		Scanner s = new Scanner(System.in);
		Connection connection;				
		
		while (true)
		{
			while (true)
			{
				System.out.print("Please enter a username: ");
				username = s.nextLine();
				
				System.out.print("Please enter a password: ");
				password = s.nextLine();
				
				
				try {
					connection = DriverManager.getConnection("jdbc:mysql:///moviedb?useAffectedRows=true", username, password);
					break;
				}
				catch (SQLException e){
					System.out.println(e.getMessage());
					System.out.println("Please try again.\n");
				}
			}
			
			MainMenu menu = new MainMenu(connection);
			menu.run();
			if (menu.getQuit())
				break;
			connection.close();
		}
		
		System.out.println("Thank you for using the moviedb management system.");
		
	}
}
