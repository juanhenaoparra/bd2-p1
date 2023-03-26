-- Generado por Oracle SQL Developer Data Modeler 19.1.0.081.0911
--   en:        2023-03-26 10:34:47 COT
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLESPACE niju 
--  WARNING: Tablespace has no data files defined 
 LOGGING ONLINE EXTENT MANAGEMENT LOCAL AUTOALLOCATE FLASHBACK ON;

CREATE user niju identified by account unlock 
;

CREATE TABLE niju.genome_scores (
    movie_id    NUMBER(38),
    tag_id      NUMBER(38),
    relevance   FLOAT(126)
)
PCTFREE 10 PCTUSED 40 TABLESPACE niju LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT );

CREATE TABLE niju.genome_tags (
    tag_id      NUMBER(38),
    tag   VARCHAR2(256 BYTE),
)
PCTFREE 10 PCTUSED 40 TABLESPACE niju LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT );


CREATE TABLE niju.links (
    movie_id   NUMBER(38),
    imdb_id    NUMBER(38),
    tmdb_id    NUMBER(38)
)
PCTFREE 10 PCTUSED 40 TABLESPACE niju LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT );

CREATE TABLE niju.movies (
    movie_id   NUMBER(38) NOT NULL,
    title      VARCHAR2(256 BYTE),
    genres     VARCHAR2(256 BYTE)
)
PCTFREE 10 PCTUSED 40 TABLESPACE niju LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT );

CREATE UNIQUE INDEX niju.pk_movies ON
    niju.movies (
        movie_id
    ASC )
        TABLESPACE niju PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE niju.movies
    ADD CONSTRAINT pk_movies PRIMARY KEY ( movie_id )
        USING INDEX niju.pk_movies;

CREATE TABLE niju.ratings (
    user_id    NUMBER(38),
    movie_id   NUMBER(38),
    rating     FLOAT(126),
    datetime   TIMESTAMP
)
PCTFREE 10 PCTUSED 40 TABLESPACE niju LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT );
ALTER TABLE RATINGS ADD (DATETIME TIMESTAMP);

UPDATE RATINGS SET DATETIME = TO_TIMESTAMP(
                TO_CHAR( 
                TO_DATE( '1970-01-01', 'YYYY-MM-DD' ) + numtodsinterval( TIMESTAMP, 'SECOND' ), 
                'YYYY-MM-DD HH24:MI:SS'
                ), 'YYYY-MM-DD HH24:MI:SS');
                
ALTER TABLE RATINGS DROP COLUMN TIMESTAMP;

CREATE TABLE niju.tags (
    user_id    NUMBER(38),
    movie_id   NUMBER(38),
    tag        VARCHAR2(128 BYTE),
    datetime   TIMESTAMP
)
PCTFREE 10 PCTUSED 40 TABLESPACE niju LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT );

ALTER TABLE TAGS ADD (DATETIME TIMESTAMP);

UPDATE TAGS SET DATETIME = TO_TIMESTAMP(
                TO_CHAR( 
                TO_DATE( '1970-01-01', 'YYYY-MM-DD' ) + numtodsinterval( TIMESTAMP, 'SECOND' ), 
                'YYYY-MM-DD HH24:MI:SS'
                ), 'YYYY-MM-DD HH24:MI:SS');
            
ALTER TABLE TAGS DROP COLUMN TIMESTAMP;

ALTER TABLE niju.genome_scores
    ADD CONSTRAINT fk_genome_scores_genome_tags FOREIGN KEY ( tag_id )
        REFERENCES niju.genome_tags ( tag_id )
    NOT DEFERRABLE;

ALTER TABLE niju.genome_scores
    ADD CONSTRAINT fk_genome_scores_movies FOREIGN KEY ( movie_id )
        REFERENCES niju.movies ( movie_id )
    NOT DEFERRABLE;

ALTER TABLE niju.links
    ADD CONSTRAINT fk_links FOREIGN KEY ( movie_id )
        REFERENCES niju.movies ( movie_id )
    NOT DEFERRABLE;

ALTER TABLE niju.ratings
    ADD CONSTRAINT fk_ratings_movies FOREIGN KEY ( movie_id )
        REFERENCES niju.movies ( movie_id )
    NOT DEFERRABLE;

ALTER TABLE niju.tags
    ADD CONSTRAINT fk_tags_movies FOREIGN KEY ( movie_id )
        REFERENCES niju.movies ( movie_id )
    NOT DEFERRABLE;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             5
-- CREATE INDEX                             1
-- ALTER TABLE                              6
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        1
-- CREATE USER                              1
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 1
