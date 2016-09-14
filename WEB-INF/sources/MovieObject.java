package fabflix.objects;
import java.util.ArrayList;

public class MovieObject {
	private int id;
	private String title;
	private int year;
	private String director;
	private ArrayList<String> genres;
	private ArrayList<String> star_names;
	private ArrayList<Integer> star_ids;
	private String banner_url;
	
	public MovieObject(int id, String title)
	{
		this(id, title, 0000, "Not Available");
		banner_url = "Unavailable";
	}
	
	public MovieObject(int id, String title, int year, String director) {
		this.id = id;
		this.title = title;
		this.year = year;
		this.director = director;
		
		genres = new ArrayList<String>();
		star_names = new ArrayList<String>();
		star_ids = new ArrayList<Integer>();
		banner_url = "Unavailable";
	}
	
	public int getId() {
		return id;
	}
	
	public String getTitle() {
		return title;
	}
	
	public int getYear() {
		return year;
	}
	
	public String getDirector() {
		return director;
	}

	public String getBannerURL() {
		return banner_url;
	}
	
	public ArrayList<String> getGenres() {
		return genres;
	}
	
	public ArrayList<String> getStarNames() {
		return star_names;
	}
	
	public ArrayList<Integer> getStarIds() {
		return star_ids;
	}
	
	public void addGenre(String genre) {
		genres.add(genre);
	}
	
	public void addStarName(String name) {
		star_names.add(name);
	}
	
	public void addStarId(int id) {
		star_ids.add(id);
	}
	
	public void setBannerURL(String banner_url) {
		this.banner_url = banner_url;
	}
}
