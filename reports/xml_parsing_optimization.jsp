1.<br>The first optimization I did was an algorithm optimization. Initially, 
I was storing everything in lists. However, this could cause me to make extra
calls to the database when ever I encountered a duplicate. To fix this
I put everything in hashmaps to avoid duplicates. This changed the time from
about 5 Minutes 30 seconds to about 5 Minutes 15 seconds.
<br><br>
2.<br>The second way to optimize it was by drastically reducing the calls 
made to the database by about 20%. Initially, I would check to see
if any stars/genres/movies I was adding  were in it first. Then, when
I added the stars_in_movies and genres_in_movies I would query the DB
again for their id's. The change I made was when I first checked to see if
the stars/genres/movies were in there I would save the ID to a hashmap of
name of star/genre/movie : id and then just access the ID from the hashmap
when I needed to add stars_in_movies and genres_in_movies. This cut the time
down from about 5 Minutes 15 Seconds to about  4 Minutes.
<br>
*Please note the benchmarks were run on a local computer
<br>

Assumptions about the data: <br>
Since stars only had a birthyear after being mapped to actors63.xml we assigned
everyone the birthmonth and day of January, 1 (1-1).
For director names in movies we assigned each movie the director labeled under
<dirn> since that is the director that finished the movie. We left it as is since
there was an incomplete mapping in people55.xml, and since they only typically provided
the first letter of the first name and last name we didn't want to force a mapping and 
cause errors. We believe it better to have incomplete data than some wrong data.
