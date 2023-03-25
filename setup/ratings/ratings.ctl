load data 
infile '/opt/oracle/movies/ml-25m/ratings.csv' "str '\r\n'"
append
into table RATINGS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( user_id,
             movie_id,
             rating,
             timestamp
           )
