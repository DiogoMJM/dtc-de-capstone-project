CREATE OR REPLACE VIEW `dtc_de_cp_dmjm_dataset.vw_reporting_weather`
AS
  SELECT
    datetime AS `Date`
    ,temp AS `AverageTemperature`
    ,CASE 
          WHEN temp < 32 THEN 'Freezing'
          WHEN temp BETWEEN 32 AND 50 THEN 'Cold'
          WHEN temp BETWEEN 50.1 AND 70 THEN 'Mild'
          WHEN temp BETWEEN 70.1 AND 85 THEN 'Warm'
          ELSE 'Hot'
    END AS `TemperatureCategory`
    ,precip AS `Rain`
    ,CASE 
          WHEN precip = 0 THEN 'No Rain'
          WHEN precip BETWEEN 0.01 AND 0.1 THEN 'Light Rain'
          WHEN precip BETWEEN 0.11 AND 0.5 THEN 'Moderate Rain'
          ELSE 'Heavy Rain'
    END AS `RainCategory`
    ,snow AS `Snow`
    ,CASE 
          WHEN snow = 0 THEN 'No Snow'
          WHEN snow BETWEEN 0.01 AND 2.0 THEN 'Light Snow'
          WHEN snow > 2.0 THEN 'Heavy Snow/Storm'
          ELSE 'No Snow'
    END AS `SnowCategory`
    ,windspeed AS `WindSpeed`
    ,CASE 
          WHEN windspeed < 10 THEN 'Calm'
          WHEN windspeed BETWEEN 10 AND 20 THEN 'Breezy'
          ELSE 'Windy'
    END AS `WindCategory`
    ,conditions AS `Conditions`
  FROM `dtc_de_cp_dmjm_dataset.nyc_weather_data`