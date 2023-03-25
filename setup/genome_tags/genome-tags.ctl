load data 
infile '/opt/oracle/movies/ml-25m/genome-tags.csv' "str '\r\n'"
append
into table GENOME_TAGS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( tag_id,
             tag CHAR(4000)
           )
