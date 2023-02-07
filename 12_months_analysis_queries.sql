-- Combined 12 months data
CREATE TABLE trip_data.combined_data AS (
  SELECT * FROM `cyclistic-344413.trip_data.2021_02`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_03`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_04`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_05`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_06`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_07`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_08`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_09`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_10`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_11`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2021_12`
  UNION ALL
  SELECT * FROM `cyclistic-344413.trip_data.2022_01`
)

-- Ride length
ALTER TABLE trip_data.combined_data
ADD COLUMN ride_length INTEGER

UPDATE `cyclistic-344413.trip_data.combined_data`
SET ride_length = TIMESTAMP_DIFF(ended_at, started_at, MINUTE)
WHERE true

-- Day of the week
ALTER TABLE trip_data.combined_data
ADD COLUMN day_of_week STRING

UPDATE `cyclistic-344413.trip_data.combined_data`
SET day_of_week = CASE WHEN EXTRACT(DAYOFWEEK FROM started_at) = 1 THEN 'Sunday'
      WHEN EXTRACT(DAYOFWEEK FROM started_at) = 2 THEN 'Monday'
      WHEN EXTRACT(DAYOFWEEK FROM started_at) = 3 THEN 'Tuesday'
      WHEN EXTRACT(DAYOFWEEK FROM started_at) = 4 THEN 'Wednesday'
      WHEN EXTRACT(DAYOFWEEK FROM started_at) = 5 THEN 'Thursday'
      WHEN EXTRACT(DAYOFWEEK FROM started_at) = 6 THEN 'Friday'
    ELSE 'Saturday'
  END
WHERE true

-- Test rides removal
DELETE FROM `cyclistic-344413.trip_data.combined_data`
WHERE start_station_id LIKE '%(LBS-WH-TEST)%'
OR end_station_id LIKE '%(LBS-WH-TEST)%'

-- Part of the day
UPDATE `cyclistic-344413.trip_data.combined_data`
SET part_of_day = CASE WHEN EXTRACT(TIME FROM started_at) BETWEEN '05:00:00' AND '11:59:59' THEN 'Morning'
      WHEN EXTRACT(TIME FROM started_at) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
      WHEN EXTRACT(TIME FROM started_at) BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening'
    ELSE 'Night'
  END
WHERE true

-- Removing outliers in ride length
DELETE FROM `cyclistic-344413.trip_data.combined_data`
WHERE ride_length <= 0 OR ride_length > 1560

-- Average ride length
SELECT member_casual, AVG(ride_length) AS average_ride_length
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY member_casual

-- Maximum ride length
SELECT member_casual, MAX(ride_length) AS max_ride_length
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY member_casual

-- Mode of day of the week
SELECT member_casual, APPROX_TOP_COUNT(day_of_week, 3) AS mode_day_of_week
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY member_casual

-- Average ride length by day of the week
SELECT day_of_week,
(CASE WHEN member_casual = 'member' THEN AVG(ride_length) END) AS avg_member,
(CASE WHEN member_casual = 'casual' THEN AVG(ride_length) END) AS avg_casual
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY day_of_week, member_casual
ORDER BY member_casual

-- Number of rides for users by day of the week
SELECT
day_of_week,
COUNT(DISTINCT ride_id) AS total_rides,
SUM(CASE WHEN member_casual = 'member' THEN 1 END) AS member_rides,
SUM(CASE WHEN member_casual = 'casual' THEN 1 END) AS casual_rides
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY 1

-- Number of rides by rideable type
SELECT
member_casual,
COUNT(CASE WHEN rideable_type = 'classic_bike' THEN 1 END) AS classic_bike_rides,
COUNT(CASE WHEN rideable_type = 'docked_bike' THEN 1 END) AS docked_bike_rides,
COUNT(CASE WHEN rideable_type = 'electric_bike' THEN 1 END) AS electric_bike_rides
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY 1

-- Rides according to time of the day
SELECT member_casual,part_of_day, COUNT(ride_id) AS total_rides
FROM `cyclistic-344413.trip_data.combined_data`
GROUP BY part_of_day, member_casual
ORDER BY  member_casual ASC
