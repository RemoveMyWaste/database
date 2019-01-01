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
    street_number int(10),
    street_direction varchar(2),
    street_name varchar(255),
    street_type varchar(255),
    city varchar(255),
    state varchar(255),
    zip varchar(255),
    PRIMARY KEY(id)
);


-- https://stackoverflow.com/questions/2721533/sql-for-opening-hours
CREATE TABLE schedules(
    id int(10) NOT NULL AUTO_INCREMENT,
    day_of_week int(1),
    time_open varchar(255),
    time_closed varchar(255),
    cid int(10) NOT NULL,
    FOREIGN KEY(cid) REFERENCES centers(id),
    PRIMARY KEY(id)
);

-- materials(s) the users was written in
CREATE TABLE materials(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,

    -- requires professional disposal
    pro BOOLEAN NOT NULL,


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

INSERT INTO centers(name, street_number, street_name, street_type, city, state, zip) \
            values("San Francisco Transfer Station", 501, "Tunnel", "Avenue", "San Francisco", "California", "94134");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Oakland Household Hazardous Waste Facility", 2100, "E", "7th", "Street", "Oakland", "California", "94606");

INSERT INTO centers(name, street_number, street_name, street_type, city, state, zip) \
            values("Tri-CED Community Recycling", 33377,"Western", "Avenue", "Union City", "California", "94587"); --20

INSERT INTO centers(name, street_number, street_name, street_type, city, state, zip) \
            values("Fremont Recycling and Transfer Station", 41149, "Boyce", "Road", "Fremont", "California", "94538");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Hayward Drop-Off Facility", 2091, "W", "Winton", "Avenue", "Hayward", "California", "94545");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Sandy Transfer Station", 19600, "SE", "Canyon Valley", "Rd", "Sandy", "Oregon", "97055"); --23

-- sandy transfer station (center #23)
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 1, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 2, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 5, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 6, '09:00', '17:00');
INSERT INTO schedules(cid, day_of_week, time_open, time_closed) VALUES (23, 7, '09:00', '17:00');

-- add centers

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

-- add centers_materials, starting with center 1 (Devilish Disposal)
INSERT INTO centers_materials(cid, mid) VALUES (1,1);
INSERT INTO centers_materials(cid, mid) VALUES (1,2);
INSERT INTO centers_materials(cid, mid) VALUES (1,3);

-- center 2 materials (Cool Disposal, Inc)
INSERT INTO centers_materials(cid, mid) VALUES (2,1);
INSERT INTO centers_materials(cid, mid) VALUES (2,2);
INSERT INTO centers_materials(cid, mid) VALUES (2,3);

-- center 3 materials (Disposal R Us)
INSERT INTO centers_materials(cid, mid) VALUES (3,1);
INSERT INTO centers_materials(cid, mid) VALUES (3,2);
INSERT INTO centers_materials(cid, mid) VALUES (3,3);

-- center 4 materials (Eds Disposal Imporium)
INSERT INTO centers_materials(cid, mid) VALUES (4,1);
INSERT INTO centers_materials(cid, mid) VALUES (4,2);
INSERT INTO centers_materials(cid, mid) VALUES (4,3);

-- center 5 materials (Disposal and Disposal)
INSERT INTO centers_materials(cid, mid) VALUES (5,1);
INSERT INTO centers_materials(cid, mid) VALUES (5,2);
INSERT INTO centers_materials(cid, mid) VALUES (5,3);

-- center 6 materials (Corvallis Republic Services)
INSERT INTO centers_materials(cid, mid) VALUES (6,2);
INSERT INTO centers_materials(cid, mid) VALUES (6,20);
INSERT INTO centers_materials(cid, mid) VALUES (6,22);
INSERT INTO centers_materials(cid, mid) VALUES (6,23);
INSERT INTO centers_materials(cid, mid) VALUES (6,29);
INSERT INTO centers_materials(cid, mid) VALUES (6,33);
INSERT INTO centers_materials(cid, mid) VALUES (6,36);
INSERT INTO centers_materials(cid, mid) VALUES (6,38);
INSERT INTO centers_materials(cid, mid) VALUES (6,39);
INSERT INTO centers_materials(cid, mid) VALUES (6,40);
INSERT INTO centers_materials(cid, mid) VALUES (6,41);
INSERT INTO centers_materials(cid, mid) VALUES (6,42);
INSERT INTO centers_materials(cid, mid) VALUES (6,43);
INSERT INTO centers_materials(cid, mid) VALUES (6,44);
INSERT INTO centers_materials(cid, mid) VALUES (6,45);
INSERT INTO centers_materials(cid, mid) VALUES (6,47);
INSERT INTO centers_materials(cid, mid) VALUES (6,48);
INSERT INTO centers_materials(cid, mid) VALUES (6,49);
INSERT INTO centers_materials(cid, mid) VALUES (6,51);
INSERT INTO centers_materials(cid, mid) VALUES (6,52);
INSERT INTO centers_materials(cid, mid) VALUES (6,53);
INSERT INTO centers_materials(cid, mid) VALUES (6,54);
INSERT INTO centers_materials(cid, mid) VALUES (6,55);
INSERT INTO centers_materials(cid, mid) VALUES (6,56);
INSERT INTO centers_materials(cid, mid) VALUES (6,58);
INSERT INTO centers_materials(cid, mid) VALUES (6,59);

-- center 7 materials (Corvallis Battery)
INSERT INTO centers_materials(cid, mid) VALUES (7,2);
INSERT INTO centers_materials(cid, mid) VALUES (7,3);
INSERT INTO centers_materials(cid, mid) VALUES (7,10);
INSERT INTO centers_materials(cid, mid) VALUES (7,13);
INSERT INTO centers_materials(cid, mid) VALUES (7,24);

-- center 8 materials (Valley Landfills Inc)
INSERT INTO centers_materials(cid, mid) VALUES (8,1);
INSERT INTO centers_materials(cid, mid) VALUES (8,2);
INSERT INTO centers_materials(cid, mid) VALUES (8,3);
INSERT INTO centers_materials(cid, mid) VALUES (8,4);
INSERT INTO centers_materials(cid, mid) VALUES (8,5);
INSERT INTO centers_materials(cid, mid) VALUES (8,6);
INSERT INTO centers_materials(cid, mid) VALUES (8,7);
INSERT INTO centers_materials(cid, mid) VALUES (8,8);
INSERT INTO centers_materials(cid, mid) VALUES (8,9);
INSERT INTO centers_materials(cid, mid) VALUES (8,10);
INSERT INTO centers_materials(cid, mid) VALUES (8,11);
INSERT INTO centers_materials(cid, mid) VALUES (8,12);
INSERT INTO centers_materials(cid, mid) VALUES (8,13);
INSERT INTO centers_materials(cid, mid) VALUES (8,14);
INSERT INTO centers_materials(cid, mid) VALUES (8,15);
INSERT INTO centers_materials(cid, mid) VALUES (8,16);
INSERT INTO centers_materials(cid, mid) VALUES (8,17);
INSERT INTO centers_materials(cid, mid) VALUES (8,18);
INSERT INTO centers_materials(cid, mid) VALUES (8,19);
INSERT INTO centers_materials(cid, mid) VALUES (8,20);
INSERT INTO centers_materials(cid, mid) VALUES (8,21);
INSERT INTO centers_materials(cid, mid) VALUES (8,22);
INSERT INTO centers_materials(cid, mid) VALUES (8,23);
INSERT INTO centers_materials(cid, mid) VALUES (8,24);
INSERT INTO centers_materials(cid, mid) VALUES (8,25);
INSERT INTO centers_materials(cid, mid) VALUES (8,26);
INSERT INTO centers_materials(cid, mid) VALUES (8,27);
INSERT INTO centers_materials(cid, mid) VALUES (8,28);
INSERT INTO centers_materials(cid, mid) VALUES (8,29);
INSERT INTO centers_materials(cid, mid) VALUES (8,30);
INSERT INTO centers_materials(cid, mid) VALUES (8,31);
INSERT INTO centers_materials(cid, mid) VALUES (8,32);
INSERT INTO centers_materials(cid, mid) VALUES (8,33);
INSERT INTO centers_materials(cid, mid) VALUES (8,34);
INSERT INTO centers_materials(cid, mid) VALUES (8,35);
INSERT INTO centers_materials(cid, mid) VALUES (8,36);
INSERT INTO centers_materials(cid, mid) VALUES (8,37);
INSERT INTO centers_materials(cid, mid) VALUES (8,38);
INSERT INTO centers_materials(cid, mid) VALUES (8,39);
INSERT INTO centers_materials(cid, mid) VALUES (8,40);
INSERT INTO centers_materials(cid, mid) VALUES (8,41);
INSERT INTO centers_materials(cid, mid) VALUES (8,42);
INSERT INTO centers_materials(cid, mid) VALUES (8,43);
INSERT INTO centers_materials(cid, mid) VALUES (8,44);
INSERT INTO centers_materials(cid, mid) VALUES (8,45);
INSERT INTO centers_materials(cid, mid) VALUES (8,46);
INSERT INTO centers_materials(cid, mid) VALUES (8,47);
INSERT INTO centers_materials(cid, mid) VALUES (8,48);
INSERT INTO centers_materials(cid, mid) VALUES (8,49);
INSERT INTO centers_materials(cid, mid) VALUES (8,50);
INSERT INTO centers_materials(cid, mid) VALUES (8,51);
INSERT INTO centers_materials(cid, mid) VALUES (8,52);
INSERT INTO centers_materials(cid, mid) VALUES (8,53);
INSERT INTO centers_materials(cid, mid) VALUES (8,54);
INSERT INTO centers_materials(cid, mid) VALUES (8,55);
INSERT INTO centers_materials(cid, mid) VALUES (8,56);
INSERT INTO centers_materials(cid, mid) VALUES (8,57);
INSERT INTO centers_materials(cid, mid) VALUES (8,58);
INSERT INTO centers_materials(cid, mid) VALUES (8,59);

-- center 9 materials (Coffin Butte Landfill)
INSERT INTO centers_materials(cid, mid) VALUES (9,1);
INSERT INTO centers_materials(cid, mid) VALUES (9,2);
INSERT INTO centers_materials(cid, mid) VALUES (9,3);
INSERT INTO centers_materials(cid, mid) VALUES (9,4);
INSERT INTO centers_materials(cid, mid) VALUES (9,5);
INSERT INTO centers_materials(cid, mid) VALUES (9,6);
INSERT INTO centers_materials(cid, mid) VALUES (9,7);
INSERT INTO centers_materials(cid, mid) VALUES (9,8);
INSERT INTO centers_materials(cid, mid) VALUES (9,9);
INSERT INTO centers_materials(cid, mid) VALUES (9,10);
INSERT INTO centers_materials(cid, mid) VALUES (9,11);
INSERT INTO centers_materials(cid, mid) VALUES (9,12);
INSERT INTO centers_materials(cid, mid) VALUES (9,13);
INSERT INTO centers_materials(cid, mid) VALUES (9,14);
INSERT INTO centers_materials(cid, mid) VALUES (9,15);
INSERT INTO centers_materials(cid, mid) VALUES (9,16);
INSERT INTO centers_materials(cid, mid) VALUES (9,17);
INSERT INTO centers_materials(cid, mid) VALUES (9,18);
INSERT INTO centers_materials(cid, mid) VALUES (9,19);
INSERT INTO centers_materials(cid, mid) VALUES (9,20);
INSERT INTO centers_materials(cid, mid) VALUES (9,21);
INSERT INTO centers_materials(cid, mid) VALUES (9,22);
INSERT INTO centers_materials(cid, mid) VALUES (9,23);
INSERT INTO centers_materials(cid, mid) VALUES (9,24);
INSERT INTO centers_materials(cid, mid) VALUES (9,25);
INSERT INTO centers_materials(cid, mid) VALUES (9,26);
INSERT INTO centers_materials(cid, mid) VALUES (9,27);
INSERT INTO centers_materials(cid, mid) VALUES (9,28);
INSERT INTO centers_materials(cid, mid) VALUES (9,29);
INSERT INTO centers_materials(cid, mid) VALUES (9,30);
INSERT INTO centers_materials(cid, mid) VALUES (9,31);
INSERT INTO centers_materials(cid, mid) VALUES (9,32);
INSERT INTO centers_materials(cid, mid) VALUES (9,33);
INSERT INTO centers_materials(cid, mid) VALUES (9,34);
INSERT INTO centers_materials(cid, mid) VALUES (9,35);
INSERT INTO centers_materials(cid, mid) VALUES (9,36);
INSERT INTO centers_materials(cid, mid) VALUES (9,37);
INSERT INTO centers_materials(cid, mid) VALUES (9,38);
INSERT INTO centers_materials(cid, mid) VALUES (9,39);
INSERT INTO centers_materials(cid, mid) VALUES (9,40);
INSERT INTO centers_materials(cid, mid) VALUES (9,41);
INSERT INTO centers_materials(cid, mid) VALUES (9,42);
INSERT INTO centers_materials(cid, mid) VALUES (9,43);
INSERT INTO centers_materials(cid, mid) VALUES (9,44);
INSERT INTO centers_materials(cid, mid) VALUES (9,45);
INSERT INTO centers_materials(cid, mid) VALUES (9,46);
INSERT INTO centers_materials(cid, mid) VALUES (9,47);
INSERT INTO centers_materials(cid, mid) VALUES (9,48);
INSERT INTO centers_materials(cid, mid) VALUES (9,49);
INSERT INTO centers_materials(cid, mid) VALUES (9,50);
INSERT INTO centers_materials(cid, mid) VALUES (9,51);
INSERT INTO centers_materials(cid, mid) VALUES (9,52);
INSERT INTO centers_materials(cid, mid) VALUES (9,53);
INSERT INTO centers_materials(cid, mid) VALUES (9,54);
INSERT INTO centers_materials(cid, mid) VALUES (9,55);
INSERT INTO centers_materials(cid, mid) VALUES (9,56);
INSERT INTO centers_materials(cid, mid) VALUES (9,57);
INSERT INTO centers_materials(cid, mid) VALUES (9,58);
INSERT INTO centers_materials(cid, mid) VALUES (9,59);

-- center 10 materials (Canusa Hershman Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (10,25);
INSERT INTO centers_materials(cid, mid) VALUES (10,40);
INSERT INTO centers_materials(cid, mid) VALUES (10,42);
INSERT INTO centers_materials(cid, mid) VALUES (10,43);
INSERT INTO centers_materials(cid, mid) VALUES (10,44);
INSERT INTO centers_materials(cid, mid) VALUES (10,45);
INSERT INTO centers_materials(cid, mid) VALUES (10,57);
INSERT INTO centers_materials(cid, mid) VALUES (10,58);
INSERT INTO centers_materials(cid, mid) VALUES (10,59);

-- center 11 materials (Burcham's Metals Inc)
INSERT INTO centers_materials(cid, mid) VALUES (11,1);
INSERT INTO centers_materials(cid, mid) VALUES (11,24);
INSERT INTO centers_materials(cid, mid) VALUES (11,45);
INSERT INTO centers_materials(cid, mid) VALUES (11,47);
INSERT INTO centers_materials(cid, mid) VALUES (11,48);

-- center 12 materials (Apex Property Clearing & Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (12,1);
INSERT INTO centers_materials(cid, mid) VALUES (12,2);
INSERT INTO centers_materials(cid, mid) VALUES (12,3);
INSERT INTO centers_materials(cid, mid) VALUES (12,4);
INSERT INTO centers_materials(cid, mid) VALUES (12,5);
INSERT INTO centers_materials(cid, mid) VALUES (12,6);
INSERT INTO centers_materials(cid, mid) VALUES (12,7);
INSERT INTO centers_materials(cid, mid) VALUES (12,8);
INSERT INTO centers_materials(cid, mid) VALUES (12,9);
INSERT INTO centers_materials(cid, mid) VALUES (12,10);
INSERT INTO centers_materials(cid, mid) VALUES (12,11);
INSERT INTO centers_materials(cid, mid) VALUES (12,12);
INSERT INTO centers_materials(cid, mid) VALUES (12,13);
INSERT INTO centers_materials(cid, mid) VALUES (12,14);
INSERT INTO centers_materials(cid, mid) VALUES (12,15);
INSERT INTO centers_materials(cid, mid) VALUES (12,16);
INSERT INTO centers_materials(cid, mid) VALUES (12,17);
INSERT INTO centers_materials(cid, mid) VALUES (12,18);
INSERT INTO centers_materials(cid, mid) VALUES (12,19);
INSERT INTO centers_materials(cid, mid) VALUES (12,20);
INSERT INTO centers_materials(cid, mid) VALUES (12,21);
INSERT INTO centers_materials(cid, mid) VALUES (12,22);
INSERT INTO centers_materials(cid, mid) VALUES (12,23);
INSERT INTO centers_materials(cid, mid) VALUES (12,24);
INSERT INTO centers_materials(cid, mid) VALUES (12,25);
INSERT INTO centers_materials(cid, mid) VALUES (12,26);
INSERT INTO centers_materials(cid, mid) VALUES (12,27);
INSERT INTO centers_materials(cid, mid) VALUES (12,28);
INSERT INTO centers_materials(cid, mid) VALUES (12,29);
INSERT INTO centers_materials(cid, mid) VALUES (12,30);
INSERT INTO centers_materials(cid, mid) VALUES (12,31);
INSERT INTO centers_materials(cid, mid) VALUES (12,32);
INSERT INTO centers_materials(cid, mid) VALUES (12,33);
INSERT INTO centers_materials(cid, mid) VALUES (12,34);
INSERT INTO centers_materials(cid, mid) VALUES (12,35);
INSERT INTO centers_materials(cid, mid) VALUES (12,36);
INSERT INTO centers_materials(cid, mid) VALUES (12,37);
INSERT INTO centers_materials(cid, mid) VALUES (12,38);
INSERT INTO centers_materials(cid, mid) VALUES (12,39);
INSERT INTO centers_materials(cid, mid) VALUES (12,40);
INSERT INTO centers_materials(cid, mid) VALUES (12,41);
INSERT INTO centers_materials(cid, mid) VALUES (12,42);
INSERT INTO centers_materials(cid, mid) VALUES (12,43);
INSERT INTO centers_materials(cid, mid) VALUES (12,44);
INSERT INTO centers_materials(cid, mid) VALUES (12,45);
INSERT INTO centers_materials(cid, mid) VALUES (12,46);
INSERT INTO centers_materials(cid, mid) VALUES (12,47);
INSERT INTO centers_materials(cid, mid) VALUES (12,48);
INSERT INTO centers_materials(cid, mid) VALUES (12,49);
INSERT INTO centers_materials(cid, mid) VALUES (12,50);
INSERT INTO centers_materials(cid, mid) VALUES (12,51);
INSERT INTO centers_materials(cid, mid) VALUES (12,52);
INSERT INTO centers_materials(cid, mid) VALUES (12,53);
INSERT INTO centers_materials(cid, mid) VALUES (12,54);
INSERT INTO centers_materials(cid, mid) VALUES (12,55);
INSERT INTO centers_materials(cid, mid) VALUES (12,56);
INSERT INTO centers_materials(cid, mid) VALUES (12,57);
INSERT INTO centers_materials(cid, mid) VALUES (12,58);
INSERT INTO centers_materials(cid, mid) VALUES (12,59);

-- center 13 materials (G&P Recycling Center)
INSERT INTO centers_materials(cid, mid) VALUES (13,40);
INSERT INTO centers_materials(cid, mid) VALUES (13,43);
INSERT INTO centers_materials(cid, mid) VALUES (13,44);
INSERT INTO centers_materials(cid, mid) VALUES (13,45);
INSERT INTO centers_materials(cid, mid) VALUES (13,48);
INSERT INTO centers_materials(cid, mid) VALUES (13,55);

-- center 14 materials (Homeboy Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (14,2);
INSERT INTO centers_materials(cid, mid) VALUES (14,3);
INSERT INTO centers_materials(cid, mid) VALUES (14,10);
INSERT INTO centers_materials(cid, mid) VALUES (14,13);
INSERT INTO centers_materials(cid, mid) VALUES (14,18);
INSERT INTO centers_materials(cid, mid) VALUES (14,24);
INSERT INTO centers_materials(cid, mid) VALUES (14,46);
INSERT INTO centers_materials(cid, mid) VALUES (14,58);
INSERT INTO centers_materials(cid, mid) VALUES (14,59);

-- center 15 materials (ASI Recycling Center)
INSERT INTO centers_materials(cid, mid) VALUES (15,40);
INSERT INTO centers_materials(cid, mid) VALUES (15,43);
INSERT INTO centers_materials(cid, mid) VALUES (15,44);
INSERT INTO centers_materials(cid, mid) VALUES (15,45);
INSERT INTO centers_materials(cid, mid) VALUES (15,48);
INSERT INTO centers_materials(cid, mid) VALUES (15,55);

-- center 16 materials (Greenyard Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (16,40);
INSERT INTO centers_materials(cid, mid) VALUES (16,43);
INSERT INTO centers_materials(cid, mid) VALUES (16,44);
INSERT INTO centers_materials(cid, mid) VALUES (16,45);
INSERT INTO centers_materials(cid, mid) VALUES (16,48);
INSERT INTO centers_materials(cid, mid) VALUES (16,55);

-- center 17 materials (West Coast Recycling Center)
INSERT INTO centers_materials(cid, mid) VALUES (17,40);
INSERT INTO centers_materials(cid, mid) VALUES (17,43);
INSERT INTO centers_materials(cid, mid) VALUES (17,44);
INSERT INTO centers_materials(cid, mid) VALUES (17,45);
INSERT INTO centers_materials(cid, mid) VALUES (17,48);
INSERT INTO centers_materials(cid, mid) VALUES (17,55);

-- center 18 materials (San Francisco Transfer Station)
INSERT INTO centers_materials(cid, mid) VALUES (18,1);
INSERT INTO centers_materials(cid, mid) VALUES (18,4);
INSERT INTO centers_materials(cid, mid) VALUES (18,5);
INSERT INTO centers_materials(cid, mid) VALUES (18,6);
INSERT INTO centers_materials(cid, mid) VALUES (18,7);
INSERT INTO centers_materials(cid, mid) VALUES (18,8);
INSERT INTO centers_materials(cid, mid) VALUES (18,9);
INSERT INTO centers_materials(cid, mid) VALUES (18,10);
INSERT INTO centers_materials(cid, mid) VALUES (18,11);
INSERT INTO centers_materials(cid, mid) VALUES (18,12);
INSERT INTO centers_materials(cid, mid) VALUES (18,14);
INSERT INTO centers_materials(cid, mid) VALUES (18,15);
INSERT INTO centers_materials(cid, mid) VALUES (18,16);
INSERT INTO centers_materials(cid, mid) VALUES (18,17);
INSERT INTO centers_materials(cid, mid) VALUES (18,18);
INSERT INTO centers_materials(cid, mid) VALUES (18,20);
INSERT INTO centers_materials(cid, mid) VALUES (18,22);
INSERT INTO centers_materials(cid, mid) VALUES (18,23);
INSERT INTO centers_materials(cid, mid) VALUES (18,24);
INSERT INTO centers_materials(cid, mid) VALUES (18,25);
INSERT INTO centers_materials(cid, mid) VALUES (18,26);
INSERT INTO centers_materials(cid, mid) VALUES (18,27);
INSERT INTO centers_materials(cid, mid) VALUES (18,29);
INSERT INTO centers_materials(cid, mid) VALUES (18,30);
INSERT INTO centers_materials(cid, mid) VALUES (18,31);
INSERT INTO centers_materials(cid, mid) VALUES (18,32);
INSERT INTO centers_materials(cid, mid) VALUES (18,33);
INSERT INTO centers_materials(cid, mid) VALUES (18,34);
INSERT INTO centers_materials(cid, mid) VALUES (18,35);
INSERT INTO centers_materials(cid, mid) VALUES (18,36);
INSERT INTO centers_materials(cid, mid) VALUES (18,37);
INSERT INTO centers_materials(cid, mid) VALUES (18,38);
INSERT INTO centers_materials(cid, mid) VALUES (18,39);
INSERT INTO centers_materials(cid, mid) VALUES (18,40);
INSERT INTO centers_materials(cid, mid) VALUES (18,41);
INSERT INTO centers_materials(cid, mid) VALUES (18,42);
INSERT INTO centers_materials(cid, mid) VALUES (18,43);
INSERT INTO centers_materials(cid, mid) VALUES (18,44);
INSERT INTO centers_materials(cid, mid) VALUES (18,45);
INSERT INTO centers_materials(cid, mid) VALUES (18,46);
INSERT INTO centers_materials(cid, mid) VALUES (18,47);
INSERT INTO centers_materials(cid, mid) VALUES (18,49);
INSERT INTO centers_materials(cid, mid) VALUES (18,50);
INSERT INTO centers_materials(cid, mid) VALUES (18,51);
INSERT INTO centers_materials(cid, mid) VALUES (18,52);
INSERT INTO centers_materials(cid, mid) VALUES (18,53);
INSERT INTO centers_materials(cid, mid) VALUES (18,54);
INSERT INTO centers_materials(cid, mid) VALUES (18,55);
INSERT INTO centers_materials(cid, mid) VALUES (18,56);
INSERT INTO centers_materials(cid, mid) VALUES (18,57);
INSERT INTO centers_materials(cid, mid) VALUES (18,58);
INSERT INTO centers_materials(cid, mid) VALUES (18,59);

-- center 19 materials (Oakland Household Hazardous Waste Facility)
INSERT INTO centers_materials(cid, mid) VALUES (19,1);
INSERT INTO centers_materials(cid, mid) VALUES (19,4);
INSERT INTO centers_materials(cid, mid) VALUES (19,5);
INSERT INTO centers_materials(cid, mid) VALUES (19,6);
INSERT INTO centers_materials(cid, mid) VALUES (19,7);
INSERT INTO centers_materials(cid, mid) VALUES (19,8);
INSERT INTO centers_materials(cid, mid) VALUES (19,9);
INSERT INTO centers_materials(cid, mid) VALUES (19,10);
INSERT INTO centers_materials(cid, mid) VALUES (19,11);
INSERT INTO centers_materials(cid, mid) VALUES (19,12);
INSERT INTO centers_materials(cid, mid) VALUES (19,14);
INSERT INTO centers_materials(cid, mid) VALUES (19,15);
INSERT INTO centers_materials(cid, mid) VALUES (19,16);
INSERT INTO centers_materials(cid, mid) VALUES (19,17);
INSERT INTO centers_materials(cid, mid) VALUES (19,18);
INSERT INTO centers_materials(cid, mid) VALUES (19,20);
INSERT INTO centers_materials(cid, mid) VALUES (19,22);
INSERT INTO centers_materials(cid, mid) VALUES (19,23);
INSERT INTO centers_materials(cid, mid) VALUES (19,24);
INSERT INTO centers_materials(cid, mid) VALUES (19,25);
INSERT INTO centers_materials(cid, mid) VALUES (19,26);
INSERT INTO centers_materials(cid, mid) VALUES (19,27);
INSERT INTO centers_materials(cid, mid) VALUES (19,29);
INSERT INTO centers_materials(cid, mid) VALUES (19,30);
INSERT INTO centers_materials(cid, mid) VALUES (19,31);
INSERT INTO centers_materials(cid, mid) VALUES (19,32);
INSERT INTO centers_materials(cid, mid) VALUES (19,33);
INSERT INTO centers_materials(cid, mid) VALUES (19,34);
INSERT INTO centers_materials(cid, mid) VALUES (19,35);
INSERT INTO centers_materials(cid, mid) VALUES (19,36);
INSERT INTO centers_materials(cid, mid) VALUES (19,37);
INSERT INTO centers_materials(cid, mid) VALUES (19,38);
INSERT INTO centers_materials(cid, mid) VALUES (19,39);
INSERT INTO centers_materials(cid, mid) VALUES (19,40);
INSERT INTO centers_materials(cid, mid) VALUES (19,41);
INSERT INTO centers_materials(cid, mid) VALUES (19,42);
INSERT INTO centers_materials(cid, mid) VALUES (19,43);
INSERT INTO centers_materials(cid, mid) VALUES (19,44);
INSERT INTO centers_materials(cid, mid) VALUES (19,45);
INSERT INTO centers_materials(cid, mid) VALUES (19,46);
INSERT INTO centers_materials(cid, mid) VALUES (19,47);
INSERT INTO centers_materials(cid, mid) VALUES (19,49);
INSERT INTO centers_materials(cid, mid) VALUES (19,50);
INSERT INTO centers_materials(cid, mid) VALUES (19,51);
INSERT INTO centers_materials(cid, mid) VALUES (19,52);
INSERT INTO centers_materials(cid, mid) VALUES (19,53);
INSERT INTO centers_materials(cid, mid) VALUES (19,54);
INSERT INTO centers_materials(cid, mid) VALUES (19,55);
INSERT INTO centers_materials(cid, mid) VALUES (19,56);
INSERT INTO centers_materials(cid, mid) VALUES (19,57);
INSERT INTO centers_materials(cid, mid) VALUES (19,58);
INSERT INTO centers_materials(cid, mid) VALUES (19,59);

-- center 20 materials (Tri-CED Community Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (20,2);
INSERT INTO centers_materials(cid, mid) VALUES (20,3);
INSERT INTO centers_materials(cid, mid) VALUES (20,10);
INSERT INTO centers_materials(cid, mid) VALUES (20,13);
INSERT INTO centers_materials(cid, mid) VALUES (20,16);
INSERT INTO centers_materials(cid, mid) VALUES (20,18);
INSERT INTO centers_materials(cid, mid) VALUES (20,24);
INSERT INTO centers_materials(cid, mid) VALUES (20,46);
INSERT INTO centers_materials(cid, mid) VALUES (20,58);
INSERT INTO centers_materials(cid, mid) VALUES (20,59);

-- center 21 materials (Fremont Recycling and Transfer Station)
INSERT INTO centers_materials(cid, mid) VALUES (21,1);
INSERT INTO centers_materials(cid, mid) VALUES (21,4);
INSERT INTO centers_materials(cid, mid) VALUES (21,5);
INSERT INTO centers_materials(cid, mid) VALUES (21,6);
INSERT INTO centers_materials(cid, mid) VALUES (21,7);
INSERT INTO centers_materials(cid, mid) VALUES (21,8);
INSERT INTO centers_materials(cid, mid) VALUES (21,9);
INSERT INTO centers_materials(cid, mid) VALUES (21,10);
INSERT INTO centers_materials(cid, mid) VALUES (21,11);
INSERT INTO centers_materials(cid, mid) VALUES (21,12);
INSERT INTO centers_materials(cid, mid) VALUES (21,14);
INSERT INTO centers_materials(cid, mid) VALUES (21,15);
INSERT INTO centers_materials(cid, mid) VALUES (21,16);
INSERT INTO centers_materials(cid, mid) VALUES (21,17);
INSERT INTO centers_materials(cid, mid) VALUES (21,18);
INSERT INTO centers_materials(cid, mid) VALUES (21,20);
INSERT INTO centers_materials(cid, mid) VALUES (21,22);
INSERT INTO centers_materials(cid, mid) VALUES (21,23);
INSERT INTO centers_materials(cid, mid) VALUES (21,24);
INSERT INTO centers_materials(cid, mid) VALUES (21,25);
INSERT INTO centers_materials(cid, mid) VALUES (21,26);
INSERT INTO centers_materials(cid, mid) VALUES (21,27);
INSERT INTO centers_materials(cid, mid) VALUES (21,29);
INSERT INTO centers_materials(cid, mid) VALUES (21,30);
INSERT INTO centers_materials(cid, mid) VALUES (21,31);
INSERT INTO centers_materials(cid, mid) VALUES (21,32);
INSERT INTO centers_materials(cid, mid) VALUES (21,33);
INSERT INTO centers_materials(cid, mid) VALUES (21,34);
INSERT INTO centers_materials(cid, mid) VALUES (21,35);
INSERT INTO centers_materials(cid, mid) VALUES (21,36);
INSERT INTO centers_materials(cid, mid) VALUES (21,37);
INSERT INTO centers_materials(cid, mid) VALUES (21,38);
INSERT INTO centers_materials(cid, mid) VALUES (21,39);
INSERT INTO centers_materials(cid, mid) VALUES (21,40);
INSERT INTO centers_materials(cid, mid) VALUES (21,41);
INSERT INTO centers_materials(cid, mid) VALUES (21,42);
INSERT INTO centers_materials(cid, mid) VALUES (21,43);
INSERT INTO centers_materials(cid, mid) VALUES (21,44);
INSERT INTO centers_materials(cid, mid) VALUES (21,45);
INSERT INTO centers_materials(cid, mid) VALUES (21,46);
INSERT INTO centers_materials(cid, mid) VALUES (21,47);
INSERT INTO centers_materials(cid, mid) VALUES (21,49);
INSERT INTO centers_materials(cid, mid) VALUES (21,50);
INSERT INTO centers_materials(cid, mid) VALUES (21,51);
INSERT INTO centers_materials(cid, mid) VALUES (21,52);
INSERT INTO centers_materials(cid, mid) VALUES (21,53);
INSERT INTO centers_materials(cid, mid) VALUES (21,54);
INSERT INTO centers_materials(cid, mid) VALUES (21,55);
INSERT INTO centers_materials(cid, mid) VALUES (21,56);
INSERT INTO centers_materials(cid, mid) VALUES (21,57);
INSERT INTO centers_materials(cid, mid) VALUES (21,58);
INSERT INTO centers_materials(cid, mid) VALUES (21,59);

-- center 22 materials (Hayward Drop-Off Facility)
INSERT INTO centers_materials(cid, mid) VALUES (22,1);
INSERT INTO centers_materials(cid, mid) VALUES (22,4);
INSERT INTO centers_materials(cid, mid) VALUES (22,5);
INSERT INTO centers_materials(cid, mid) VALUES (22,6);
INSERT INTO centers_materials(cid, mid) VALUES (22,7);
INSERT INTO centers_materials(cid, mid) VALUES (22,8);
INSERT INTO centers_materials(cid, mid) VALUES (22,9);
INSERT INTO centers_materials(cid, mid) VALUES (22,10);
INSERT INTO centers_materials(cid, mid) VALUES (22,11);
INSERT INTO centers_materials(cid, mid) VALUES (22,12);
INSERT INTO centers_materials(cid, mid) VALUES (22,14);
INSERT INTO centers_materials(cid, mid) VALUES (22,15);
INSERT INTO centers_materials(cid, mid) VALUES (22,16);
INSERT INTO centers_materials(cid, mid) VALUES (22,17);
INSERT INTO centers_materials(cid, mid) VALUES (22,18);
INSERT INTO centers_materials(cid, mid) VALUES (22,20);
INSERT INTO centers_materials(cid, mid) VALUES (22,22);
INSERT INTO centers_materials(cid, mid) VALUES (22,23);
INSERT INTO centers_materials(cid, mid) VALUES (22,24);
INSERT INTO centers_materials(cid, mid) VALUES (22,25);
INSERT INTO centers_materials(cid, mid) VALUES (22,26);
INSERT INTO centers_materials(cid, mid) VALUES (22,27);
INSERT INTO centers_materials(cid, mid) VALUES (22,29);
INSERT INTO centers_materials(cid, mid) VALUES (22,30);
INSERT INTO centers_materials(cid, mid) VALUES (22,31);
INSERT INTO centers_materials(cid, mid) VALUES (22,32);
INSERT INTO centers_materials(cid, mid) VALUES (22,33);
INSERT INTO centers_materials(cid, mid) VALUES (22,34);
INSERT INTO centers_materials(cid, mid) VALUES (22,35);
INSERT INTO centers_materials(cid, mid) VALUES (22,36);
INSERT INTO centers_materials(cid, mid) VALUES (22,37);
INSERT INTO centers_materials(cid, mid) VALUES (22,38);
INSERT INTO centers_materials(cid, mid) VALUES (22,39);
INSERT INTO centers_materials(cid, mid) VALUES (22,40);
INSERT INTO centers_materials(cid, mid) VALUES (22,41);
INSERT INTO centers_materials(cid, mid) VALUES (22,42);
INSERT INTO centers_materials(cid, mid) VALUES (22,43);
INSERT INTO centers_materials(cid, mid) VALUES (22,44);
INSERT INTO centers_materials(cid, mid) VALUES (22,45);
INSERT INTO centers_materials(cid, mid) VALUES (22,46);
INSERT INTO centers_materials(cid, mid) VALUES (22,47);
INSERT INTO centers_materials(cid, mid) VALUES (22,49);
INSERT INTO centers_materials(cid, mid) VALUES (22,50);
INSERT INTO centers_materials(cid, mid) VALUES (22,51);
INSERT INTO centers_materials(cid, mid) VALUES (22,52);
INSERT INTO centers_materials(cid, mid) VALUES (22,53);
INSERT INTO centers_materials(cid, mid) VALUES (22,54);
INSERT INTO centers_materials(cid, mid) VALUES (22,55);
INSERT INTO centers_materials(cid, mid) VALUES (22,56);
INSERT INTO centers_materials(cid, mid) VALUES (22,57);
INSERT INTO centers_materials(cid, mid) VALUES (22,58);
INSERT INTO centers_materials(cid, mid) VALUES (22,59);

-- center 23 materials (Sandy Transfer Station)
INSERT INTO centers_materials(cid, mid) VALUES (23,2);
INSERT INTO centers_materials(cid, mid) VALUES (23,3);
INSERT INTO centers_materials(cid, mid) VALUES (23,4);
INSERT INTO centers_materials(cid, mid) VALUES (23,13);
INSERT INTO centers_materials(cid, mid) VALUES (23,16);
INSERT INTO centers_materials(cid, mid) VALUES (23,18);
INSERT INTO centers_materials(cid, mid) VALUES (23,20);
INSERT INTO centers_materials(cid, mid) VALUES (23,23);
INSERT INTO centers_materials(cid, mid) VALUES (23,24);
INSERT INTO centers_materials(cid, mid) VALUES (23,29);
INSERT INTO centers_materials(cid, mid) VALUES (23,40);
INSERT INTO centers_materials(cid, mid) VALUES (23,43);
INSERT INTO centers_materials(cid, mid) VALUES (23,44);
INSERT INTO centers_materials(cid, mid) VALUES (23,45);
INSERT INTO centers_materials(cid, mid) VALUES (23,48);
INSERT INTO centers_materials(cid, mid) VALUES (23,50);
INSERT INTO centers_materials(cid, mid) VALUES (23,52);
INSERT INTO centers_materials(cid, mid) VALUES (23,53);
INSERT INTO centers_materials(cid, mid) VALUES (23,54);
INSERT INTO centers_materials(cid, mid) VALUES (23,55);
INSERT INTO centers_materials(cid, mid) VALUES (23,58);
INSERT INTO centers_materials(cid, mid) VALUES (23,59);

-- center 24 materials (Environmentally Conscious Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (24,1);
INSERT INTO centers_materials(cid, mid) VALUES (24,2);
INSERT INTO centers_materials(cid, mid) VALUES (24,3);
INSERT INTO centers_materials(cid, mid) VALUES (24,9);
INSERT INTO centers_materials(cid, mid) VALUES (24,13);
INSERT INTO centers_materials(cid, mid) VALUES (24,18);
INSERT INTO centers_materials(cid, mid) VALUES (24,26);
INSERT INTO centers_materials(cid, mid) VALUES (24,27);
INSERT INTO centers_materials(cid, mid) VALUES (24,28);
INSERT INTO centers_materials(cid, mid) VALUES (24,43);
INSERT INTO centers_materials(cid, mid) VALUES (24,44);
INSERT INTO centers_materials(cid, mid) VALUES (24,45);
INSERT INTO centers_materials(cid, mid) VALUES (24,51);
INSERT INTO centers_materials(cid, mid) VALUES (24,52);
INSERT INTO centers_materials(cid, mid) VALUES (24,53);
INSERT INTO centers_materials(cid, mid) VALUES (24,54);
INSERT INTO centers_materials(cid, mid) VALUES (24,55);
INSERT INTO centers_materials(cid, mid) VALUES (24,58);
INSERT INTO centers_materials(cid, mid) VALUES (24,59);

-- center 25 materials (Metro South Transfer Station)
INSERT INTO centers_materials(cid, mid) VALUES (25,1);
INSERT INTO centers_materials(cid, mid) VALUES (25,2);
INSERT INTO centers_materials(cid, mid) VALUES (25,3);
INSERT INTO centers_materials(cid, mid) VALUES (25,4);
INSERT INTO centers_materials(cid, mid) VALUES (25,5);
INSERT INTO centers_materials(cid, mid) VALUES (25,6);
INSERT INTO centers_materials(cid, mid) VALUES (25,7);
INSERT INTO centers_materials(cid, mid) VALUES (25,8);
INSERT INTO centers_materials(cid, mid) VALUES (25,9);
INSERT INTO centers_materials(cid, mid) VALUES (25,10);
INSERT INTO centers_materials(cid, mid) VALUES (25,11);
INSERT INTO centers_materials(cid, mid) VALUES (25,12);
INSERT INTO centers_materials(cid, mid) VALUES (25,13);
INSERT INTO centers_materials(cid, mid) VALUES (25,14);
INSERT INTO centers_materials(cid, mid) VALUES (25,15);
INSERT INTO centers_materials(cid, mid) VALUES (25,16);
INSERT INTO centers_materials(cid, mid) VALUES (25,17);
INSERT INTO centers_materials(cid, mid) VALUES (25,18);
INSERT INTO centers_materials(cid, mid) VALUES (25,19);
INSERT INTO centers_materials(cid, mid) VALUES (25,20);
INSERT INTO centers_materials(cid, mid) VALUES (25,21);
INSERT INTO centers_materials(cid, mid) VALUES (25,22);
INSERT INTO centers_materials(cid, mid) VALUES (25,23);
INSERT INTO centers_materials(cid, mid) VALUES (25,24);
INSERT INTO centers_materials(cid, mid) VALUES (25,25);
INSERT INTO centers_materials(cid, mid) VALUES (25,26);
INSERT INTO centers_materials(cid, mid) VALUES (25,27);
INSERT INTO centers_materials(cid, mid) VALUES (25,28);
INSERT INTO centers_materials(cid, mid) VALUES (25,29);
INSERT INTO centers_materials(cid, mid) VALUES (25,30);
INSERT INTO centers_materials(cid, mid) VALUES (25,31);
INSERT INTO centers_materials(cid, mid) VALUES (25,32);
INSERT INTO centers_materials(cid, mid) VALUES (25,33);
INSERT INTO centers_materials(cid, mid) VALUES (25,34);
INSERT INTO centers_materials(cid, mid) VALUES (25,35);
INSERT INTO centers_materials(cid, mid) VALUES (25,36);
INSERT INTO centers_materials(cid, mid) VALUES (25,37);
INSERT INTO centers_materials(cid, mid) VALUES (25,38);
INSERT INTO centers_materials(cid, mid) VALUES (25,39);
INSERT INTO centers_materials(cid, mid) VALUES (25,40);
INSERT INTO centers_materials(cid, mid) VALUES (25,41);
INSERT INTO centers_materials(cid, mid) VALUES (25,42);
INSERT INTO centers_materials(cid, mid) VALUES (25,43);
INSERT INTO centers_materials(cid, mid) VALUES (25,44);
INSERT INTO centers_materials(cid, mid) VALUES (25,45);
INSERT INTO centers_materials(cid, mid) VALUES (25,46);
INSERT INTO centers_materials(cid, mid) VALUES (25,47);
INSERT INTO centers_materials(cid, mid) VALUES (25,48);
INSERT INTO centers_materials(cid, mid) VALUES (25,49);
INSERT INTO centers_materials(cid, mid) VALUES (25,50);
INSERT INTO centers_materials(cid, mid) VALUES (25,51);
INSERT INTO centers_materials(cid, mid) VALUES (25,52);
INSERT INTO centers_materials(cid, mid) VALUES (25,53);
INSERT INTO centers_materials(cid, mid) VALUES (25,54);
INSERT INTO centers_materials(cid, mid) VALUES (25,55);
INSERT INTO centers_materials(cid, mid) VALUES (25,56);
INSERT INTO centers_materials(cid, mid) VALUES (25,57);
INSERT INTO centers_materials(cid, mid) VALUES (25,58);
INSERT INTO centers_materials(cid, mid) VALUES (25,59);

-- center 26 materials (Greenway Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (26,42);
INSERT INTO centers_materials(cid, mid) VALUES (26,43);
INSERT INTO centers_materials(cid, mid) VALUES (26,44);

-- center 27 materials (Good Garbage Junk Removal Hauling and Recycling)
INSERT INTO centers_materials(cid, mid) VALUES (27,1);
INSERT INTO centers_materials(cid, mid) VALUES (27,2);
INSERT INTO centers_materials(cid, mid) VALUES (27,5);
INSERT INTO centers_materials(cid, mid) VALUES (27,9);
INSERT INTO centers_materials(cid, mid) VALUES (27,16);
INSERT INTO centers_materials(cid, mid) VALUES (27,18);
INSERT INTO centers_materials(cid, mid) VALUES (27,22);
INSERT INTO centers_materials(cid, mid) VALUES (27,23);
INSERT INTO centers_materials(cid, mid) VALUES (27,24);
INSERT INTO centers_materials(cid, mid) VALUES (27,26);
INSERT INTO centers_materials(cid, mid) VALUES (27,27);
INSERT INTO centers_materials(cid, mid) VALUES (27,28);
INSERT INTO centers_materials(cid, mid) VALUES (27,30);
INSERT INTO centers_materials(cid, mid) VALUES (27,32);
INSERT INTO centers_materials(cid, mid) VALUES (27,33);
INSERT INTO centers_materials(cid, mid) VALUES (27,34);
INSERT INTO centers_materials(cid, mid) VALUES (27,36);
INSERT INTO centers_materials(cid, mid) VALUES (27,37);
INSERT INTO centers_materials(cid, mid) VALUES (27,40);
INSERT INTO centers_materials(cid, mid) VALUES (27,41);
INSERT INTO centers_materials(cid, mid) VALUES (27,42);
INSERT INTO centers_materials(cid, mid) VALUES (27,43);
INSERT INTO centers_materials(cid, mid) VALUES (27,44);
INSERT INTO centers_materials(cid, mid) VALUES (27,45);
INSERT INTO centers_materials(cid, mid) VALUES (27,46);
INSERT INTO centers_materials(cid, mid) VALUES (27,47);
INSERT INTO centers_materials(cid, mid) VALUES (27,48);
INSERT INTO centers_materials(cid, mid) VALUES (27,49);
INSERT INTO centers_materials(cid, mid) VALUES (27,50);
INSERT INTO centers_materials(cid, mid) VALUES (27,51);
INSERT INTO centers_materials(cid, mid) VALUES (27,52);
INSERT INTO centers_materials(cid, mid) VALUES (27,53);
INSERT INTO centers_materials(cid, mid) VALUES (27,54);
INSERT INTO centers_materials(cid, mid) VALUES (27,55);
INSERT INTO centers_materials(cid, mid) VALUES (27,56);
INSERT INTO centers_materials(cid, mid) VALUES (27,58);
INSERT INTO centers_materials(cid, mid) VALUES (27,59);


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
