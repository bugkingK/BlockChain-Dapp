// 데이터베이스 설정

var mysql = require('mysql');

var db = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : 'vkfehfdl123!',
    database : 'vote'
});

module.exports = db;