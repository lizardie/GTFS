----20200910


--- process 20200910 ---

------------ check tables

SELECT * FROM agency_20200910 LIMIT 3;
SELECT * FROM calendar_dates_20200910 LIMIT 3;
SELECT * FROM routes_20200910 LIMIT 3;
SELECT * FROM stops_20200910 LIMIT 3;
SELECT * FROM trips_20200910 LIMIT 3;
SELECT * FROM calendar_20200910 LIMIT 3;
SELECT * FROM feed_info_20200910 LIMIT 3;
SELECT * FROM stop_times_20200910 LIMIT 3;
SELECT * FROM transfers_20200910 LIMIT 3;


------------ add point shapes

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


------------ add hour

DROP TABLE IF EXISTS mt_stop_times_20200910;
CREATE TABLE mt_stop_times_20200910 AS
SELECT *
  , floor( (extract( EPOCH FROM (departure_time ) ) ) /(60*60) )::INT AS departure_hour
FROM stop_times_20200910
;

SELECT * FROM mt_stop_times_20200910 LIMIT 3;
