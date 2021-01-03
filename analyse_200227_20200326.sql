
------------ generate study sample

--20200326

BEGIN;
SET LOCAL work_mem = '100MB';

DROP TABLE IF EXISTS mt_sample_20200326;
CREATE TABLE mt_sample_20200326 AS

SELECT row_number() OVER () AS gid
 , b.service_id
 , b.route_id
 , b.trip_id
 , c.stop_id
 , c.stop_sequence
 , c.departure_time
 --, c.arrival_time
 , c.departure_hour
 --, c.pickup_type, c.drop_off_type
 --, b.trip_headsign , b.trip_short_name
 --, f.route_short_name, f.route_long_name
 , f.agency_id
 , b.datadate
 --, b.gid gid_trips
 --, a.gid gid_calendar_dates
 --, c.gid gid_stop_times
 --, e.gid gid_stops
 --, f.gid gid_routes
 --, g.gid gid_agency
 , e.stop_name
 , f.route_type
 , g.agency_name
 --, f.route_url
 , d.trunc_long_3006, d.trunc_lat_3006 , d.geom_trunc::geometry(point,3006)
 , d.long_3006, d.lat_3006 , d.geom::geometry(point,3006)
 --, a.date calendar_date
FROM trips_20200326 b
INNER JOIN calendar_dates_20200326 a ON a.service_id = b.service_id
INNER JOIN mt_stop_times_20200326 c ON  b.trip_id = c.trip_id
INNER JOIN mt_stop_shapes_20200326 d ON c.stop_id = d.stop_id
INNER JOIN stops_20200326 e ON c.stop_id = e.stop_id
INNER JOIN routes_20200326 f ON b.route_id = f.route_id
INNER JOIN agency_20200326 g ON f.agency_id = g.agency_id
WHERE a.date::int = a.datadate::int
 AND c.departure_time>= '07:00:00'
 AND c.departure_time< '09:00:00'
 --AND f.agency_id IN ('275','276','279')
 --AND ( agency_name ~ 'SL' OR agency_name ~ 'Skånetrafiken ')
--ORDER BY service_id,route_id,trip_id ,stop_id
--LIMIT 6
;--243695 rows

COMMIT;   -- or ROLLBACK

ALTER TABLE mt_sample_20200326 ADD CONSTRAINT mt_sample_20200326_pk PRIMARY KEY (gid);

CREATE INDEX ON mt_sample_20200326 USING gist (geom_trunc);
CREATE INDEX ON mt_sample_20200326 USING gist (geom);
CREATE INDEX ON mt_sample_20200326 USING BRIN(departure_hour);


SELECT * FROM mt_sample_20200326 ORDER BY service_id, route_id, trip_id , stop_id
LIMIT 3;


------------ aggregate 20200326
DROP TABLE IF EXISTS trunc_agg_20200326;
CREATE TABLE trunc_agg_20200326 AS

WITH aa AS (
  SELECT row_number() OVER () AS gid
     , count(gid) AS n_stop_times
     , count(DISTINCT stop_id) AS n_stops
     , 1+max(departure_hour)-min(departure_hour) n_hours
     , array_agg(DISTINCT departure_hour) FILTER (WHERE departure_hour IS NOT NULL) as agg_departure_hour
     , max(datadate) max_datadate
     , count(DISTINCT agency_id) n_agency_id
     --, max(agency_id) max_agency_id
     --, min(agency_id) min_agency_id
     , array_agg(DISTINCT agency_id) FILTER (WHERE agency_id IS NOT NULL) as agg_agency_id
     --, max(agency_name) max_agency_name
     --, min(agency_name) min_agency_name
     , array_agg(DISTINCT agency_name) FILTER (WHERE agency_name IS NOT NULL) as agg_agency_name
     , avg(trunc_long_3006)::bigint avg_trunc_long_3006
     , avg(trunc_lat_3006)::bigint avg_trunc_lat_3006
     , stddev(trunc_long_3006) std_trunc_long_3006
     , stddev(trunc_lat_3006) std_trunc_lat_3006
     , geom_trunc
  FROM mt_sample_20200326
  GROUP BY geom_trunc
  )
SELECT gid
,n_stop_times::FLOAT/n_hours::FLOAT AS nph_sttimes
,n_hours,n_stop_times,n_stops
,agg_departure_hour
,max_datadate datadate
,n_agency_id
,agg_agency_id
,agg_agency_name
,avg_trunc_long_3006
,avg_trunc_lat_3006
,std_trunc_long_3006,std_trunc_lat_3006
,geom_trunc
FROM aa
;

SELECT * FROM trunc_agg_20200326 LIMIT 13;


--sanity check
SELECT * FROM trunc_agg_20200326
WHERE std_trunc_long_3006>0
  OR std_trunc_lat_3006>0
LIMIT 13;


-- if above returns 0 rows drop the doubles
ALTER TABLE trunc_agg_20200326
DROP COLUMN std_trunc_long_3006,
DROP COLUMN std_trunc_lat_3006
;
SELECT * FROM trunc_agg_20200326 LIMIT 13;

ALTER TABLE trunc_agg_20200326 RENAME COLUMN avg_trunc_long_3006 TO trunc_long_3006;
ALTER TABLE trunc_agg_20200326 RENAME COLUMN avg_trunc_lat_3006 TO trunc_lat_3006;
ALTER TABLE trunc_agg_20200326 RENAME COLUMN max_datadate TO datadate;
SELECT * FROM trunc_agg_20200326 LIMIT 13;

ALTER TABLE trunc_agg_20200326 ADD CONSTRAINT trunc_agg_20200326_pk PRIMARY KEY (gid);
CREATE INDEX ON trunc_agg_20200326 USING gist (geom_trunc);
CREATE INDEX ON trunc_agg_20200326 USING BRIN(trunc_long_3006,trunc_lat_3006);
\d+ trunc_agg_20200326
-----------------------------------------


-- indicces
ALTER TABLE trunc_agg_20200326 RENAME COLUMN avg_trunc_long_3006 TO trunc_long_3006;
ALTER TABLE trunc_agg_20200326 RENAME COLUMN avg_trunc_lat_3006 TO trunc_lat_3006;
ALTER TABLE trunc_agg_20200326 RENAME COLUMN max_datadate TO datadate;

ALTER TABLE trunc_agg_20200326 ADD CONSTRAINT trunc_agg_20200326_pk PRIMARY KEY (gid);
CREATE INDEX ON trunc_agg_20200326 USING gist (geom_trunc);
CREATE INDEX ON trunc_agg_20200326 USING BRIN(trunc_long_3006,trunc_lat_3006);
\d+ trunc_agg_20200326

SELECT * FROM trunc_agg_20200326 LIMIT 13;

-----------------------------------------

-- the join

DROP TABLE IF EXISTS trunc_agg_20200227_20200326;
CREATE TABLE trunc_agg_20200227_20200326 AS
--EXPLAIN
SELECT  a.gid agid, b.gid bgid
  , b.nph_sttimes - a.nph_sttimes nph_sttimes_20200227_20200326
  , b.n_stop_times - a.n_stop_times nn_stop_times_20200227_20200326
  , b.n_stops - a.n_stops nn_n_stops_20200227_20200326
  , (b.n_stops/b.n_hours - a.n_stops/a.n_hours) nph_stops_20200227_20200326
  , a.nph_sttimes nph_sttimes_20200227
  , b.nph_sttimes nph_sttimes_20200326
  , a.n_stops/a.n_hours nph_stops_20200227
  , b.n_stops/b.n_hours nph_stops_20200326
  , CASE WHEN a.trunc_long_3006 IS NOT NULL THEN a.trunc_long_3006 ELSE b.trunc_long_3006 END AS trunc_long_3006
  , CASE WHEN  a.trunc_lat_3006 IS NOT NULL THEN  a.trunc_lat_3006 ELSE b.trunc_long_3006 END AS trunc_lat_3006
  , CASE WHEN a.geom_trunc IS NOT NULL THEN a.geom_trunc ELSE b.geom_trunc END AS geom_trunc
FROM            trunc_agg_20200227 a
FULL OUTER JOIN trunc_agg_20200326 b
  ON a.trunc_long_3006 = b.trunc_long_3006
  AND a.trunc_lat_3006=b.trunc_lat_3006
;--26658

SELECT * FROM trunc_agg_20200227_20200326 LIMIT 13;

ALTER TABLE trunc_agg_20200227_20200326 ADD CONSTRAINT trunc_agg_20200227_20200326_pk PRIMARY KEY (gid);
CREATE INDEX ON trunc_agg_20200227_20200326 USING gist (geom_trunc);
