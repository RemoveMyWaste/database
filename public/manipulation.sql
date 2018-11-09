/*
liam beckman
13 august 2018
Project Step 5: Final Working Project
*/

------------------------------
-- SEARCH
------------------------------

-- search entities
SELECT * FROM program WHERE (program.name LIKE "%"[users search]"%" OR program.purpose LIKE "%"[users search]"%");
SELECT * FROM author WHERE (author.name LIKE "%"[users search]"%");
SELECT * FROM language WHERE (language.name LIKE "%"[users search]"%");
SELECT * FROM os WHERE (os.name LIKE "%"[users search]"%");
SELECT * FROM src WHERE (src.url LIKE "%"[users search]"%");

-- search relationships
SELECT DISTINCT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA 
INNER JOIN program P ON PA.pid = P.id 
INNER JOIN author A ON PA.aid = A.id WHERE (P.name LIKE "%"[users search]"%") OR (A.name LIKE "%"[users search]"%");

SELECT DISTINCT L.id AS lid, P.id AS pid, L.name AS lname, P.name AS pname FROM program_language PL 
INNER JOIN program P ON PL.pid = P.id 
INNER JOIN language L ON PL.lid = L.id WHERE (P.name LIKE "%"[users search]"%") OR (L.name LIKE "%"[users search]"%");

SELECT DISTINCT O.id AS oid, P.id AS pid, O.name AS oname, P.name AS pname FROM program_os PO 
INNER JOIN program P ON PO.oid = P.id 
INNER JOIN os O ON PO.oid = O.id WHERE (P.name LIKE "%"[users search]"%") OR (O.name LIKE "%"[users search]"%");


------------------------------
-- READ
------------------------------

-- populate tables for entities 
SELECT * FROM program;
SELECT * FROM author;
SELECT * FROM language;
SELECT * FROM os;
SELECT * FROM src;

-- view program names for each source
SELECT S.id, S.url, S.type, S.pid, P.name FROM src S 
INNER JOIN program P on S.pid = P.id;

-- populate tables for relationships
-- program_language
SELECT L.id AS lid, P.id AS pid, L.name AS lname, P.name AS pname FROM program_language PL 
INNER JOIN program P ON PL.pid = P.id 
INNER JOIN language L ON PL.lid = L.id;

-- program_author
SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA 
INNER JOIN program P ON PA.pid = P.id 
INNER JOIN author A ON PA.aid = A.id;

-- program_os
SELECT O.id AS oid, P.id AS pid, O.name AS oname, P.name AS pname FROM program_os PO 
INNER JOIN program P ON PO.pid = P.id 
INNER JOIN os O ON PO.oid = O.id;


------------------------------
-- INSERT
------------------------------

INSERT INTO program (name, purpose, url, version, license) VALUES ([users name], [users purpose], [users url], [users version], [users license]);

INSERT INTO author (name, url) VALUES ([users name], [users url]);

INSERT INTO language (name, url) VALUES ([users name], [users url])";

INSERT INTO os (name, url) VALUES ([users name], [users url])";

INSERT INTO src (url, type, pid) VALUES ([users url], [users type], [selected program id])";

INSERT INTO program_language(pid, lid) VALUES ((SELECT id FROM program WHERE name = [selected program name]), (SELECT id FROM language WHERE name = [selected language name]))";

INSERT INTO program_author(pid, aid) VALUES ((SELECT id FROM program WHERE name = [selected program name]), (SELECT id FROM author WHERE name = [selected author name]))";

INSERT INTO program_os(pid, oid) VALUES ((SELECT id FROM program WHERE name = [selected program name]), (SELECT id FROM os WHERE name = [selected os name]))";


------------------------------
-- DELETE
------------------------------

-- program_language
sql= "DELETE FROM [table name] WHERE pid=[program id] AND lid=[language id];

-- program_author
sql= "DELETE FROM [table name] WHERE pid=[program id] AND aid=[author id];

-- program_os
sql= "DELETE FROM [table name] WHERE pid=[program id] AND oid=[os id];

-- all other entities
sql= "DELETE FROM [table name] WHERE id=[row id];


------------------------------
-- EDIT
------------------------------

-- program
SELECT * FROM program WHERE id=[program id];

-- author
SELECT * FROM author WHERE id=[author id];

-- language
SELECT * FROM language WHERE id=[language id];

-- os
SELECT * FROM os WHERE id=[os id];

-- src
SELECT * FROM src WHERE id=[src id];

-- program_author
SELECT A.id AS aid, P.id AS pid, A.name AS aname, P.name AS pname FROM program_author PA 
INNER JOIN program P ON PA.pid = P.id 
INNER JOIN author A ON PA.aid = A.id WHERE P.id = [program id] AND A.id = [author id];

-- program_language
SELECT L.id AS lid, P.id AS pid, L.name AS lname, P.name AS pname FROM program_language PL 
INNER JOIN program P ON PL.pid = P.id 
INNER JOIN language L ON PL.lid = L.id WHERE P.id = [program id] AND L.id = [language id];

-- program_os
SELECT O.id AS oid, P.id AS pid, O.name AS oname, P.name AS pname FROM program_os PO 
INNER JOIN program P ON PO.pid = P.id 
INNER JOIN os O ON PO.oid = O.id WHERE P.id = [program id] AND O.id = [os id];


------------------------------
-- UPDATE
------------------------------

-- program
UPDATE program SET name=[users name], purpose=[users purpose], url=[users url], version=[users version], license=[users license] WHERE id=[program id];

-- author
UPDATE author SET name=[users name], url=[users url]  WHERE id=[author id];

-- language
UPDATE language SET name=[users name], url=[users url]  WHERE id=[language id];

-- os
UPDATE os SET name=[users name], url=[users url]  WHERE id=[os id];

-- src
UPDATE src SET url=[users url], type=[users type], pid=(SELECT id FROM program WHERE name = [select program name]) WHERE id=[src id];

-- program_author
UPDATE program_author SET pid=[new program id], aid=[new author id] WHERE pid=[old program id] AND aid=[old author id];

-- program_language
UPDATE program_language SET pid=[new program id], lid=[new language id] WHERE pid=[old program id] AND lid=[old language id];

-- program_os
UPDATE program_os SET pid=[new program id], oid=[new os id] WHERE pid=[old program id] AND oid=[old os id];


------------------------------
-- MISC
------------------------------

-- count number of entities on home page
SELECT COUNT(*) AS num FROM program;
SELECT COUNT(*) AS num FROM src;
SELECT COUNT(*) AS num FROM author;
SELECT COUNT(*) AS num FROM os;
SELECT COUNT(*) AS num FROM language;

-- count the number of programs that are written in a particular language
SELECT P.name, COUNT(*) AS programCount
FROM program P

INNER JOIN program_language PL ON PL.pid = P.id

INNER JOIN language L ON PL.lid = L.id
GROUP BY L.name;

-- count the number of programs that are written for a particular operating system
SELECT P.name, COUNT(*) AS programCount
FROM program P

INNER JOIN program_os PO ON PO.pid = P.id

INNER JOIN os O ON PO.oid = O.id
GROUP BY O.name;


