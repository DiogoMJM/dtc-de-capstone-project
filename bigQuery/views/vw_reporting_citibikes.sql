CREATE OR REPLACE VIEW `dtc_de_cp_dmjm_dataset.vw_reporting_citibike_rides`
AS
  SELECT
    ride_id AS `RideId`
    ,CAST(started_at AS DATE) AS `StartedAt`
    ,INITCAP(member_casual) AS `RiderType`
    ,INITCAP(LEFT(rideable_type, INSTR(rideable_type,'_') - 1)) AS `BikeType`
    ,EXTRACT(HOUR FROM started_at) AS `HourOfTheDay`
    ,TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS `DurationMinutes`
    ,FORMAT_DATE('%A', started_at) AS `Weekday`
    ,start_station_name AS `StartStationName`
    ,end_station_name AS `EndStationName`
  FROM `dtc_de_cp_dmjm_dataset.citibike_tripdata`