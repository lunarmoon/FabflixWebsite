<html>
	<head>
		<title>Like Predicate</title>
	</head>
	<body>
		<p>
			The 'LIKE' predicate was used in all search queries, found in the file search.jsp.
			For each parameter ('Title', 'First Name', 'Last Name', 'Year', 'Director'), a query is performed.
			The five subqueries are performed regardless of whether or not a value has been input by the user
			in the HTML form.
			
			How the query works:
			
			A base query is written to get and combine all information from stars, movies, stars_in_movies, genres,
			and genres_in_movies.
			A query is run on this result table, selecting all information where first_name contains the pattern given
			in the first name parameter (first_name LIKE '%firstName%').
			A query is run on this result table, selecting all information where last_name contains the pattern given
			in the last name parameter (last_name LIKE '%lastName%').
			This repeats for each parameter, searching WHERE (column_name LIKE '%column%').
			For the Year parameter, a query searches for WHERE year > 0, if the parameter is left empty.
			Else, it searches for WHERE year == year_parameter.
			
			
		</p>
	</body>
</html>