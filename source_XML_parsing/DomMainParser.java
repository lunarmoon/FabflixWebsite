import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class DomMainParser {
	Document dom;
	DomMainParser(){
	}
	
	Set<String> allGenres = new HashSet<String>();
	ArrayList<ArrayList<String>> movieGenreList = new ArrayList<ArrayList<String>>();
	//HashMap<String, ArrayList<ArrayList<String>>> movieInfo = new HashMap<String, ArrayList<ArrayList<String>>>();
	ArrayList<Movie> movies = new ArrayList<Movie>();
	
	
	public void runExample() {
		parseCasts();
		parseDocument();	
		//printActorMoviesDict();
	}
	
	private void parseCasts(){
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();	
		try {
			DocumentBuilder db = dbf.newDocumentBuilder();
			dom = db.parse("mains243.xml");
			
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(IOException ioe) {
			ioe.printStackTrace();
		}
	}
	private void parseDocument(){
		Element docEle = dom.getDocumentElement();

		createMovies(docEle);
		
	}
	
	private void createMovies(Element docEle){
		NodeList filmList = docEle.getElementsByTagName("film");
		for(int i = 0; i < filmList.getLength();i++){
			String director = "";
			String title = "";
			ArrayList<String> genres = new ArrayList<String>();	
			int yearMade = 0;
				Node currentN = filmList.item(i);
				if(currentN.getNodeType() == Node.ELEMENT_NODE){
					Element currentE = (Element) currentN;
					try{
						director =  currentE.getElementsByTagName("dirn").item(0).getTextContent();
					}catch(java.lang.NullPointerException e){}
					try{
						title =  currentE.getElementsByTagName("t").item(0).getTextContent().replaceAll("[^a-zA-Z\\s]", "").replaceAll("\\s+", " ");
					}catch(java.lang.NullPointerException e){}
					try{
						yearMade = Integer.parseInt(currentE.getElementsByTagName("year").item(0).getTextContent()); 
					}catch(java.lang.NullPointerException | java.lang.NumberFormatException e){}
					genres = getGenres(currentE, title);
				}
				//System.out.println("Director: " + director + "\t Title: " + title + "\t Year: " + Integer.toString(yearCreated));
				Movie movie = new Movie(title, yearMade, director, genres);
				movies.add(movie);
		}
	}
	ArrayList<String> getGenres(Element currentE, String title){
		NodeList genreNodes = (NodeList) currentE.getElementsByTagName("cats");
		ArrayList<String> currentGenres = new ArrayList<String>();
		for(int i = 0; i < genreNodes.getLength();i++){
			
			String genre = genreNodes.item(i).getTextContent();
			genre = genre.replaceAll("\\s+","");
			if(genre != ""){
				allGenres.add(genre);
				currentGenres.add(genre);
				ArrayList<String> movieGenrePair = new ArrayList<String>();
				movieGenrePair.add(title);
				movieGenrePair.add(genre);
				movieGenreList.add(movieGenrePair);
			}
		}
		return currentGenres;
	}

	public void printMovieGenreMap(){
		System.out.println("Number of movies: " + movieGenreList.size());
		for(int i = 0; i < movieGenreList.size(); i++){
			System.out.println(movieGenreList.get(i).get(0) + " is in the genres: " + movieGenreList.get(i).get(1));
		}
	}
	public void printAllGenres(){
		System.out.println("Number of genres: " + allGenres.size());
		for(String genre: allGenres){
			System.out.println(genre);
		}
		System.out.println();
	}
}
