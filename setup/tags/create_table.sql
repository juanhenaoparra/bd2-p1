SET DEFINE OFF
CREATE TABLE TAGS ( user_id NUMBER(38),
movie_id NUMBER(38),
tag VARCHAR2(128),
timestamp NUMBER(38));

-- once loaded the data

-- convert unix timestamp to date and time values
ALTER TABLE TAGS ADD (DATETIME TIMESTAMP);

UPDATE TAGS SET DATETIME = TO_TIMESTAMP(
                TO_CHAR( 
                TO_DATE( '1970-01-01', 'YYYY-MM-DD' ) + numtodsinterval( TIMESTAMP, 'SECOND' ), 
                'YYYY-MM-DD HH24:MI:SS'
                ), 'YYYY-MM-DD HH24:MI:SS');
            
ALTER TABLE TAGS DROP COLUMN TIMESTAMP;
