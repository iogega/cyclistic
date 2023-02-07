-- Winter
SELECT member_casual, APPROX_TOP_COUNT(day_of_week, 1) AS mode_day_of_week
FROM `cyclistic-344413.trip_data.combined_data`
WHERE started_at BETWEEN '2021-12-01 00:00:00' AND '2022-01-31 23:59:59'
OR started_at BETWEEN '2021-02-01 00:00:00' AND '2021-02-28 23:59:59'
GROUP BY member_casual

-- Spring
SELECT member_casual, APPROX_TOP_COUNT(day_of_week, 1) AS mode_day_of_week
FROM `cyclistic-344413.trip_data.combined_data`
WHERE started_at BETWEEN '2021-03-01 00:00:00' AND '2021-05-31 23:59:59'
GROUP BY member_casual

-- Summer
SELECT member_casual, APPROX_TOP_COUNT(day_of_week, 1) AS mode_day_of_week
FROM `cyclistic-344413.trip_data.combined_data`
WHERE started_at BETWEEN '2021-06-01 00:00:00' AND '2021-08-31 23:59:59'
GROUP BY member_casual

-- Autumn
SELECT member_casual, APPROX_TOP_COUNT(day_of_week, 1) AS mode_day_of_week
FROM `cyclistic-344413.trip_data.combined_data`
WHERE started_at BETWEEN '2021-09-01 00:00:00' AND '2021-11-30 23:59:59'
GROUP BY member_casual
