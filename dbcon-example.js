var mysql = require('mysql');

var pool = mysql.createConnection({
  connectionLimit : 10,
  host            : 'localhost',
  user            : 'USERNAME',
  password        : 'PASSWORD',
  database        : 'DATABASE',
    multipleStatements: true
});

module.exports.pool = pool;
