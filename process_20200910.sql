----20200910


--- process 20200910 ---

SELECT * FROM agency_20200910 LIMIT 3;
SELECT * FROM calendar_dates_20200910 LIMIT 3;
SELECT * FROM routes_20200910 LIMIT 3;
SELECT * FROM stops_20200910 LIMIT 3;
SELECT * FROM trips_20200910 LIMIT 3;
SELECT * FROM calendar_20200910 LIMIT 3;
SELECT * FROM feed_info_20200910 LIMIT 3;
SELECT * FROM stop_times_20200910 LIMIT 3;
SELECT * FROM transfers_20200910 LIMIT 3;




DROP TABLE IF EXISTS mt_stop_shapes_20200910;
CREATE TABLE mt_stop_shapes_20200910 AS
SELECT stop_id --,stop_name
  ,stop_lat, stop_lon
  , ST_Transform( ST_GeomFromText( 'POINT(' || stop_lon || ' ' || stop_lat || ')' ,4326) , 3006) AS geom
FROM stops_20200910
--LIMIT 13
;
SELECT * FROM mt_stop_shapes_20200910 LIMIT 3;

ALTER TABLE mt_stop_shapes_20200910 ADD COLUMN long_3006 BIGINT;
ALTER TABLE mt_stop_shapes_20200910 ADD COLUMN  lat_3006 BIGINT;

UPDATE mt_stop_shapes_20200910
  SET
  ( long_3006 , lat_3006 ) = ( ST_X (geom), ST_Y (geom) )
;

SELECT * FROM mt_stop_shapes_20200910 LIMIT 3;
SELECT ST_GeomFromText( 'POINT(' || long_3006 || ' ' || lat_3006 || ')' ,3006) FROM mt_stop_shapes_20200910 LIMIT 3;

ALTER TABLE mt_stop_shapes_20200910 ADD COLUMN trunc_long_3006 BIGINT;
ALTER TABLE mt_stop_shapes_20200910 ADD COLUMN  trunc_lat_3006 BIGINT;

UPDATE mt_stop_shapes_20200910
  SET
  ( trunc_long_3006 , trunc_lat_3006 ) = ( ((floor(long_3006/1000))*1000+500)::INT, ((floor(lat_3006 /1000))*1000+500)::INT )
;
SELECT * FROM mt_stop_shapes_20200910 LIMIT 3;

ALTER TABLE mt_stop_shapes_20200910 ADD COLUMN geom_trunc geometry(Point,3006);

UPDATE mt_stop_shapes_20200910 SET geom_trunc = ST_GeomFromText( 'POINT(' || trunc_long_3006 || ' ' || trunc_lat_3006 || ')' ,3006);

SELECT * FROM mt_stop_shapes_20200910 LIMIT 3;


DROP TABLE IF EXISTS mt_stop_times_20200910;
CREATE TABLE mt_stop_times_20200910 AS
SELECT *
  , floor( (extract( EPOCH FROM (departure_time ) ) ) /(60*60) )::INT AS departure_hour
FROM stop_times_20200910
;

SELECT * FROM mt_stop_times_20200910 LIMIT 3;

DROP TABLE IF EXISTS mt_trunc_stops_times_SL_20200910;
CREATE TABLE mt_trunc_stops_times_SL_20200910 AS
SELECT row_number() OVER () AS gid
  ,b.datadate
  ,b.departure_hour
  ,departure_time,stop_sequence
  , trip_id,stop_id , route_id,agency_id,agency_name
  ,trunc_long_3006 , trunc_lat_3006
  , geom_trunc
  , long_3006 , lat_3006  , geom
FROM       mt_stop_shapes_20200910 a
INNER JOIN mt_stop_times_20200910 b USING (stop_id)
INNER JOIN trips_20200910 USING (trip_id)
INNER JOIN routes_20200910 USING (route_id)
INNER JOIN agency_20200910 USING (agency_id)
WHERE
  agency_name ~ 'SL'
  AND departure_time>= '07:00:00'
  AND departure_time< '09:00:00'
ORDER BY geom_trunc,departure_time, trip_id,stop_sequence
--LIMIT 33
;
SELECT * FROM mt_trunc_stops_times_SL_20200910 LIMIT 3;

CREATE INDEX ON mt_trunc_stops_times_SL_20200910 USING gist (geom_trunc);
CREATE INDEX ON mt_trunc_stops_times_SL_20200910 USING BRIN(departure_hour);


DROP TABLE IF EXISTS mt_count_trunc_stops_times_SL_20200910;
CREATE TABLE mt_count_trunc_stops_times_SL_20200910 AS
SELECT row_number() OVER () AS gid
 , count(gid)  AS n_stop_times
 , count(DISTINCT stop_id) AS n_stops
 , departure_hour
 , max(datadate) max_datadate
 , max(agency_id) max_agency_id
 , min(agency_id) min_agency_id
 , max(agency_name) max_agency_name
 , min(agency_name) min_agency_name
 , avg(trunc_long_3006)::bigint avg_trunc_long_3006
 , avg(trunc_lat_3006)::bigint avg_trunc_lat_3006
 , stddev(trunc_long_3006) std_trunc_long_3006
 , stddev(trunc_lat_3006) std_trunc_lat_3006
 , geom_trunc
FROM mt_trunc_stops_times_SL_20200910
GROUP BY geom_trunc,departure_hour
;
SELECT * FROM mt_count_trunc_stops_times_SL_20200910 LIMIT 13;

--sanity check
SELECT * FROM mt_count_trunc_stops_times_SL_20200910
WHERE max_agency_id!=min_agency_id
  OR max_agency_name!=min_agency_name
  OR std_trunc_long_3006!=0
  OR std_trunc_lat_3006!=0
LIMIT 13;

-- if above returns 0 rows drop the doubles
ALTER TABLE mt_count_trunc_stops_times_SL_20200910
DROP COLUMN min_agency_id,
DROP COLUMN min_agency_name,
DROP COLUMN std_trunc_long_3006,
DROP COLUMN std_trunc_lat_3006
;
SELECT * FROM mt_count_trunc_stops_times_SL_20200910 LIMIT 13;



DROP TABLE IF EXISTS mt_count_tot_trnc_sttimes_SL_20200910;
CREATE TABLE mt_count_tot_trnc_sttimes_SL_20200910 AS
SELECT row_number() OVER () AS gid
 , count(gid)  AS n_stop_times
 , count(DISTINCT stop_id) AS n_stops
 , min(departure_hour) min_departure_hour
 , max(departure_hour) max_departure_hour
 , max(datadate) max_datadate
 , min(datadate) min_datadate
 , max(agency_id) max_agency_id
 , min(agency_id) min_agency_id
 , max(agency_name) max_agency_name
 , min(agency_name) min_agency_name
 , avg(trunc_long_3006)::bigint avg_trunc_long_3006
 , avg(trunc_lat_3006)::bigint avg_trunc_lat_3006
 , stddev(trunc_long_3006) std_trunc_long_3006
 , stddev(trunc_lat_3006) std_trunc_lat_3006
 , geom_trunc
FROM mt_trunc_stops_times_SL_20200910
GROUP BY geom_trunc
;
SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200910 LIMIT 13;

--sanity check
SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200910
WHERE max_agency_id!=min_agency_id
  OR max_datadate!=min_datadate
  OR max_agency_name!=min_agency_name
  OR std_trunc_long_3006!=0
  OR std_trunc_lat_3006!=0
LIMIT 13;

-- if above returns 0 rows drop the doubles
ALTER TABLE mt_count_tot_trnc_sttimes_SL_20200910
DROP COLUMN min_agency_id,
DROP COLUMN min_datadate,
DROP COLUMN min_agency_name,
DROP COLUMN std_trunc_long_3006,
DROP COLUMN std_trunc_lat_3006
;
SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200910 LIMIT 13;
