
-----------------------------------------
--create empty standard tables gtfs Sweden

--head feed_info.txt
DROP TABLE IF EXISTS feed_info CASCADE;

CREATE TABLE feed_info (
  gid SERIAL NOT NULL PRIMARY KEY
  , feed_id text
  ,feed_publisher_name text NOT NULL
  ,feed_publisher_url  text NOT NULL
  ,feed_lang text NOT NULL
  --,feed_start_date numeric(8) NULL
  --,feed_end_date numeric(8) NULL
  ,feed_version text NULL
  ,datadate VARCHAR(8)
);

-- head calendar.txt
DROP TABLE IF EXISTS calendar CASCADE;
CREATE TABLE calendar
(
  gid SERIAL NOT NULL --PRIMARY KEY
  ,service_id        text PRIMARY KEY
  ,monday            boolean NOT NULL
  ,tuesday           boolean NOT NULL
  ,wednesday         boolean NOT NULL
  ,thursday          boolean NOT NULL
  ,friday            boolean NOT NULL
  ,saturday          boolean NOT NULL
  ,sunday            boolean NOT NULL
  ,start_date        numeric(8) NOT NULL
  ,end_date          numeric(8) NOT NULL
  ,datadate VARCHAR(8)
) TABLESPACE pg_default;
ALTER TABLE calendar OWNER to lizardie;

-- head calendar_dates.txt
DROP TABLE IF EXISTS calendar_dates;
CREATE TABLE calendar_dates
(
  gid SERIAL NOT NULL PRIMARY KEY
  ,service_id text NOT NULL
  ,date numeric(8) NOT NULL
  ,exception_type integer NOT NULL
  ,datadate VARCHAR(8)
) TABLESPACE pg_default;
ALTER TABLE calendar_dates OWNER to lizardie;


--head stops.txt
DROP TABLE IF EXISTS  stops;
CREATE TABLE stops
(
  gid SERIAL NOT NULL --PRIMARY KEY
  , stop_id           text PRIMARY KEY
  ,stop_name         text NOT NULL
  ,stop_lat          double precision NOT NULL
  ,stop_lon          double precision NOT NULL
  ,location_type     boolean NULL
  ,datadate VARCHAR(8)
);


--head trips.txt
DROP TABLE IF EXISTS  trips;
CREATE TABLE trips
(
  gid SERIAL NOT NULL --PRIMARY KEY
  ,route_id          text NOT NULL
  ,service_id        text NOT NULL
  ,trip_id           text NOT NULL PRIMARY KEY
  ,trip_headsign     text NULL
  ,trip_short_name   text NULL
  ,datadate VARCHAR(8)
);


--head routes.txt
DROP TABLE IF EXISTS  routes;
CREATE TABLE routes
(
  gid SERIAL NOT NULL --PRIMARY KEY
  ,route_id          text PRIMARY KEY
  ,agency_id         text NULL
  ,route_short_name  text NULL
  ,route_long_name   text NULL
  ,route_type        integer NULL
  ,route_url         text NULL
  ,datadate VARCHAR(8)
);


--stop_times.txt
DROP TABLE IF EXISTS  stop_times;
CREATE TABLE stop_times
(
  gid SERIAL NOT NULL PRIMARY KEY
  ,trip_id           text NOT NULL
  ,arrival_time      interval NOT NULL
  ,departure_time    interval NOT NULL
  ,stop_id           text NOT NULL
  ,stop_sequence     integer NOT NULL
  ,pickup_type       integer NULL --CHECK(pickup_type >= 0 and pickup_type <=3)
  ,drop_off_type     integer NULL --CHECK(drop_off_type >= 0 and drop_off_type <=3)
  ,datadate VARCHAR(8)
);


--head agency.txt
DROP TABLE IF EXISTS  agency;
CREATE TABLE agency
(
  gid SERIAL NOT NULL PRIMARY KEY
  ,agency_id         text UNIQUE NULL
  ,agency_name       text NOT NULL
  ,agency_url        text NOT NULL
  ,agency_timezone   text NOT NULL
  ,agency_lang       text NULL
  ,datadate VARCHAR(8)
);


--head transfers.txt
DROP TABLE IF EXISTS transfers;
CREATE TABLE transfers
(
    gid SERIAL NOT NULL PRIMARY KEY
    ,from_stop_id  text NOT NULL
    ,to_stop_id    text NOT NULL
    ,transfer_type   integer NOT NULL
    ,min_transfer_time integer
    ,from_trip_id    text NULL
    ,to_trip_id    text NULL
    ,datadate VARCHAR(8)
);
