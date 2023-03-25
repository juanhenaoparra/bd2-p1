load data 
infile '/opt/oracle/movies/ml-25m/genome-scores.csv' "str '\r\n'"
append
into table GENOME_SCORES
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( movie_id,
             tag_id,
             relevance
           )
