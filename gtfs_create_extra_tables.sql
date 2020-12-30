-- gtfs_create_extra_tables.sql


-----------------------------------------
--create extra tables Marinka (and from other sources)
BEGIN;

-- drops
DROP TABLE IF EXISTS gtfs_exception_types CASCADE;
DROP TABLE IF EXISTS gtfs_location_types CASCADE;

CREATE TABLE gtfs_exception_types (
  exception_type INT PRIMARY KEY
  , description TEXT
);

INSERT INTO gtfs_exception_types (exception_type, description) VALUES (1,'schedule added');
INSERT INTO gtfs_exception_types (exception_type, description) VALUES (2,'schedule cancelled');

SELECT * FROM gtfs_exception_types LIMIT 13;


--related to stops(location_type)
create table gtfs_location_types (
  location_type int PRIMARY KEY,
  description text
);

insert into gtfs_location_types(location_type, description) values (0,'stop');
insert into gtfs_location_types(location_type, description) values (1,'station');
insert into gtfs_location_types(location_type, description) values (2,'station entrance');

SELECT * FROM gtfs_location_types LIMIT 13;

COMMIT;
