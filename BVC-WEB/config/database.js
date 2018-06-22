// 데이터베이스 설정

var mysql = require('mysql');

var db = mysql.createConnection({
    host     : 'localhost',
    user     : 'id',
    password : 'pw',
    database : 'dbname'
});

module.exports = db;