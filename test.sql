SELECT S.day_of_week,
CASE
    WHEN S.day_of_week > 1 THEN "Sunday"
    WHEN S.day_of_week > 2 THEN "Monday"
    WHEN S.day_of_week > 3 THEN "Tuesday"
    WHEN S.day_of_week > 4 THEN "Wednesday"
    WHEN S.day_of_week > 5 THEN "Thursday"
    WHEN S.day_of_week > 6 THEN "Friday"
    WHEN S.day_of_week > 7 THEN "Saturday"
    ELSE "invalid day number"
END
FROM schedules S;
