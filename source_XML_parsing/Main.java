import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;


public class Main {
	
	public static void main(String[] args) {
		QueryWriter queryWriter = new QueryWriter();
		
		//parseDom
		DomCasterParser dom = new DomCasterParser();
		dom.runExample();
		//dom.printActorMoviesDict();
		HashMap<String,Set<String>> ActorMoviesDict  = dom.getActorMoviesDict();
		//parse Actor File
		DomActorParser actorParser = new DomActorParser();
		actorParser.runExample();
		
		//add Stars to DB
		System.out.println("Adding stars to DB");
		HashMap<String,Integer> starIDMap = createAndGetStarIDMap(actorParser.ActorStageToReal,ActorMoviesDict, queryWriter);
		
				
		DomMainParser mainParser = new DomMainParser();
		mainParser.runExample();
		//add Movies to DB
		System.out.println("adding movies to DB");
		

		HashMap<String,Integer> movieIDMap = createAndGetMovieIDMap(mainParser.movies, queryWriter);
		
		//addGenres to DB
		System.out.println("adding genres to DB");
		HashMap<String,Integer> genreIDMap = createAndGetGenreIDMap(mainParser.allGenres, queryWriter);
		
		//addStarsInMovies
		System.out.println("adding Stars + Movies");
		//System.out.println(starIDMap.size());
		addStarsInMovies(ActorMoviesDict, starIDMap, movieIDMap, queryWriter);
		
		//addGenresInMovies
		System.out.println("adding Genre + Movies");
		//System.out.println("genreIDMap.size(): " + genreIDMap.size());
		addGenresInMovies(mainParser.movies, movieIDMap, genreIDMap, queryWriter);
		
		System.out.println("finished");

	}
	
	private static void addGenresInMovies(ArrayList<Movie> movies,HashMap<String,Integer> movieIDMap, HashMap<String,Integer> genreIDMap, QueryWriter queryWriter){
		int movieID = 0;
		int genreID = 0;
		for(Movie movie : movies){
			try{
				movieID = movieIDMap.get(movie.title);
			}
			catch(Exception e){
			}
			
			for(String genre : movie.genres){
				genreID = 0;
				if(genreIDMap.keySet().contains(genre)){
					genreID = genreIDMap.get(genre);
				}
				if(movieID != 0 && genreID != 0 ){
					queryWriter.writeGenresInMovies(genreID, movieID);
				}
			}
		}
		
	}
	
	private static void addStarsInMovies( HashMap<String,Set<String>> ActorMoviesDict, HashMap<String,Integer> StarIDMap, HashMap<String,Integer> movieIDMap, QueryWriter queryWriter){
		int errors = 0;
		int movieErrors = 0;
		int actorSuccess = 0;
		int movieSuccess = 0;
		int actorID = 0;
		//System.out.println("Star ID Map: " + StarIDMap.size());
		for(String stageActorName : ActorMoviesDict.keySet()){
			actorID = 0;
			
			try{
				actorID = StarIDMap.get(stageActorName);
				actorSuccess += 1;
			}
			catch(Exception e){
				errors += 1;
				//System.out.println(e);
			}
				for(String movie : ActorMoviesDict.get(stageActorName)){
					//System.out.println(movie);
					if(movieIDMap.containsKey(movie)){
						int movieID = movieIDMap.get(movie);
						if(actorID != 0){
							queryWriter.writeStarsInMovies(actorID,movieID);
						}
						else{
							movieErrors +=1;
						}
					}
					else{
						movieErrors +=1;
					}
				}
			
		}
		//System.out.println("ActorMovies Errors: " + errors);
		//System.out.println("Actor success: " + actorSuccess);
		//System.out.println("Movie errors: " + movieErrors);
		//System.out.println("Movie success: " + movieSuccess);
	}
	

	
	private static HashMap<String, Integer> createAndGetGenreIDMap(Set<String> genres, QueryWriter queryWriter){
		HashMap<String,Integer> genreIDMap = new HashMap<String,Integer>();
		for(String genre: genres){
			int currentGenreID = queryWriter.writeGenre(genre);
			genreIDMap.put(genre, currentGenreID);
		}
		return genreIDMap;
	}
	private static HashMap<String,Integer> createAndGetMovieIDMap(ArrayList<Movie> movies, QueryWriter queryWriter){
		HashMap<String,Integer> movieIDMap = new HashMap<String,Integer>();
		for(Movie movie: movies){
			int currentMovieID = queryWriter.writeMovie(movie);
			movieIDMap.put(movie.title,currentMovieID);
			
		}
		return movieIDMap;
	}

	
	private static HashMap<String,Integer> createAndGetStarIDMap(HashMap<String,ArrayList<String>> ActorStageToReal, HashMap<String,Set<String>> actorMoviesDict, QueryWriter queryWriter){
		HashMap<String,Integer> starIDMap = new HashMap<String,Integer>();

		for(String actor: actorMoviesDict.keySet()){
			if(ActorStageToReal.get(actor) != null){
				Stars currentStarRealName = new Stars(ActorStageToReal.get(actor));
				int currentStarID = queryWriter.writeStar(currentStarRealName);
				starIDMap.put(actor, currentStarID);
				//actorMoviesDict.put(currentStarRealName.firstName + "." + currentStarRealName.lastName, actorMoviesDict.get(actor));
			}
			else{
			}

		}
		return starIDMap;
	}
}

