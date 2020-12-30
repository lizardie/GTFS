
## set up DB in Postgres

"/Applications/Postgres.app/Contents/Versions/11/bin/psql" -p5432 -U "lizardie"

DROP DATABASE gtfs;
CREATE DATABASE gtfs
    WITH
    OWNER = lizardie
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
\conninfo
\q
