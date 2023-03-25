load data 
infile '/opt/oracle/movies/ml-25m/links.csv' "str '\r\n'"
append
into table LINKS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( movie_id,
             imdb_id,
             tmdb_id
           )
