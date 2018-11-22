SELECT M.name FROM centers_materials CM
INNER JOIN centers C ON C.id = CM.CID
INNER JOIN materials M ON M.id = CM.MID
WHERE (C.id = 1);

/*
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
WHERE (cid = 1);
*/

/*
SELECT C.name, C.street_number, C.street_direction, C.street_name, C.street_type, C.city, C.state, C.zip FROM centers_materials CM
INNER JOIN centers C ON C.id = CM.CID
INNER JOIN materials M ON M.id = CM.MID
WHERE (M.name = 'tv');
*/


/*
SELECT H.instructions FROM materials_handling MH 
INNER JOIN materials M ON M.id = MH.mid
INNER JOIN handlingInstructions H ON H.id = MH.HID
WHERE (M.name = 'tv');
*/

        -- sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;

    --sql = 'SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA INNER JOIN program P ON PA.pid = P.id INNER JOIN author A ON PA.aid = A.id';
