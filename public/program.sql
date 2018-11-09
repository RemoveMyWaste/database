/*
liam beckman
13 august 2018
Project Step 5: Final Working Project
*/

-- set storage engine
SET storage_engine=INNODB;

-- drop tables to update everything
DROP TABLE IF EXISTS program_language;
DROP TABLE IF EXISTS program_author;
DROP TABLE IF EXISTS program_os;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS language;
DROP TABLE IF EXISTS os;
DROP TABLE IF EXISTS src;
DROP TABLE IF EXISTS program;

-- "main" program table
CREATE TABLE program(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    purpose varchar(255),
    url varchar(255),
    version varchar(255),
    license varchar(255),
    PRIMARY KEY(id)
);

-- language(s) the program was written in
CREATE TABLE language(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    url varchar(255),
    PRIMARY KEY(id)
)ENGINE=InnoDB;

-- foreign key table between program and language
CREATE TABLE program_language(
    lid int(10) NOT NULL,
    pid int(10) NOT NULL,
    FOREIGN KEY(pid) REFERENCES program(id) ON DELETE CASCADE, 
    FOREIGN KEY(lid) REFERENCES language(id) ON DELETE CASCADE,
    PRIMARY KEY(pid,lid)
)ENGINE=InnoDB;

-- the people or organizations that wrote the program
CREATE TABLE author(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    url varchar(255),
    PRIMARY KEY(id)
)ENGINE=InnoDB;

-- foreign key table between program and authors
CREATE TABLE program_author(
    aid int(10) NOT NULL,
    pid int(10) NOT NULL,
    FOREIGN KEY(pid) REFERENCES program(id) ON DELETE CASCADE,
    FOREIGN KEY(aid) REFERENCES author(id) ON DELETE CASCADE,
    PRIMARY KEY(pid,aid)
)ENGINE=InnoDB;

CREATE TABLE src(
    id int(10) NOT NULL AUTO_INCREMENT,
    url varchar(255) NOT NULL,
    type varchar(255),
    pid int(10) NOT NULL,
    FOREIGN KEY(pid) REFERENCES program(id) ON DELETE CASCADE,
    PRIMARY KEY(id)
)ENGINE=InnoDB;

CREATE TABLE os(
    id int(10) NOT NULL AUTO_INCREMENT,
    name varchar(255) NOT NULL,
    url varchar(255),
    PRIMARY KEY(id)
)ENGINE=InnoDB;

CREATE TABLE program_os(
    oid int(10) NOT NULL,
    pid int(10) NOT NULL,
    FOREIGN KEY(pid) REFERENCES program(id) ON DELETE CASCADE,
    FOREIGN KEY(oid) REFERENCES os(id) ON DELETE CASCADE
)ENGINE=InnoDB;


-- populate table of languages
INSERT INTO language(name, url) values("Bash", "https://www.gnu.org/software/bash/");
INSERT INTO language(name, url) values("C", "https://en.wikipedia.org/wiki/C_(programming_language)");
INSERT INTO language(name, url) values("C#", "https://en.wikipedia.org/wiki/C_Sharp_(programming_language)");
INSERT INTO language(name, url) values("C++", "https://en.wikipedia.org/wiki/C%2B%2B");
INSERT INTO language(name, url) values("Golang", "https://golang.org/");
INSERT INTO language(name, url) values("Haskell", "https://www.haskell.org/");
INSERT INTO language(name, url) values("Java", "https://www.java.com/en/");
INSERT INTO language(name, url) values("JavaScript", "https://en.wikipedia.org/wiki/JavaScript");
INSERT INTO language(name, url) values("Lua", "https://www.lua.org/");
INSERT INTO language(name, url) values("MariaDB", "https://mariadb.org/");
INSERT INTO language(name, url) values("NASM", "https://www.nasm.us/");
INSERT INTO language(name, url) values("OCaml", "https://ocaml.org/");
INSERT INTO language(name, url) values("PHP", "https://secure.php.net/");
INSERT INTO language(name, url) values("Perl", "https://www.perl.org/");
INSERT INTO language(name, url) values("Python", "https://www.python.org/");
INSERT INTO language(name, url) values("R", "https://www.r-project.org/");
INSERT INTO language(name, url) values("Ruby", "https://www.ruby-lang.org/en/");
INSERT INTO language(name, url) values("Rust", "https://www.rust-lang.org/en-US/");
INSERT INTO language(name, url) values("Scheme", "http://schemers.org/");

-- populate table of authors
INSERT INTO author(name, url) values("The Calculatron Community","https://calculatron.com");
INSERT INTO author(name) values("Leia O.");
INSERT INTO author(name) values("Luke S.");
INSERT INTO author(name) values("Obi-Wan K.");

-- populate table of operating systems
INSERT INTO os(name, url) values ("Linux", "https://www.kernel.org/");
INSERT INTO os(name, url) values ("Windows", "https://www.microsoft.com/en-us/windows/");
INSERT INTO os(name, url) values ("macOS", "https://www.apple.com/macos/");
INSERT INTO os(name, url) values ("Haiku", "https://www.haiku-os.org/");
INSERT INTO os(name, url) values ("FreeBSD", "https://www.freebsd.org/");
INSERT INTO os(name, url) values ("OpenBSD", "https://www.openbsd.org/");


-- add program 1
INSERT INTO program(name,purpose,url,version,license) values("Calculatron","calculates pi","https://www.calculatron.org","0.0.1","MIT");

-- add program 2
INSERT INTO program(name,purpose,url,version,license) values("Neato","calculates infinity","https://neato.com","22.22.22","BSD");

-- add program 3
INSERT INTO program(name,purpose,url,version,license) values("Cool Program","calculates 123","https://coolprogram.com","3.3.3", "GPL");

-- populate table of sources
-- program 1 is hosted at www.calculatron.org
INSERT INTO src(url, type, pid) values ("https://www.calculatron.org", "download", 1);

-- program 2 is hosted at svn.neato.com
INSERT INTO src(url, type, pid) values ("https://svn.neato.com", "svn", 2);

-- program 3 is hosted at git.coolprogram.com
INSERT INTO src(url, type, pid) values ("https://git.coolprogram.com", "git", 3);


-- set entity attributes for program 1

-- written in Bash and C
INSERT INTO program_language(lid,pid) values(1,1);
INSERT INTO program_language(lid,pid) values(2,1);

-- written by The Calculatron Community
INSERT INTO program_author(aid,pid) values(1,1);


-- written for Linux, Windows, and macOS
INSERT INTO program_os(oid,pid) values(1,1);
INSERT INTO program_os(oid,pid) values(2,1);
INSERT INTO program_os(oid,pid) values(3,1);



-- set entity attributes for program 2

-- written in C# and C++
INSERT INTO program_language(lid,pid) values(3,2);
INSERT INTO program_language(lid,pid) values(4,2);

-- written by Leia O. and Luke S.
INSERT INTO program_author(aid,pid) values(2,2);
INSERT INTO program_author(aid,pid) values(3,2);


-- written for Windows
INSERT INTO program_os(oid,pid) values(1,2);



-- set language and authors for program 3

-- written in Haskell
INSERT INTO program_language(lid,pid) values(6,3);

-- written by Obi-Wan K.
INSERT INTO program_author(aid,pid) values(3,3);

-- written for Windows and macOS
INSERT INTO program_os(oid,pid) values(2,3);
INSERT INTO program_os(oid,pid) values(3,3);


-- display program table
-- SELECT * FROM program ORDER BY name;

/*
+----+--------------+---------------------+-----------------------------+----------+---------+
| id | name         | purpose             | url                         | version  | license |
+----+--------------+---------------------+-----------------------------+----------+---------+
|  1 | Calculatron  | calculates pi       | https://www.calculatron.org | 0.0.1    | MIT     |
|  2 | Neato        | calculates infinity | https://neato.com           | 22.22.22 | BSD     |
|  3 | Cool Program | calculates 123      | https://coolprogram.com     | 3.3.3    | GPL     |
+----+--------------+---------------------+-----------------------------+----------+---------+
*/
