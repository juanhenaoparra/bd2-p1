load data 
infile '/opt/oracle/movies/ml-25m/movies.csv' "str '\r\n'"
append
into table MOVIES
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( movie_id,
             title CHAR(4000),
             genres CHAR(4000)
           )
