SET DEFINE OFF
CREATE TABLE RATINGS ( user_id NUMBER(38),
movie_id NUMBER(38),
rating FLOAT,
timestamp NUMBER(38));

-- once loaded the csv data

-- convert unix timestamp to date and time values
ALTER TABLE RATINGS ADD (DATETIME TIMESTAMP);

UPDATE RATINGS SET DATETIME = TO_TIMESTAMP(
                TO_CHAR( 
                TO_DATE( '1970-01-01', 'YYYY-MM-DD' ) + numtodsinterval( TIMESTAMP, 'SECOND' ), 
                'YYYY-MM-DD HH24:MI:SS'
                ), 'YYYY-MM-DD HH24:MI:SS');
                
ALTER TABLE RATINGS DROP COLUMN TIMESTAMP;
