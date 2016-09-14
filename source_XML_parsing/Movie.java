import java.util.ArrayList;


public class Movie {
	public String title;
	public int year;
	public String director;
	public String banner_url = null;
	public String trailer_url = null;
	public ArrayList <String> genres = null;
	
	public Movie(String title, int year, String director, ArrayList<String> genres){
		this.title = title;
		this.year = year;
		this.director = director;
		this.genres = genres;
	}
	public void addMovie(){
		//check if movie is in there
		//if not add it
	}
	void printMovieInfo(){
		System.out.println(title + " made in " + Integer.toString(year) + " made by " + director);
	}
}
