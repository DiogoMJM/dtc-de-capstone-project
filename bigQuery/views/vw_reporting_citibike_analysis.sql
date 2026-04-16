CREATE OR REPLACE VIEW `dtc_de_cp_dmjm_dataset.vw_reporting_citibike_analysis`
AS
  SELECT
    cr.`StartedAt`
    ,cr.`RiderType`
    ,cr.`BikeType`
    ,cr.`HourOfTheDay`
    ,cr.`DurationMinutes`
    ,cr.`Weekday`
    ,cr.`StartStationName`
    ,cr.`EndStationName`
    ,w.`AverageTemperature`
    ,w.`TemperatureCategory`
    ,w.`Rain`
    ,w.`RainCategory`
    ,w.`Snow`
    ,w.`SnowCategory`
    ,w.`WindSpeed`
    ,w.`WindCategory`
  FROM `dtc_de_cp_dmjm_dataset.vw_reporting_citibike_rides` cr
  INNER JOIN `dtc_de_cp_dmjm_dataset.vw_reporting_weather` w
    ON cr.`StartedAt` = w.`Date`