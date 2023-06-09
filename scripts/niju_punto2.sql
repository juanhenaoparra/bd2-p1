/*
Punto 2

Juan Sebastian Henao Parra
Nicolás Jiménez Ospina

*/

SET SERVEROUTPUT ON;

-- Type RANKING to contain the structure of the output and the counter of each range of RANKINGS
CREATE OR REPLACE TYPE RANKING AS OBJECT (
    TITLE       VARCHAR2(512),
    YEAR        NUMBER,
    SEMESTER    NUMBER,
    HOUR_A      NUMBER,
    HOUR_B      NUMBER,
    TOTAL       NUMBER,
    ACCUMULATED FLOAT
);

-- Array of RANKING type
CREATE OR REPLACE TYPE ALL_RANKINGS AS TABLE OF RANKING; -- []RANKING

-- Procedure to search and increment a title in the accumulated ranking
CREATE OR REPLACE PROCEDURE NIJU_PUNTO2_INCREMENT(
VALL            IN OUT ALL_RANKINGS,
SEARCH_TITLE    IN VARCHAR2,
SEARCH_SEMESTER IN NUMBER,
SEARCH_YEAR     IN NUMBER,
SEARCH_HOUR_A   IN NUMBER,
SEARCH_HOUR_B   IN NUMBER,
NEW_RATING      IN FLOAT
) AS

TOTAL_COUNT NUMBER := 0;

BEGIN

    SELECT COUNT(*)
    INTO TOTAL_COUNT
    FROM TABLE(VALL) 
    WHERE TITLE=SEARCH_TITLE;
    
    -- If there are no matches insert an empty row of RANKING type
    IF TOTAL_COUNT <= 0 THEN
        VALL.EXTEND;
        VALL(VALL.LAST) := RANKING(SEARCH_TITLE, SEARCH_YEAR, SEARCH_SEMESTER, SEARCH_HOUR_A, SEARCH_HOUR_B, 0, 0.0);
    END IF;

    -- Increment the counters
    FOR I IN VALL.FIRST..VALL.LAST LOOP
        IF VALL(I).TITLE = SEARCH_TITLE THEN
            VALL(I).TOTAL := VALL(I).TOTAL+1;
            VALL(I).ACCUMULATED := VALL(I).ACCUMULATED+NEW_RATING;
        END IF;
    END LOOP;

END NIJU_PUNTO2_INCREMENT;

-- Procedure to create a SELECT statement to fetch only the rows inside a semester 
-- and the increment based on the hours received
-- and show the output
CREATE OR REPLACE PROCEDURE NIJU_PUNTO2 (
I_YEAR IN NUMBER,
I_SEMESTER IN NUMBER,
I_HOUR_A IN NUMBER,
I_HOUR_B IN NUMBER
) AS

VALL ALL_RANKINGS := ALL_RANKINGS();

V_SYSCUR SYS_REFCURSOR;

V_SQL VARCHAR2(4000);
V_MAINCURSOR SYS_REFCURSOR;

TYPE SEL_RANKING IS RECORD (
  MOVIE_ID MOVIES.MOVIE_ID%TYPE,
  TITLE MOVIES.TITLE%TYPE,
  RATING RATINGS.RATING%TYPE,
  DATETIME RATINGS.DATETIME%TYPE
);

I SEL_RANKING;

CURRENT_HOUR NUMBER;

STARTING_YEAR   VARCHAR2(20);
STARTING_MONTH  VARCHAR2(20);

ENDING_YEAR     VARCHAR2(20);
ENDING_MONTH    VARCHAR2(20);

BEGIN

IF I_SEMESTER = 1 THEN
    STARTING_YEAR := TO_CHAR(I_YEAR);
    ENDING_YEAR := TO_CHAR(I_YEAR);

    STARTING_MONTH := '01';
    ENDING_MONTH := '07';
ELSIF I_SEMESTER = 2 THEN
    STARTING_YEAR := TO_CHAR(I_YEAR);
    ENDING_YEAR := TO_CHAR(I_YEAR+1);

    STARTING_MONTH := '07';
    ENDING_MONTH := '01';
END IF;

V_SQL := 'SELECT MOVIES.MOVIE_ID, MOVIES.TITLE, RATINGS.RATING, RATINGS.DATETIME  FROM MOVIES INNER JOIN RATINGS ON MOVIES.MOVIE_ID = RATINGS.MOVIE_ID';
V_SQL := V_SQL || ' WHERE DATETIME > TO_TIMESTAMP('''||STARTING_YEAR||'-'||STARTING_MONTH||'-01 00:00:00'', ''YYYY-MM-DD HH24:MI:SS'')  AND ';
V_SQL := V_SQL || 'DATETIME < TO_TIMESTAMP('''||ENDING_YEAR||'-'||ENDING_MONTH||'-01 00:00:00'', ''YYYY-MM-DD HH24:MI:SS'') ORDER BY RATINGS.RATING ASC';

DBMS_OUTPUT.PUT_LINE(V_SQL);

OPEN V_MAINCURSOR FOR V_SQL;

LOOP 
    FETCH V_MAINCURSOR INTO I;
    EXIT WHEN V_MAINCURSOR%NOTFOUND;

    CURRENT_HOUR := EXTRACT(HOUR FROM I.DATETIME);
    
    IF CURRENT_HOUR >= I_HOUR_A AND CURRENT_HOUR <= I_HOUR_B THEN

        NIJU_PUNTO2_INCREMENT(VALL, I.TITLE, I_SEMESTER, I_YEAR, I_HOUR_A, I_HOUR_B, I.RATING);

    END IF;
    
END LOOP;

CLOSE V_MAINCURSOR;

-- Prepare the output query
OPEN V_SYSCUR FOR SELECT 
    TITLE AS PELICULA, YEAR AS "AÑO", SEMESTER AS "SEMESTRE", HOUR_A || '-' || HOUR_B AS "HORAS_ENTRE", (ACCUMULATED/TOTAL) AS "PROMEDIO_CALIFICACION" 
    FROM TABLE(VALL)
    ORDER BY "PROMEDIO_CALIFICACION" ASC
    FETCH FIRST 12 ROWS ONLY;
DBMS_SQL.RETURN_RESULT(V_SYSCUR);

END NIJU_PUNTO2;

-- EXAMPLE EXECUTION
DECLARE
v_start_time NUMBER;
v_elapsed_time NUMBER;
BEGIN
v_start_time := DBMS_UTILITY.GET_TIME;

NIJU_PUNTO2(2018, 2, 2, 3);

v_elapsed_time := DBMS_UTILITY.GET_TIME - v_start_time;
DBMS_OUTPUT.PUT_LINE('Elapsed time: ' || v_elapsed_time);
END;