--20200227

--- load 20200227 ---------

\COPY feed_info (feed_id,feed_publisher_name,feed_publisher_url,feed_lang,feed_version) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/feed_info.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM feed_info LIMIT 13;
SELECT count(*) FROM feed_info;

DROP TABLE IF EXISTS feed_info_20200227 CASCADE;
CREATE TABLE feed_info_20200227 AS SELECT * FROM feed_info;
UPDATE feed_info_20200227 SET datadate='20200227';

SELECT * FROM feed_info_20200227 LIMIT 13;
SELECT count(*) FROM feed_info_20200227;


\COPY calendar (service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/calendar.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM calendar LIMIT 13;
SELECT count(*) FROM calendar;

DROP TABLE IF EXISTS calendar_20200227 CASCADE;
CREATE TABLE calendar_20200227 AS SELECT * FROM calendar;
UPDATE calendar_20200227 SET datadate='20200227';

SELECT * FROM calendar_20200227 LIMIT 13;
SELECT count(*) FROM calendar_20200227;


\COPY calendar_dates (service_id,date,exception_type) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/calendar_dates.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM calendar_dates LIMIT 13;
SELECT count(*) FROM calendar_dates;--2985

DROP TABLE IF EXISTS calendar_dates_20200227 CASCADE;
CREATE TABLE calendar_dates_20200227 AS SELECT * FROM calendar_dates;
UPDATE calendar_dates_20200227 SET datadate='20200227';

SELECT * FROM calendar_dates_20200227 LIMIT 13;
SELECT count(*) FROM calendar_dates_20200227;


\COPY stops (stop_id,stop_name,stop_lat,stop_lon,location_type) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/stops.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM stops LIMIT 13;
SELECT count(*) FROM stops;--2985

DROP TABLE IF EXISTS stops_20200227 CASCADE;
CREATE TABLE stops_20200227 AS SELECT * FROM stops;
UPDATE stops_20200227 SET datadate='20200227';

SELECT * FROM stops_20200227 LIMIT 13;
SELECT count(*) FROM stops_20200227;


\COPY trips (route_id,service_id,trip_id,trip_headsign,trip_short_name) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/trips.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM trips LIMIT 13;
SELECT count(*) FROM trips;

DROP TABLE IF EXISTS trips_20200227 CASCADE;
CREATE TABLE trips_20200227 AS SELECT * FROM trips;
UPDATE trips_20200227 SET datadate='20200227';

SELECT * FROM trips_20200227 LIMIT 13;
SELECT count(*) FROM trips_20200227;


\COPY routes (route_id,agency_id,route_short_name,route_long_name,route_type,route_url) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/routes.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM routes LIMIT 13;
SELECT count(*) FROM routes;

DROP TABLE IF EXISTS routes_20200227 CASCADE;
CREATE TABLE routes_20200227 AS SELECT * FROM routes;
UPDATE routes_20200227 SET datadate='20200227';

SELECT * FROM routes_20200227 LIMIT 13;
SELECT count(*) FROM routes_20200227;

SELECT * FROM routes_20200227 WHERE route_id='1275086100001' LIMIT 13;


\COPY stop_times (trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/stop_times.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM stop_times LIMIT 13;
SELECT count(*) FROM stop_times;

DROP TABLE IF EXISTS stop_times_20200227 CASCADE;
CREATE TABLE stop_times_20200227 AS SELECT * FROM stop_times;
UPDATE stop_times_20200227 SET datadate='20200227';

SELECT * FROM stop_times_20200227 LIMIT 13;
SELECT count(*) FROM stop_times_20200227;

SELECT * FROM stop_times_20200227 WHERE trip_id='22580120000001' LIMIT 13;



\COPY agency (agency_id,agency_name,agency_url,agency_timezone,agency_lang) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/agency.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM agency LIMIT 13;
SELECT count(*) FROM agency;

DROP TABLE IF EXISTS agency_20200227 CASCADE;
CREATE TABLE agency_20200227 AS SELECT * FROM agency;
UPDATE agency_20200227 SET datadate='20200227';

SELECT * FROM agency_20200227 LIMIT 13;
SELECT count(*) FROM agency_20200227;

SELECT * FROM agency_20200227 WHERE agency_name='UL' LIMIT 13;



\COPY transfers (from_stop_id,to_stop_id,transfer_type,min_transfer_time,from_trip_id,to_trip_id) FROM '/Users/lizardie/Dropbox/MarinaTogerJohnOsth/BlueCollar/GTFS/data_raw/sweden-20200227/transfers.txt' WITH ( format csv, header on, DELIMITER ',') ;

SELECT * FROM transfers LIMIT 13;
SELECT count(*) FROM transfers;

DROP TABLE IF EXISTS transfers_20200227 CASCADE;
CREATE TABLE transfers_20200227 AS SELECT * FROM transfers;
UPDATE transfers_20200227 SET datadate='20200227';

SELECT * FROM transfers_20200227 LIMIT 13;
SELECT count(*) FROM transfers_20200227;

SELECT * FROM transfers_20200227 WHERE from_trip_id IS NOT NULL  LIMIT 13;








-----------------------------------------
-----------------------------------------
-----------------------------------------


--- check 20200227 ---

SELECT * FROM agency_20200227 LIMIT 3;
SELECT * FROM calendar_dates_20200227 LIMIT 3;
SELECT * FROM routes_20200227 LIMIT 3;
SELECT * FROM stops_20200227 LIMIT 3;
SELECT * FROM trips_20200227 LIMIT 3;
SELECT * FROM calendar_20200227 LIMIT 3;
SELECT * FROM feed_info_20200227 LIMIT 3;
SELECT * FROM stop_times_20200227 LIMIT 3;
SELECT * FROM transfers_20200227 LIMIT 3;
