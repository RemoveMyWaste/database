SELECT D.instructions FROM materials_disposal MD
INNER JOIN materials M on M.id = MD.mid
INNER JOIN disposalInstructions D on D.id = MD.did
WHERE (M.name = ?);
