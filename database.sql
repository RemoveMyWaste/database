
-- set storage engine
SET storage_engine=INNODB;

-- drop tables to update everything
DROP TABLE IF EXISTS users_centers;
DROP TABLE IF EXISTS users_materials;
DROP TABLE IF EXISTS materials_handling;
DROP TABLE IF EXISTS materials_disposal;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS centers;
DROP TABLE IF EXISTS hazards;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS handlingInstructions;
DROP TABLE IF EXISTS disposalInstructions;


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


-- "main" users table
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
INSERT INTO material_handling(mid, hid) values (53, 7);
INSERT INTO material_disposal(mid, did) values (53, 5);
INSERT INTO material_disposal(mid, did) values (53, 6);

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

-- add center schedules (operating days and hours)
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (1, '09:00', '17:00', 1);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (2, '09:00', '17:00', 1);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (3, '09:00', '17:00', 1);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (4, '09:00', '17:00', 1);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (5, '09:00', '17:00', 1);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (6, '09:00', '17:00', 1);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (7, '09:00', '17:00', 1);

INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (2, '06:00', '18:00', 2);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (3, '06:00', '18:00', 2);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (4, '06:00', '18:00', 2);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (5, '06:00', '18:00', 2);
INSERT INTO schedules(day_of_week, time_open, time_closed, cid) VALUES (6, '06:00', '18:00', 2);

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
