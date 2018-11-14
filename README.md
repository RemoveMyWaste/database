# To create database

```sql
CREATE DATABASE MaterialsDB
USE MaterialsDB;
CREATE USER 'group24'@'localhost' IDENTIFIED BY 'PASSWORD';
GRANT ALL PRIVILEGES ON MaterialsDB.* to 'group24'@'localhost';
```

# To login to database

```sh
mysql -u group24 -p MaterialsDB
```

```sql
source database.sql
\q
```

# To run the node server

```sh
npm install
node database.js PORT
```
