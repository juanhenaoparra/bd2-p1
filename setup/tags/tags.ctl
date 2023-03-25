load data 
infile '/opt/oracle/movies/ml-25m/tags.csv' "str '\r\n'"
append
into table TAGS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( user_id,
             movie_id,
             tag CHAR(4000),
             timestamp
           )
