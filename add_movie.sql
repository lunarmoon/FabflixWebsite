DELIMITER //
CREATE PROCEDURE `add_movie`(in m_title varchar(100), in m_year int, in m_director varchar(100), in bannerurl varchar(200), in trailerurl varchar(200), in s_first_name varchar(50), in s_last_name varchar(50), in genre varchar(32))
BEGIN
	declare starExists int;
    declare genreExists int;
    declare starid int;
	declare genid int;
    declare mid int;
    declare movieExists int;
    
    select 'Inserting movie to database.';
    
    set movieExists = (select count(*) from movies where movies.title=m_title and movies.director = m_director and movies.year = m_year limit 1);
	
    if movieExists = 0 then begin
		insert into movies(title, year, director, banner_url, trailer_url) values(m_title, m_year, m_director, bannerurl, trailerurl);
    end; end if;
    
    set mid = (select movies.id from movies where movies.title = m_title and movies.director = m_director and movies.year = m_year limit 1);
	set starExists = (select count(*) from stars where stars.first_name = s_first_name and stars.last_name = s_last_name);
    set genreExists = (select count(*) from genres where genres.name = genre);
    
    if starExists > 0 then begin
		select 'Star already exists.  Updating stars_in_movies.';
		set starid = (select stars.id from stars where stars.first_name = s_first_name and stars.last_name = s_last_name limit 1);
		insert into stars_in_movies values(starid, mid);
		end;
    else begin
		select 'Star does not exist.  Adding new star, updating stars_in_movies.';
		insert into stars(first_name, last_name) values(s_first_name, s_last_name);
		set starid = (select stars.id from stars where stars.first_name = s_first_name and stars.last_name = s_last_name);
        insert into stars_in_movies values(starid, mid);
    end; end if;
    
    if genreExists > 0 then begin
		select 'Genre already exists.  Updating genres_in_movies.';
		set genid = (select genres.id from genres where genres.name = genre limit 1);
        insert into genres_in_movies values(genid, mid);
    end;
    else begin
		select 'Genre does not exist.  Adding new genre, updating genres_in_movies.';
		insert into genres(name) values(genre); 
		set genid = (select genres.id from genres where genres.name = genre limit 1);
        insert into genres_in_movies values(genid, mid);
    end; end if;
END
//
