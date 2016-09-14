import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.ArrayList;
import fabflix.objects.MovieObject;

public class movieHover extends HttpServlet {

  public void doGet(HttpServletRequest req, HttpServletResponse res)
                               throws ServletException, IOException {
	int movie_id = Integer.valueOf((String)req.getParameter("movieId"));
	ArrayList<MovieObject> movieObjects = (ArrayList<MovieObject>) req.getSession().getAttribute("movieObjects");
	MovieObject current = null;
	for (int i = 0; i < movieObjects.size(); i++)
	{
		if (movieObjects.get(i).getId() == movie_id){
			current = movieObjects.get(i);
			break;
		}
	}
	String stars = "";
	for (int j = 0; j < current.getStarNames().size(); j++)
	{
		stars += "<a href=\"/starPage?starid="
			+ current.getStarIds().get(j) + "\">" + current.getStarNames().get(j) + "</a>";
		if (j < current.getStarNames().size() - 1)
			stars += ", ";
	}
	
	String genres = "";
	for (int k = 0; k < current.getGenres().size(); k++)
	{
		genres += current.getGenres().get(k);
	}
	
	String popup = "<div class=\"popup\">"
			+ "<img src=\"" + current.getBannerURL() + "\"/><br/>"
			+ "Movie Title: <a href=\"moviePage?movieid=" + movie_id + "\">" + current.getTitle() + "</a><br/>"
			+ "Year Published: " + current.getYear() + "<br/>"
			+ "Directed by: "  + current.getDirector() + "<br/>"
			+ "Starring: " + stars + "<br/>"
			+ "Genres: " + genres
			+ "</div>";

    res.setContentType("text/html");

    PrintWriter out = res.getWriter();
    out.println(popup);

    //out.println("Hello World" + Calendar.getInstance().get(Calendar.SECOND));
  }
}
