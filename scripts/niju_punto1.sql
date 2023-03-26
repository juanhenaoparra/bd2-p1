/*
Punto 1

Juan Sebastian Henao Parra
Nicolás Jiménez Ospina

*/

SET SERVEROUTPUT ON;

-- Type TITLES to contain the structure of the output and the counter of each range of ratings
CREATE OR REPLACE TYPE TITLES AS OBJECT (
    TITLE           VARCHAR2(512),
    LT3             NUMBER,
    GTE3            NUMBER,
    TAG_BUSCADO     VARCHAR2(512),
    GENEROS         VARCHAR2(512),
    NUMERO_GENEROS  NUMBER
);

-- Array of TITLES type
CREATE OR REPLACE TYPE ALL_TITLES AS TABLE OF TITLES; -- []TITLES

-- Procedure to search and increment a title and tag row in the desired column LT3 (Lower than rating 3) or GTE3 (Greather or equal than rating 3)
CREATE OR REPLACE PROCEDURE NIJU_PUNTO1_INCREMENT(
VALL IN OUT ALL_TITLES,
SEARCH_TITLE IN VARCHAR2,
SEARCH_TAG IN VARCHAR2,
SEARCH_GENRES IN VARCHAR2,
COMPARATOR IN VARCHAR2
) AS

TOTAL_COUNT NUMBER := 0;
TOTAL_GENRES NUMBER := 0;

BEGIN

    SELECT COUNT(*) INTO TOTAL_COUNT FROM TABLE(VALL) WHERE TITLE=SEARCH_TITLE AND TAG_BUSCADO=SEARCH_TAG;
    
    TOTAL_GENRES := REGEXP_COUNT(SEARCH_GENRES, '\|') + 1;
    
    -- If there are no matches insert an empty row of title and tag
    IF TOTAL_COUNT <= 0 THEN
        VALL.EXTEND;
        VALL(VALL.LAST) := TITLES(SEARCH_TITLE, 0 , 0, SEARCH_TAG, SEARCH_GENRES, TOTAL_GENRES);
    END IF;

    -- Increment the counters
    FOR I IN VALL.FIRST..VALL.LAST LOOP
        IF VALL(I).TITLE = SEARCH_TITLE AND VALL(I).TAG_BUSCADO = SEARCH_TAG THEN
            IF COMPARATOR = '<' THEN
                VALL(I).LT3 := VALL(I).LT3+1;
                EXIT;
            ELSE
                VALL(I).GTE3 := VALL(I).GTE3+1;
                EXIT;
            END IF;
        END IF;
    END LOOP;

END NIJU_PUNTO1_INCREMENT;


-- Procedure that receives a T parameter ('tag1-tag2-tag3') and increments the counter based on each tag
-- at the end shows the result with percentages
CREATE OR REPLACE PROCEDURE NIJU_PUNTO1 (
    T IN VARCHAR2
)
AS

VALL ALL_TITLES := ALL_TITLES();

CURSOR MIC IS SELECT TAGS.MOVIE_ID, TAGS.TAG, MOVIES.TITLE, RATINGS.RATING, MOVIES.GENRES FROM TAGS
                INNER JOIN MOVIES
                ON TAGS.MOVIE_ID = MOVIES.MOVIE_ID
                INNER JOIN RATINGS
                ON TAGS.MOVIE_ID = RATINGS.MOVIE_ID;

V_SYSCUR SYS_REFCURSOR;
FOUND_TAG VARCHAR2(100) := '';

BEGIN

FOR I IN MIC LOOP 

    FOR J IN 1..REGEXP_COUNT(LOWER(T), '-') + 1 LOOP
        FOUND_TAG := REGEXP_SUBSTR(LOWER(T), '[^-]+', 1, J);
        
        IF INSTR(LOWER(I.TAG), LOWER(FOUND_TAG)) > 0 THEN
            IF I.RATING < 3.0 THEN
                NIJU_PUNTO1_INCREMENT(VALL, I.TITLE, LOWER(FOUND_TAG), I.GENRES, '<');
            ELSE
                NIJU_PUNTO1_INCREMENT(VALL, I.TITLE, LOWER(FOUND_TAG), I.GENRES, '>');
            END IF;
        END IF;
    END LOOP;

END LOOP;

-- Prepare the output query
OPEN V_SYSCUR FOR SELECT TITLE AS TITULO, (LT3*100/(LT3 + GTE3)) AS "%_MENOR _3", (GTE3*100/(LT3 + GTE3)) AS "%_MAYOR _3", TAG_BUSCADO, NUMERO_GENEROS FROM TABLE(VALL);
DBMS_SQL.RETURN_RESULT(V_SYSCUR);

END NIJU_PUNTO1;


-- EXAMPLE EXECUTION
DECLARE
v_start_time NUMBER;
v_elapsed_time NUMBER;
BEGIN
v_start_time := DBMS_UTILITY.GET_TIME;

NIJU_PUNTO1('alien-comedy');

v_elapsed_time := DBMS_UTILITY.GET_TIME - v_start_time;
DBMS_OUTPUT.PUT_LINE('Elapsed time: ' || v_elapsed_time);
END;