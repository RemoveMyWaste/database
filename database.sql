-- CREATE DATABASE MaterialsDB
-- USE MaterialsDB;
-- CREATE USER 'group24'@'localhost' IDENTIFIED BY 'PASSWORD';
-- GRANT ALL PRIVILEGES ON MaterialsDB.* to 'group24'@'localhost';

-- set storage engine
SET storage_engine=INNODB;

-- drop tables to update everything
DROP TABLE IF EXISTS users_centers;
DROP TABLE IF EXISTS users_materials;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS centers;
DROP TABLE IF EXISTS hazards;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS users;
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

    -- foreign key for handlingInstructions table
    hid int(10) NOT NULL,
    FOREIGN KEY(hid) REFERENCES handlingInstructions(id),

    -- foreign key for disposalInstructions table
    did int(10) NOT NULL,
    FOREIGN KEY(did) REFERENCES disposalInstructions(id),

    PRIMARY KEY(id)
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


-- populate table of materials (PRO DISPOSAL)
INSERT INTO materials(name, pro, hid) values("lead", true, 1);
INSERT INTO materials(name, pro, hid) values("tv", true, 1);
INSERT INTO materials(name, pro, hid) values("cell phone", true, 2);
INSERT INTO materials(name, pro, hid) values("motor oil", true, 2);
INSERT INTO materials(name, pro, hid) values("paint", true, 3);
INSERT INTO materials(name, pro, hid) values("acetone", true, 4);
INSERT INTO materials(name, pro, hid) values("antifreeze", true, 4);
INSERT INTO materials(name, pro, hid) values("boracic acid", true, 4);
INSERT INTO materials(name, pro, hid) values("motor oil", true, 4);
INSERT INTO materials(name, pro, hid) values("battery", true, 4);
INSERT INTO materials(name, pro, hid) values("sulfuric acid", true, 4);
INSERT INTO materials(name, pro, hid) values("lye", true, 4);
INSERT INTO materials(name, pro, hid) values("electronics", true, 4);

-- populate table of materials (HOME DISPOSAL)
INSERT INTO materials(name, pro, hid, did) values("borax", false, 4, 1);
INSERT INTO materials(name, pro, hid, did) values("drano", false, 4, 1);
INSERT INTO materials(name, pro, hid, did) values("alcohol", false, 4, 1);
INSERT INTO materials(name, pro, hid, hid, did) values("bleach", false, 4, 5, 1);
INSERT INTO materials(name, pro, hid, hid, did) values("ammonia", false, 4, 6, 1);
INSERT INTO materials(name, pro, hid, did) values("vinegar", false, 4, 1);
INSERT INTO materials(name, pro, hid, did) values("windex", false, 4, 1);
INSERT INTO materials(name, pro, hid, did) values("silica", false, 4, 2);
INSERT INTO materials(name, pro, hid, did) values("laundry detergent", false, 4);
INSERT INTO materials(name, pro, hid, did) values("glass", false, 4);
INSERT INTO materials(name, pro, hid, did) values("toothpaste", false, 4);

-- populate table of handling instructions (for all materials)
INSERT INTO handlingInstructions(instructions) values ("requires professional disposal");
INSERT INTO handlingInstructions(instructions) values ("do not touch with bare skin");
INSERT INTO handlingInstructions(instructions) values ("handle with care");
INSERT INTO handlingInstructions(instructions) values ("do not drop");
INSERT INTO disposalInstructions(instructions) values ("do not mix with ammonia");
INSERT INTO disposalInstructions(instructions) values ("do not mix with bleach");

-- populate table of disposal instructions (only for materials that can be disposed of at home)
INSERT INTO disposalInstructions(instructions) values ("dilute with water and pour down the drain");
INSERT INTO disposalInstructions(instructions) values ("dispose of in household trash");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");
INSERT INTO disposalInstructions(instructions) values ("");





-- populate table of centers
INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Devilish Disposal", 666, "W", "hell", "highway", "hell", "Oregon", "66666");

INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) \
            values("Cool Disposal Inc.", 123, "S", "cool", "street", "coolsville", "Oregon", "12345");

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
