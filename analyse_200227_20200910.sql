--20200910
-----------------------------------------
-----------------------------------------
-----------------------------------------

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
