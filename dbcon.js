var mysql = require('mysql');

var pool = mysql.createConnection({
  connectionLimit : 10,
  host            : 'localhost',
  user            : 'group24',
  password        : 'hazelnut',
  database        : 'MaterialsDB',
    multipleStatements: true
});

module.exports.pool = pool;
