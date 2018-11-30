SELECT S.time_open, S.time_closed,
CASE
    WHEN S.day_of_week = 1 THEN "sunday"
    WHEN S.day_of_week = 2 THEN "monday"
    WHEN S.day_of_week = 3 THEN "tuesday"
    WHEN S.day_of_week = 4 THEN "wednesday"
    WHEN S.day_of_week = 5 THEN "thursday"
    WHEN S.day_of_week = 6 THEN "friday"
    WHEN S.day_of_week = 7 THEN "saturday"
    ELSE "invalid day number"
END AS day_of_week
FROM centers C INNER JOIN schedules S ON C.id = S.cid
WHERE (C.name = "Apex Property Clearing & Recycling");
