import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;


public class MainMenu {
	private String menu =	  "1: Search for movies featuring a star\n"
							+ "2: Add a star\n"
							+ "3: Add a customer\n"
							+ "4: Delete a customer\n"
							+ "5: Display database metadata\n"
							+ "6: Execute SQL Command\n"
							+ "7: Logout\n"
							+ "8: Exit\n"
							+ "Please choose an action: ";
	private Connection connection;
	private boolean quit;
	private Scanner s;
	
	
	public MainMenu(Connection c)
	{
		s = new Scanner(System.in);
		connection = c;
		quit = false;
	}
	
	public boolean getQuit()
	{
		return quit;
	}
	
	public void run()
	{
		int option = -1;
		while(option != 7 && option != 8)
		{
			System.out.print(menu);
			option = s.nextInt();
			s.nextLine();
			
			switch(option)
			{
				case 1:
					searchForMovie();
					break;
				case 2:
					addStar();
					break;
				case 3:
					addCustomer();
					break;
				case 4:
					deleteCustomer();
					break;
				case 5:
					displayMetadata();
					break;
				case 6:
					executeSQLCommand();
					break;
				case 7:
					logout();
					break;
				case 8:
					quitProgram();
					break;
				default:
					System.out.println("Please try again.");
					break;
			}
		}
	}
	
	public void searchForMovie()
	{
		try {
			Statement select = connection.createStatement();
			
			System.out.print("Please enter the first name of the star: ");
			String firstName = s.nextLine();
			System.out.print("Please enter the last name of the star: ");
			String lastName = s.nextLine();
			System.out.print("Please enter the ID of the star if known (Enter -1 if not known): ");
			int ID = s.nextInt();
			s.nextLine();
			ResultSet result = select.executeQuery("SELECT movies.* "
														+ "FROM movies "
															+ "JOIN stars_in_movies "
																+ "ON movies.id = stars_in_movies.movie_id "
															+ "JOIN stars "
																+ "ON stars_in_movies.star_id = stars.id "
														+ "WHERE stars.first_name = '" + firstName
														+ "' OR stars.last_name = '" + lastName
														+ "' OR stars.id = " + ID);
			while (result.next())
			{
				System.out.println("ID: " + result.getInt(1));
                System.out.println("Title: " + result.getString(2));
                System.out.println("Year: " + result.getInt(3));
                System.out.println("Director: " + result.getString(4));
                System.out.println("Banner URL: " + result.getString(5));
                System.out.println("Trailer URL: " + result.getString(6));
                System.out.println();
			}
		}
		catch (SQLException e) {
			System.out.println(e.getMessage());
		}
		
	}
	
	public void addStar()
	{
		String values = "VALUES (NULL, ";
		System.out.print("Please enter the first name of the star: ");
		values += "'" + s.nextLine() + "', ";
		System.out.print("Please enter the last name of the star: ");
		values += "'" + s.nextLine() + "', ";
		
		System.out.print("Date of birth known (Y/N)? ");
		String answer = s.nextLine();
		if (answer.replace(" ", "").equalsIgnoreCase("Y"))
		{
			System.out.print("Please enter the date (YYYY-MM-DD): ");
			values += "'" + s.nextLine() + "', ";
		}
		else
		{
			values += "NULL, ";
		}
		
		System.out.print("Photo URL known (Y/N)? ");
		answer = s.nextLine();
		if (answer.replace(" ", "").equalsIgnoreCase("Y"))
		{
			System.out.print("Please enter the photo URL: ");
			values += "'" + s.nextLine() + "'";
		}
		else
		{
			values += "NULL";
		}
		
		values += ")";	
		try {
			Statement stmt = connection.createStatement();
			String sql = "INSERT INTO stars " + values;
			stmt.executeUpdate(sql);
			
			System.out.println("Star Inserted");
		}
		catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void addCustomer()
	{
		System.out.print("Please enter the first name of the customer: ");
		String firstName =  s.nextLine();
		System.out.print("Please enter the last name of the customer: ");
		String lastName =  s.nextLine();
		System.out.print("Please enter the credit card number of the customer: ");
		String ccid =  s.nextLine();
		System.out.print("Please enter the address of the customer: ");
		String address =  s.nextLine();
		System.out.print("Please enter the email of the customer: ");
		String email =  s.nextLine();
		System.out.print("Please enter the password of the customer: ");
		String password =  s.nextLine();
		
		try {
			Statement select = connection.createStatement();
			ResultSet result = select.executeQuery("SELECT * FROM creditcards WHERE id = '" + ccid + "'");
			
			if (!result.next())
			{
				System.out.println("Credit Card is not valid.");
			}
			else
			{
				Statement stmt = connection.createStatement();
				String sql = "INSERT INTO customers " + "VALUES (NULL, "
													  + "'" + firstName + "', "
													  + "'" + lastName + "', "
													  + "'" + ccid + "', "
													  + "'" + address + "', "
													  + "'" + email + "', "
													  + "'" + password + "')";
				stmt.executeUpdate(sql);
				
				System.out.println("Customer Inserted");
			}
		}
		catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void deleteCustomer()
	{
		System.out.print("Please enter the id of the customer: ");
		int id =  s.nextInt();
		s.nextLine();
		
		try {
			Statement stmt = connection.createStatement();
			stmt.executeUpdate("DELETE FROM customers WHERE id = " + id);
			
			System.out.println("Customer Deleted");
		}
		catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void displayMetadata()
	{
		try {
			DatabaseMetaData metadata = connection.getMetaData();
			String table[] = { "TABLE" };
			ResultSet result = metadata.getTables(null, null, null, table);
			
			ArrayList<String> tables = new ArrayList<String>();
			while (result.next())
				tables.add(result.getString("TABLE_NAME"));
			
			for (String tableName : tables)
			{
				System.out.println(tableName);
				result = metadata.getColumns(null, null, tableName, null);
				while (result.next())
				{
					System.out.println("\t" + result.getString("COLUMN_NAME") + ": " + result.getString("TYPE_NAME"));
				}
				System.out.println();
			}
		}
		catch (SQLException e) {
			System.out.println(e.getMessage());
		}
	}
	
	public void executeSQLCommand()
	{
		System.out.print("Please enter a SQL command: ");
		String sql = s.nextLine();
		sql = sql.trim();
		if (sql.toUpperCase().startsWith("SELECT"))
		{
			try {
				Statement select = connection.createStatement();
				ResultSet result = select.executeQuery(sql);
				ResultSetMetaData metadata = result.getMetaData();
				int columns = metadata.getColumnCount();
				
				while (result.next())
				{
					for (int i = 1; i < columns+1; i++)
						System.out.println(result.getString(i));
					System.out.println();
				}
			}
			catch (SQLException e) {
				System.out.println(e.getMessage());
			}
		}
		else
		{
			try {
				Statement statement = connection.createStatement();
				int affected = statement.executeUpdate(sql);
				
				System.out.println("" + affected + " row(s) affected.");
			}
			catch (SQLException e) {
				System.out.println(e.getMessage());
			}			
		}
	}
	
	public void logout()
	{
		System.out.println("Logging out...");
	}
	
	public void quitProgram()
	{
		quit = true;
		System.out.println("Quitting Program...");
	}
	
}
