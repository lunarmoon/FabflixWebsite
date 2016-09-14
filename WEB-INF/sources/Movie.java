import java.util.List;
import java.util.ArrayList;

public class Movie {
	private String title;
	private String director;
	private List<String> starring;
	private int year;
	public Movie(){
		starring = new ArrayList<String>();
	}
	public void setTitle(String title)
	{
		this.title = title;
	}
	public void setDirector(String dir)
	{
		director = dir;
	}
	public void setYear(int year)
	{
		this.year = year;
	}
	public void addStar(String firstname, String lastname)
	{
		starring.add(firstname + lastname);
	}
}