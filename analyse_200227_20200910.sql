--20200910
-----------------------------------------
-----------------------------------------
-----------------------------------------

------------ generate study sample

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

------------ aggregate by km² and by hour


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

--- analyse _20200227_20200910 ---

SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200227 LIMIT 6;

ALTER TABLE mt_count_tot_trnc_sttimes_SL_20200227 ADD CONSTRAINT mt_count_tot_trnc_sttimes_SL_20200227_pk PRIMARY KEY (gid);
CREATE INDEX ON mt_count_tot_trnc_sttimes_SL_20200227 USING gist (geom_trunc);
CREATE INDEX ON mt_count_tot_trnc_sttimes_SL_20200227 USING BRIN(max_datadate);
CREATE INDEX ON mt_count_tot_trnc_sttimes_SL_20200227 USING BRIN(avg_trunc_long_3006,avg_trunc_lat_3006);

\d+ mt_count_tot_trnc_sttimes_SL_20200227

SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200227 LIMIT 6;



SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200910 LIMIT 6;

ALTER TABLE mt_count_tot_trnc_sttimes_SL_20200910 ADD CONSTRAINT mt_count_tot_trnc_sttimes_SL_20200910_pk PRIMARY KEY (gid);
CREATE INDEX ON mt_count_tot_trnc_sttimes_SL_20200910 USING gist (geom_trunc);
CREATE INDEX ON mt_count_tot_trnc_sttimes_SL_20200910 USING BRIN(max_datadate);
CREATE INDEX ON mt_count_tot_trnc_sttimes_SL_20200910 USING BRIN(avg_trunc_long_3006,avg_trunc_lat_3006);

\d+ mt_count_tot_trnc_sttimes_SL_20200910


SELECT * FROM mt_count_tot_trnc_sttimes_SL_20200910 LIMIT 6;
--gid,n_stop_times,n_stops,min_departure_hour,max_departure_hour,max_datadate,max_agency_id,max_agency_name,avg_trunc_long_3006,avg_trunc_lat_3006, geom_trunc

DROP TABLE IF EXISTS mt_diff_tot_sttimes_SL_20200227_20200910;
CREATE TABLE mt_diff_tot_sttimes_SL_20200227_20200910 AS
SELECT a.gid agid, b.gid bgid
  , a.n_stop_times n_stop_times_20200227
  , b.n_stop_times n_stop_times_20200910
  , b.n_stop_times - a.n_stop_times nn_sttimes_20200227_20200910
  , a.n_stops n_stops_20200227
  , b.n_stops n_stops_20200910
  , b.n_stops - a.n_stops nn_stops_20200227_20200910
  --, a.avg_trunc_long_3006 - b.avg_trunc_long_3006 diff_long
  --, a.avg_trunc_lat_3006 - b.avg_trunc_lat_3006 diff_lat
  --, min(a.min_departure_hour,b.min_departure_hour) min_depatur_hour
  --, max(a.max_departure_hour,b.max_departure_hour) max_depatur_hour
  , CASE WHEN a.avg_trunc_long_3006 IS NOT NULL THEN a.avg_trunc_long_3006 ELSE b.avg_trunc_long_3006 END AS trunc_long_3006
  , CASE WHEN a.avg_trunc_lat_3006 IS NOT NULL THEN a.avg_trunc_lat_3006 ELSE b.avg_trunc_lat_3006 END AS trunc_lat_3006
  , CASE WHEN a.geom_trunc IS NOT NULL THEN a.geom_trunc ELSE b.geom_trunc END AS geom_trunc
 --,b.avg_trunc_long_3006,b.avg_trunc_lat_3006
FROM            mt_count_tot_trnc_sttimes_SL_20200227 a
FULL OUTER JOIN mt_count_tot_trnc_sttimes_SL_20200910 b USING (avg_trunc_long_3006,avg_trunc_lat_3006)
;
