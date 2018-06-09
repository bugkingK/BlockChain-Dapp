// 데이터베이스를 이용하는 함수들입니다.

var path = process.cwd();
var db = require( path + '/config/database');
db.connect();

// db에 투표장 정보를 입력합니다.
module.exports.InsertPlaceInfo = function(placeid, info, result) { 
    var placeID = parseInt(placeid);

    var sql = 'INSERT INTO placeinfo (name, start_regist_period, end_regist_period, votedate, contents, start_vote_time, end_vote_time, placeid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
    var params = [info[0], info[1], info[2], info[3], info[4], info[5], info[6], placeID];

    db.query(sql, params, function(err, res){
        if(!err) {
            console.log("insertplaceinfo success");
            result("<h1>투표장이 등록되었습니다.....</h1>");

        } else {
            console.log("insertplaceinfo err : " + err);
            result("투표장 등록이 실패했습니다. 잠시 후 다시 시도해주세요.");
        }
    })
};

// db에서 후보자의 정보를 가져옵니다.
module.exports.searchCandidateInfo = function(result) {
    var sql = 'SELECT * FROM candidateinfo';

    db.query(sql, function(err, res) {
        if(!err) {
            console.log("candidateinfo search success");
            result(res)
        } else {
            console.log('candidateinfo search' + err);
            result("정보를 가져오지 못했습니다.");
        }
    })
}

module.exports.searchPlaceInfo = function(result) {
    db.query('SELECT * FROM placeinfo', function(err, res){
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
}



