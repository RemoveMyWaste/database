# To create database

CREATE DATABASE MaterialsDB
USE MaterialsDB;
CREATE USER 'group24'@'localhost' IDENTIFIED BY 'PASSWORD';
GRANT ALL PRIVILEGES ON MaterialsDB.* to 'group24'@'localhost';

# To login to database
mysql -u group24 -p MaterialsDB
source database.sql
\q

# To run the node server
npm install
node database.js PORT
