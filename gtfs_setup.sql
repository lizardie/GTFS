-- gtfs_setup.sql



-----------------------------------------
--0-- setup
------------+------∞8∞------+------------

--on Mac locally (change the folders and user name as needed)
"/Applications/Postgres.app/Contents/Versions/11/bin/psql" -p5432 -U "lizardie" -d "gtfs"

-----------------------------------------

select now();
\conninfo
SELECT version();
SELECT PostGIS_version();
\timing
\encoding UTF8
\pset pager off
\pset border 1
SHOW data_directory;
SELECT to_char(current_date, 'day');
select now();



-----------------------------------------
-----------------------------------------
-----------------------------------------

--check dates
--select * from pg_ls_dir('.');
select * from pg_ls_dir('/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/');
/*
pg_ls_dir
-----------------
.DS_Store
sweden-20200227
sweden-20200611
sweden-20200326
sweden-20200910
sweden-20201210
(6 rows)
*/


WITH files AS (
  SELECT * FROM pg_ls_dir('/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/'::text) file WHERE file LIKE 'sweden-%' ORDER BY 1 )
SELECT replace(file,'sweden-','') datec
,'/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/'::text || file::text pathc
FROM files;
/*
  datec   |                                        pathc
----------+--------------------------------------------------------------------------------------
 20200227 | /Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227
 20200326 | /Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200326
 20200611 | /Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200611
 20200910 | /Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200910
 20201210 | /Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20201210
(5 rows)
*/

-----------------------------------------
-----------------------------------------
-----------------------------------------


--create extra tables Marinka (and from other sources, such as )
-- run gtfs_create_extra_tables.sql

--create empty standard tables gtfs Sweden
-- run gtfs_create_empty_standard_tables.sql

--load one day's data
--re-create empty standard tables between each day
--process each day
--analyse 



------------------------
-- |\_____/|
-- |[o] [o]|
-- |   V   |
-- |       |
---ooo---ooo------------

-- how long the query will take? Output from EXPLAIN in human readable:
SELECT '21357376 ms'::INTERVAL calc_time;
SELECT ( ( 21357376*0.001/(60*60*24*365) ) || ' year' )  bloody_long_calc_time;
SELECT ( ( 21357376*0.001/(60*60) ) || ' hour' )  bloody_long_calc_time;
