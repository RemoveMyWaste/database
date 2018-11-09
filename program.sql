/*
liam beckman
24 july 2018
Project Step 3 Final Version
*/

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



CREATE TABLE hazards(
    id int(10) NOT NULL AUTO_INCREMENT,
    hazards varchar(255),
    handling varchar(255),
    PRIMARY KEY(id)
);

CREATE TABLE locations(
    id int(10) NOT NULL AUTO_INCREMENT,
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
    rating int(1),
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


-- populate table of materialss
INSERT INTO materials(name, rating) values("lead", 1);
INSERT INTO materials(name, rating) values("tv", 2);
INSERT INTO materials(name, rating) values("cell phone", 3);
INSERT INTO materials(name, rating) values("motor oil", 4);
INSERT INTO materials(name, rating) values("paint", 5); 


-- populate table of centers
INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) values("Devilish Disposal", 666, "W", "hell", "highway", "hell", "Oregon", "66666");
INSERT INTO centers(name, street_number, street_direction, street_name, street_type, city, state, zip) values("Cool Disposal Inc.", 123, "S", "cool", "street", "coolsville", "Oregon", "12345");

--INSERT INTO locations(street_number, street_direction, street_name, street_type, city, state, zip) values(999, "N", "sweet", "street", "radplace", "California", "99999");
--INSERT INTO locations(street_number, street_direction, street_name, street_type, city, state, zip) values(987, "SW", "bodacious", "boulevard", "illville", "Washingotn", "98765");
--INSERT INTO locations(street_number, street_direction, street_name, street_type, city, state, zip) values(321, "NW", "tubular", "turnpike", "excellentown", "Oregon", "54321");
--INSERT INTO locations(street_number, street_direction, street_name, street_type, city, state, zip) values(456, "E", "rockin", "road", "cowabungapolis", "California", "13579");

---- populate table of centers
--INSERT INTO centers(name, lid) values("Devilish Disposal", 1);
--INSERT INTO centers(name, lid) values("Cool Disposal Inc.", 2);

-- populate table of hazard and handling instructions
INSERT INTO hazards(hazards, handling) values ("tickles if touched", "do not touch with bare skin");
INSERT INTO hazards(hazards, handling) values ("melts human brains", "handle with care");
INSERT INTO hazards(hazards, handling) values ("destroys the known universe", "do not drop");

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
