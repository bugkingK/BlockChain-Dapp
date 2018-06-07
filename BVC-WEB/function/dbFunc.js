var fs = require('fs');
var path = process.cwd();
var view = require( path + '/function/view' );
var mysql = require('mysql');

var conn = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'arch0115',
  database : 'vote'
});

conn.connect();

module.exports.example = function(req, res) { 
    console.log(" This is an example " + req); 
};

// db에 투표장 정보를 입력합니다.
module.exports.InsertPlaceInfo = function(placeid, info, result) { 
    var placeID = parseInt(placeid);

    var sql = 'INSERT INTO placeinfo (name, start_regist_period, end_regist_period, votedate, contents, start_vote_time, end_vote_time, placeid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
    var params = [info[0], info[1], info[2], info[3], info[4], info[5], info[6], placeID];

    conn.query(sql, params, function(err, res){
        if(!err) {
            console.log("insert success");
            result("<h1>투표장이 등록되었습니다.....</h1>");

        } else {
            console.log(err);
            result("투표장 등록이 실패했습니다. 잠시 후 다시 시도해주세요.");
        }
    })
};
