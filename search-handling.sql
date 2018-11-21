SELECT C.name, C.street_number, C.street_direction, C.street_name, C.street_type, C.city, C.state, C.zip FROM centers_materials CM
INNER JOIN centers C ON C.id = CM.CID
INNER JOIN materials M ON M.id = CM.MID
WHERE (M.name = 'tv');


/*
SELECT H.instructions FROM materials_handling MH 
INNER JOIN materials M ON M.id = MH.mid
INNER JOIN handlingInstructions H ON H.id = MH.HID
WHERE (M.name = 'tv');
*/

        -- sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;

    --sql = 'SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA INNER JOIN program P ON PA.pid = P.id INNER JOIN author A ON PA.aid = A.id';
