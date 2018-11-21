-- set storage engine
SET storage_engine=INNODB;

-- drop tables to update everything
DROP TABLE IF EXISTS users_materials;
DROP TABLE IF EXISTS users_centers;

DROP TABLE IF EXISTS materials_handling;
DROP TABLE IF EXISTS materials_disposal;
DROP TABLE IF EXISTS handlingInstructions;
DROP TABLE IF EXISTS disposalInstructions;


DROP TABLE IF EXISTS centers_materials;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS centers;
DROP TABLE IF EXISTS locations;


CREATE TABLE handlingInstructions(
    id int(10) NOT NULL AUTO_INCREMENT,
    instructions varchar(255),
    PRIMARY KEY(id)
);

CREATE TABLE disposalInstructions(
    id int(10) NOT NULL AUTO_INCREMENT,
    instructions varchar(255),
    PRIMARY KEY(id)
);


-- TODO: add centers_materials table (many to many) to associate what centers can accept what materials.
CREATE TABLE centers(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,

    -- https://stackoverflow.com/questions/1159756/how-should-international-geographical-addresses-be-stored-in-a-relational-databas
    street_number int(10) NOT NULL,
    street_direction varchar(2),
    street_name varchar(255) NOT NULL,
    street_type varchar(255) NOT NULL,
    city varchar(255) NOT NULL,
    state varchar(255) NOT NULL,
    zip varchar(255) NOT NULL,
    PRIMARY KEY(id)
);

-- https://stackoverflow.com/questions/2721533/sql-for-opening-hours
CREATE TABLE schedules(
    id int(10) NOT NULL AUTO_INCREMENT,
    day_of_week int(1),
    time_open TIME,
    time_closed TIME,
    cid int(10) NOT NULL,
    FOREIGN KEY(cid) REFERENCES centers(id),
    PRIMARY KEY(id)
);

-- materials(s) the users was written in
CREATE TABLE materials(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,

    -- requires professional disposal
    pro BOOLEAN,


    PRIMARY KEY(id)
);

CREATE TABLE materials_handling(
    mid int(10) NOT NULL,
    hid int(10) NOT NULL,
    FOREIGN KEY(mid) REFERENCES materials(id),
    FOREIGN KEY(hid) REFERENCES handlingInstructions(id),
    PRIMARY KEY(mid, hid)
);

CREATE TABLE materials_disposal(
    mid int(10) NOT NULL,
    did int(10) NOT NULL,
    FOREIGN KEY(mid) REFERENCES materials(id),
    FOREIGN KEY(did) REFERENCES disposalInstructions(id),
    PRIMARY KEY(mid, did)
);

CREATE TABLE centers_materials(
    cid int(10) NOT NULL,
    mid int(10) NOT NULL,
    FOREIGN KEY(cid) REFERENCES centers(id),
    FOREIGN KEY(mid) REFERENCES materials(id),
    PRIMARY KEY(cid, mid)
);

-- users table
CREATE TABLE users(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    -- TODO: add location attribute
    -- TODO: salt and hash password
    password varchar(255),
    notifications boolean,
    PRIMARY KEY(id)
);


-- foreign key table between users and centers
CREATE TABLE users_centers(
    uid int(10) NOT NULL,
    cid int(10) NOT NULL,
    FOREIGN KEY(uid) REFERENCES users(id),
    FOREIGN KEY(cid) REFERENCES centers(id),
    PRIMARY KEY(uid,cid)
);

-- foreign key table between users and materials
CREATE TABLE users_materials(
    uid int(10) NOT NULL,
    mid int(10) NOT NULL,
    FOREIGN KEY(uid) REFERENCES users(id),
    FOREIGN KEY(mid) REFERENCES materials(id),
    PRIMARY KEY(uid,mid)
);


-- populate table of handling instructions (for all materials)
INSERT INTO handlingInstructions(instructions) values ("requires professional disposal");           --1
INSERT INTO handlingInstructions(instructions) values ("do not touch with bare skin");              --2
INSERT INTO handlingInstructions(instructions) values ("handle with care");                         --3
INSERT INTO handlingInstructions(instructions) values ("do not drop");                              --4
INSERT INTO handlingInstructions(instructions) values ("do not mix with ammonia");                  --5
INSERT INTO handlingInstructions(instructions) values ("do not mix with bleach");                   --6
INSERT INTO handlingInstructions(instructions) values ("keep away from flame or high heat");        --7
INSERT INTO handlingInstructions(instructions) values ("do not open in enclosed environment");      --8
INSERT INTO handlingInstructions(instructions) values ("keep away from infants or young children"); --9
INSERT INTO handlingInstructions(instructions) values ("keep away from pets and animals");          --10
INSERT INTO handlingInstructions(instructions) values ("do not mix with vinegar");                  --11
INSERT INTO handlingInstructions(instructions) values ("do not mix with rubbing alcohol");          --12
INSERT INTO handlingInstructions(instructions) values ("wrap in paper and seal in a box");          --13
INSERT INTO handlingInstructions(instructions) values ("do not mix with similar products");         --14
INSERT INTO handlingInstructions(instructions) values ("place within medical sharps container");    --15
INSERT INTO handlingInstructions(instructions) values ("take to local office supply store");        --16

-- populate table of disposal instructions (only for materials that can be disposed of at home)
INSERT INTO disposalInstructions(instructions) values ("dilute with water and pour down the drain");
INSERT INTO disposalInstructions(instructions) values ("dispose of in household trash");
INSERT INTO disposalInstructions(instructions) values ("dispose of in household recycling");
INSERT INTO disposalInstructions(instructions) values ("safe to burn - Contact your county's fire department for 'burn days' and burning protocol");
INSERT INTO disposalInstructions(instructions) values ("dispose of in roadside yard debris container - if available");
INSERT INTO disposalInstructions(instructions) values ("safe to allow to decompose in isolated area on property - can use fertile soil in garden");

-- populate table of materials (PRO DISPOSAL)
INSERT INTO materials(name, pro) values("lead", true);
INSERT INTO materials_handling(mid, hid) values (1, 2);
INSERT INTO materials_handling(mid, hid) values (1, 9);

INSERT INTO materials(name, pro) values("tv", true);
INSERT INTO materials_handling(mid, hid) values (2, 7);

INSERT INTO materials(name, pro) values("cell phone", true);
INSERT INTO materials_handling(mid, hid) values (3, 7);

INSERT INTO materials(name, pro) values("motor oil", true);
INSERT INTO materials_handling(mid, hid) values (4, 7);

INSERT INTO materials(name, pro) values("paint", true);
INSERT INTO materials_handling(mid, hid) values (5, 9);
INSERT INTO materials_handling(mid, hid) values (5, 8);

INSERT INTO materials(name, pro) values("acetone", true);
INSERT INTO materials_handling(mid, hid) values (6, 7);

INSERT INTO materials(name, pro) values("antifreeze", true);
INSERT INTO materials_handling(mid, hid) values (7, 10);

INSERT INTO materials(name, pro) values("boracic acid", true);
INSERT INTO materials_handling(mid, hid) values (8, 2);

INSERT INTO materials(name, pro) values("lighter fluid", true);
INSERT INTO materials_handling(mid, hid) values (9, 7);

INSERT INTO materials(name, pro) values("battery", true);
INSERT INTO materials_handling(mid, hid) values (10, 7);

INSERT INTO materials(name, pro) values("sulfuric acid", true);
INSERT INTO materials_handling(mid, hid) values (11, 2);

INSERT INTO materials(name, pro) values("lye", true);
INSERT INTO materials_handling(mid, hid) values (12, 2);

INSERT INTO materials(name, pro) values("electronics", true);
INSERT INTO materials_handling(mid, hid) values (13, 7);

INSERT INTO materials(name, pro) values("mercury thermometer", true);
INSERT INTO materials_handling(mid, hid) values (14, 2);
INSERT INTO materials_handling(mid, hid) values (14, 8);

INSERT INTO materials(name, pro) values("prescription drugs", true);
INSERT INTO materials_handling(mid, hid) values (15, 9);

INSERT INTO materials(name, pro) values("fluorescent light bulb", true);
INSERT INTO materials_handling(mid, hid) values (16, 4);

INSERT INTO materials(name, pro) values("weed killer", true);
INSERT INTO materials_handling(mid, hid) values (17, 4);

INSERT INTO materials(name, pro) values("smoke detector", true);
INSERT INTO materials_handling(mid, hid) values (18, 4);

INSERT INTO materials(name, pro) values("fireworks", true);
INSERT INTO materials_handling(mid, hid) values (19, 7);

INSERT INTO materials(name, pro) values("tires", true);
INSERT INTO materials_handling(mid, hid) values (20, 4);

INSERT INTO materials(name, pro) values("asbestos", true);
INSERT INTO materials_handling(mid, hid) values (21, 8);

INSERT INTO materials(name, pro) values("treated wood", true);
INSERT INTO materials_handling(mid, hid) values (22, 4);
INSERT INTO materials_handling(mid, hid) values (22, 7);

INSERT INTO materials(name, pro) values("mattress", true);
INSERT INTO materials_handling(mid, hid) values (23, 4);

INSERT INTO materials(name, pro) values("refrigerator", true);
INSERT INTO materials_handling(mid, hid) values (24, 4);

INSERT INTO materials(name, pro) values("medical waste", true);
INSERT INTO materials_handling(mid, hid) values (25, 4);

INSERT INTO materials(name, pro) values("propane", true);
INSERT INTO materials_handling(mid, hid) values (26, 7);

INSERT INTO materials(name, pro) values("gasoline", true);
INSERT INTO materials_handling(mid, hid) values (27, 7);

INSERT INTO materials(name, pro) values("lighter", true);
INSERT INTO materials_handling(mid, hid) values (28, 7);

INSERT INTO materials(name, pro) values("cosmetics", true);
INSERT INTO materials_handling(mid, hid) values (29, 4);

INSERT INTO materials(name, pro) values("toilet bowl cleaner", true);
INSERT INTO materials_handling(mid, hid) values (30, 4);


-- populate table of materials (HOME DISPOSAL)
INSERT INTO materials(name, pro) values("borax", false);
INSERT INTO materials_handling(mid, hid) values(31, 4);
INSERT INTO materials_disposal(mid, did) values(31, 1);

INSERT INTO materials(name, pro) values("drain cleaner", false);
INSERT INTO materials_handling(mid, hid) values(32, 4);
INSERT INTO materials_handling(mid, hid) values(32, 14);
INSERT INTO materials_disposal(mid, did) values(32, 1);

INSERT INTO materials(name, pro) values("alcohol", false);
INSERT INTO materials_handling(mid, hid) values(33, 4);
INSERT INTO materials_disposal(mid, did) values(33, 1);

INSERT INTO materials(name, pro) values("bleach", false);
INSERT INTO materials_handling(mid, hid) values(34, 5);
INSERT INTO materials_handling(mid, hid) values(34, 11);
INSERT INTO materials_handling(mid, hid) values(34, 12);
INSERT INTO materials_disposal(mid, did) values(34, 1);

INSERT INTO materials(name, pro) values("ammonia", false);
INSERT INTO materials_handling(mid, hid) values(35, 6);
INSERT INTO materials_disposal(mid, did) values(35, 1);

INSERT INTO materials(name, pro) values("vinegar", false);
INSERT INTO materials_handling(mid, hid) values(36, 4);
INSERT INTO materials_disposal(mid, did) values(36, 1);

INSERT INTO materials(name, pro) values("windex", false);
INSERT INTO materials_handling(mid, hid) values(37, 4);
INSERT INTO materials_disposal(mid, did) values(37, 1);

INSERT INTO materials(name, pro) values("silica", false);
INSERT INTO materials_handling(mid, hid) values(38, 4);
INSERT INTO materials_disposal(mid, did) values(38, 2);

INSERT INTO materials(name, pro) values("laundry detergent", false);
INSERT INTO materials_handling(mid, hid) values(39, 4);
INSERT INTO materials_disposal(mid, did) values(39, 1);

INSERT INTO materials(name, pro) values("glass", false);
INSERT INTO materials_handling(mid, hid) values(40, 4);
INSERT INTO materials_handling(mid, hid) values(40, 13);
INSERT INTO materials_disposal(mid, did) values(40, 3);

INSERT INTO materials(name, pro) values("toothpaste", false);
INSERT INTO materials_handling(mid, hid) values(41, 4);
INSERT INTO materials_disposal(mid, did) values(41, 1);

INSERT INTO materials(name, pro) values("plastic bag", false);
INSERT INTO materials_handling(mid, hid) values(42, 9);
INSERT INTO materials_disposal(mid, did) values(42, 3);

INSERT INTO materials(name, pro) values("cardboard", false);
INSERT INTO materials_handling(mid, hid) values(43, 4);
INSERT INTO materials_disposal(mid, did) values(43, 3);

INSERT INTO materials(name, pro) values("paper", false);
INSERT INTO materials_handling(mid, hid) values(44, 4);
INSERT INTO materials_disposal(mid, did) values(44, 3);

INSERT INTO materials(name, pro) values("aluminum", false);
INSERT INTO materials_handling(mid, hid) values(45, 4);
INSERT INTO materials_disposal(mid, did) values(45, 3);

INSERT INTO materials(name, pro) values("vhs tape", false);
INSERT INTO materials_handling(mid, hid) values(46, 4);
INSERT INTO materials_disposal(mid, did) values(46, 1);

INSERT INTO materials(name, pro) values("clothing", false);
INSERT INTO materials_handling(mid, hid) values(47, 4);
INSERT INTO materials_disposal(mid, did) values(47, 1);

INSERT INTO materials(name, pro) values("aerosol can", false);
INSERT INTO materials_handling(mid, hid) values(48, 7);
INSERT INTO materials_disposal(mid, did) values(48, 1);

INSERT INTO materials(name, pro) values("glue", false);
INSERT INTO materials_handling(mid, hid) values(49, 8);
INSERT INTO materials_disposal(mid, did) values(49, 1);

INSERT INTO materials(name, pro) values("cooking oil", false);
INSERT INTO materials_handling(mid, hid) values(50, 7);
INSERT INTO materials_disposal(mid, did) values(50, 1);

INSERT INTO materials(name, pro) values("shampoo", false);
INSERT INTO materials_handling(mid, hid) values(51, 4);
INSERT INTO materials_disposal(mid, did) values(51, 2);

INSERT INTO materials(name, pro) values("loose/fallen branches", false);
INSERT INTO materials_disposal(mid, did) values (52, 4);

INSERT INTO materials(name, pro) values("leaves/grass", false);
INSERT INTO materials_handling(mid, hid) values (53, 7);
INSERT INTO materials_disposal(mid, did) values (53, 5);
INSERT INTO materials_disposal(mid, did) values (53, 6);

-- More materials (PRO DISPOSAL)
INSERT INTO materials(name, pro) values("plywood", true);
INSERT INTO materials_handling(mid, hid) values(54, 7);

INSERT INTO materials(name, pro) values("particle board", true);
INSERT INTO materials_handling(mid, hid) values(55, 7);

INSERT INTO materials(name, pro) values("painted/stained wood", true);
INSERT INTO materials_handling(mid, hid) values(56, 7);

INSERT INTO materials(name, pro) values("medical sharps", true);
INSERT INTO materials_handling(mid, hid) values (57, 15);

INSERT INTO materials(name, pro) values("printer ink", true);
INSERT INTO materials_handling(mid, hid) values (58, 16);

INSERT INTO materials(name, pro) values("printer toner", true);
INSERT INTO materials_handling(mid, hid) values (59, 16);


-- populate table of centers
INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Devilish Disposal", 666, "W", "hell", "highway", "hell", "Oregon", "66666");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Cool Disposal Inc.", 123, "S", "cool", "street", "coolsville", "Oregon", "12345");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Disposal R Us", 412, "E", "main", "street", "Portland", "Oregon", "25352");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Eds Disposal Imporium", 241, "N", "ed", "street", "Ed", "Oregon", "23452");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Disposal and Disposal", 426, "E", "disposal", "street", "Corvallis", "Oregon", "23452");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Republic Services", 110, "NE", "walnut", "blvd", "corvallis", "Oregon", "97330");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Corvallis Battery", 516, "SW", "4th", "street", "corvallis", "Oregon", "97333");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Valley Landfills Inc", 28972, "N", "Coffin Butte", "Road", "Corvallis", "Oregon", "97330");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Coffin Butte Landfill", 29175, "N", "Coffin Butte", "Road", "Corvallis", "Oregon", "97330");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Canusa Hershman Recycling", 426, "N", "Wooded Knolls", "Drive", "Corvallis", "Oregon", "97370"); --10

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Burcham's Metals Inc", 3407, "SW", "Pacific", "Boulevard", "Albany", "Oregon", "97321");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Apex Property Clearing & Recycling", 97322, "NE", "Bernard", "Avenue", "Albany", "Oregon", "97322");


------Duplicates start 13 - 22
INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("G&P Recycling Center", 1329, "W", "Jefferson", "Boulevard", "Los Angeles", "California", "90007");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Homeboy Recycling", 1370, "E", "18th", "Street", "Los Angeles", "California", "90021");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("ASI Recycling Center", 5800, "N", "Atherton", "Street", "Long Beach", "California", "90840"); --15

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Greenyard Recycling", 15358, "N", "Beach", "Boulevard", "Westminster", "California", "92683");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("West Coast Recycling Center", 2041, "W", "Commonwealth", "Avenue", "Fullerton", "California", "93833");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Valley Landfills Inc", 28972, "N", "Coffin Butte", "Road", "Corvallis", "Oregon", "97330");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Coffin Butte Landfill", 29175, "N", "Coffin Butte", "Road", "Corvallis", "Oregon", "97330");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Canusa Hershman Recycling", 426, "N", "Wooded Knolls", "Drive", "Corvallis", "Oregon", "97370"); --20

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Burcham's Metals Inc", 3407, "SW", "Pacific", "Boulevard", "Albany", "Oregon", "97321");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Apex Property Clearing & Recycling", 97322, "NE", "Bernard", "Avenue", "Albany", "Oregon", "97322");

---------Duplicates end

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Sandy Transfer Station", 19600, "SE", "Canyon Valley", "Rd", "Sandy", "Oregon", "97055"); --23

-- sandy transfer station (center #23)
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 7, '09:00', '17:00');

-- center 23 materials (sandy transfer station)
INSERT INTO centers_materials(cid, mid) VALUES (23,1);
INSERT INTO centers_materials(cid, mid) VALUES (23,2);
INSERT INTO centers_materials(cid, mid) VALUES (23,3);

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Environmentally Conscious Recycling", 12409, "NE", "San Rafael", "St", "Portland", "Oregon", "97294"); --24

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 1, '09:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 2, '09:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 3, '09:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 4, '09:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 5, '09:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 6, '09:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 7, '09:00', '18:00');

INSERT INTO centers(name, street_number, street_name, street_type, city, state, zip) \
            values("Metro South Transfer Station", 2001, "Washington", "St", "Oregon City", "Oregon", "97045"); --25

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 1, '07:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 2, '07:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 3, '07:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 4, '07:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 5, '07:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 6, '07:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 7, '07:00', '18:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Greenway Recycling", 4135, "NW", "St Helens", "Rd", "Portland","Oregon", "97210"); --26

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 2, '04:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 3, '04:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 4, '04:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 5, '04:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 6, '04:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 7, '08:00', '12:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Good Garbage Junk Removal Hauling and Recycling", 5607, "SE", "Woodstock", "Blvd", "Portland","Oregon", "97206"); --27

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 3, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 4, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 7, '09:00', '17:00');


-- add center schedules (operating days and hours)
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 3, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 4, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (1, 7, '09:00', '17:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (2, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (2, 3, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (2, 4, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (2, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (2, 6, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 1, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 3, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 4, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 6, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (3, 7, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 1, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 2, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 3, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 4, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 5, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 6, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (4, 7, '05:30', '15:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (5, 2, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (5, 3, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (5, 4, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (5, 5, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (5, 6, '06:00', '15:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (6, 2, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (6, 3, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (6, 4, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (6, 5, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (6, 6, '07:30', '17:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (7, 1, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (7, 3, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (7, 4, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (7, 5, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (7, 6, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (7, 7, '08:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 3, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 4, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (8, 7, '09:00', '17:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (9, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (9, 3, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (9, 4, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (9, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (9, 6, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (10, 1, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (10, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (10, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (10, 6, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (10, 7, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (11, 1, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (11, 2, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (11, 3, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (11, 4, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (11, 5, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (11, 6, '05:30', '15:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (12, 2, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (12, 3, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (12, 4, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (12, 5, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (12, 6, '06:00', '15:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (13, 2, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (13, 3, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (13, 4, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (13, 5, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (13, 6, '07:30', '17:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (14, 3, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (14, 4, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (14, 5, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (14, 6, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (14, 7, '08:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 3, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 4, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (15, 7, '09:00', '17:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (16, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (16, 3, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (16, 4, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (16, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (16, 6, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 1, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 3, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 4, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 6, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (17, 7, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 1, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 2, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 3, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 4, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 5, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 6, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (18, 7, '05:30', '15:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (19, 2, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (19, 3, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (19, 4, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (19, 5, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (19, 6, '06:00', '15:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (20, 2, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (20, 3, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (20, 4, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (20, 5, '07:30', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (20, 6, '07:30', '17:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (21, 1, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (21, 3, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (21, 4, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (21, 5, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (21, 6, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (21, 7, '08:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 3, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 4, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (22, 7, '09:00', '17:00');

--Centers and schedules for Austin, TX

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            VALUES ("Household Hazardous Waste Facility", 2514, , "Business Center", "Drive", "Austin", "Texas", 78744);  --28
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 3, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 4, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 7, '09:00', '17:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            VALUES ("Central Texas Refuse", 9316, , "FM812", "Road", "Austin", "Texas", "78719");    --29
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (29, 2, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (29, 3, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (29, 4, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (29, 5, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (29, 6, '08:00', '17:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            VALUES ("Waste Connections", 9904, , "FM812", "Road", "Austin", "Texas", "78719");      --30
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (30, 2, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (30, 3, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (30, 4, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (30, 5, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (30, 6, '08:00', '17:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            VALUES ("Waste Management", 9900, , "Giles", "Lane", "Austin", "Texas", "78754");       --31
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (31, 2, '07:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (31, 3, '07:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (31, 4, '07:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (31, 5, '07:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (31, 6, '07:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (31, 7, '07:00', '17:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            VALUES ("Texas Disposal Systems", 4001, "South", "Ranch", "Road", "Bee Cave", "Texas", "78738");  --32
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (32, 2, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (32, 3, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (32, 4, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (32, 5, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (32, 6, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (32, 2, '08:00', '15:00');

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            VALUES ("Travis County Landfill", 9600, , "FM812", "Road", "Austin", "Texas", "78719");   --33
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (33, 2, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (33, 3, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (33, 4, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (33, 5, '08:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (33, 6, '08:00', '17:00');

INSERT INTO centers_materials (cid, mid) VALUES (28, 4);
INSERT INTO centers_materials (cid, mid) VALUES (28, 3);
INSERT INTO centers_materials (cid, mid) VALUES (28, 6);

INSERT INTO centers_materials (cid, mid) VALUES (29, 2);
INSERT INTO centers_materials (cid, mid) VALUES (29, 10);
INSERT INTO centers_materials (cid, mid) VALUES (29, 15);

INSERT INTO centers_materials (cid, mid) VALUES (30, 8);
INSERT INTO centers_materials (cid, mid) VALUES (30, 12);
INSERT INTO centers_materials (cid, mid) VALUES (30, 10);

INSERT INTO centers_materials (cid, mid) VALUES (31, 13);
INSERT INTO centers_materials (cid, mid) VALUES (31, 9);
INSERT INTO centers_materials (cid, mid) VALUES (31, 7);

INSERT INTO centers_materials (cid, mid) VALUES (32, 1);
INSERT INTO centers_materials (cid, mid) VALUES (32, 6);
INSERT INTO centers_materials (cid, mid) VALUES (32, 8);

INSERT INTO centers_materials (cid, mid) VALUES (33, 1);
INSERT INTO centers_materials (cid, mid) VALUES (33, 2);
INSERT INTO centers_materials (cid, mid) VALUES (33, 3);

/*
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 2, '05:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 3, '05:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 4, '05:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 5, '05:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 6, '05:00', '15:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 1, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 2, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 5, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 6, '06:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (24, 7, '06:00', '18:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 1, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 2, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 3, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 4, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 5, '05:30', '15:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (25, 6, '05:30', '15:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 2, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 3, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 4, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 5, '06:00', '15:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (26, 6, '06:00', '15:00');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 2, '09:00', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 3, '09:00', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 4, '09:00', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 5, '09:00', '17:30');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (27, 6, '09:00', '17:30');

INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 3, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 4, '05:00', '14:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 5, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 6, '08:00', '18:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (28, 7, '05:00', '14:00');
*/

-- center 1 materials
INSERT INTO centers_materials(cid, mid) VALUES (1,1);
INSERT INTO centers_materials(cid, mid) VALUES (1,2);
INSERT INTO centers_materials(cid, mid) VALUES (1,3);

-- center 2 materials
INSERT INTO centers_materials(cid, mid) VALUES (2,1);
INSERT INTO centers_materials(cid, mid) VALUES (2,2);
INSERT INTO centers_materials(cid, mid) VALUES (2,3);

-- center 3 materials
INSERT INTO centers_materials(cid, mid) VALUES (3,1);
INSERT INTO centers_materials(cid, mid) VALUES (3,2);
INSERT INTO centers_materials(cid, mid) VALUES (3,3);








-- Week 2 user stuff

-- add users
INSERT INTO users(name) values("Joel");
INSERT INTO users(name) values("Mike");
INSERT INTO users(name) values("Crow");
INSERT INTO users(name) values("Servo");
INSERT INTO users(name) values("Gypsy");

-- user center recommendation
-- this will be based off of geolocator (which center is closest to user)
INSERT INTO users_centers(uid,cid) values(1,1);
INSERT INTO users_centers(uid,cid) values(2,2);
INSERT INTO users_centers(uid,cid) values(3,1);
INSERT INTO users_centers(uid,cid) values(4,2);
INSERT INTO users_centers(uid,cid) values(5,1);

-- user search history
INSERT INTO users_materials(uid,mid) values(1,1);
INSERT INTO users_materials(uid,mid) values(2,2);
INSERT INTO users_materials(uid,mid) values(3,3);
INSERT INTO users_materials(uid,mid) values(4,4);
INSERT INTO users_materials(uid,mid) values(5,5);
