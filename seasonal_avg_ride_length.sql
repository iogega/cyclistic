-- Winter
SELECT member_casual, AVG(ride_length) AS avg_ride_length
FROM `cyclistic-344413.trip_data.combined_data`
WHERE started_at BETWEEN '2021-12-01 00:00:00' AND '2022-01-31 23:59:59'
OR started_at BETWEEN '2021-02-01 00:00:00' AND '2021-02-28 23:59:59'
GROUP BY member_casual
