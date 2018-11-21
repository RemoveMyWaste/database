SELECT H.instructions FROM materials_handling MH 
INNER JOIN materials M ON M.id = MH.mid
INNER JOIN handlingInstructions H ON H.id = MH.HID
WHERE (M.name = 'tv');

        -- sql = `SELECT * FROM materials WHERE (materials.name LIKE "%"?"%")`;

    --sql = 'SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA INNER JOIN program P ON PA.pid = P.id INNER JOIN author A ON PA.aid = A.id';
