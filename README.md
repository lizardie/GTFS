# GTFS
My little games with GTFS.

I start by processing GTFS for Sweden using Postgres with PostGIS on localhost. I download the data locally to my comp (and unzip even though probably not necessary).

## Data sources
* Download historic data from here https://data.samtrafiken.se/trafiklab/gtfs-sverige-2/
* Docs here https://www.trafiklab.se/api/gtfs-sverige-2/dokumentation

## Set up

Create the DB (in terminal on Mac) > run `setup_db_in_pg.sh`

Put unzipped data here in raw data folder.
All files have this naming structure
```
sweden-20200227
sweden-20200326
sweden-20200611
sweden-20200910
sweden-20201210
```

## Create schema tables and load data

I opted into putting each date data in separate tables. But I plan to devp it later and perhaps put all together. There are some issues with merging and overlapping of GTFS data. I looked at this reference: Zeches, L. F. (2019). Merging of Overlapping GTFS Feeds. 61. But eventually I decided to keep the dates just separate. This generates some double work. Perhaps later I'll make a loop over the folders if I need to process more days. But for 6 days this was the fast and dumb hands-on solution.

## Useful sources of inspiration

I looked in those sources below when making a schema and extra tables. Some adjustments were made for the Swedish data with some columns or tables not existing (e.g. shapes).

* https://github.com/tyleragreen/gtfs-schema.git
* https://github.com/laidig/gtfs-in-postgis-experiments.git

Some more useful links:
* https://marcinstepniak.eu/projects/calculus/main_results/gtfs_study/
