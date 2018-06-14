// 데이터베이스를 이용하는 함수들입니다.

var path = process.cwd();
var db = require( path + '/config/database');
db.connect();

// db에 투표장 정보를 입력합니다.
module.exports.insertPlaceInfo = function(placeid, isStarted, info, result) {
    var placeID = parseInt(placeid);

    var sql = 'INSERT INTO placeinfo (name, start_regist_period, end_regist_period, votedate, contents, start_vote_time, end_vote_time, placeid, isStarted) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
    var params = [info[0], info[1], info[2], info[3], info[4], info[5], info[6], placeID, isStarted];

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

//후보자를 등록합니다 블록체인 까지
module.exports.insertCandidateInfo = function(placeid, candidateid, name, user_login, result){
    var candidateID = parseInt(candidateid);
    var placeID = parseInt(placeid);
    var sql='INSERT INTO candidateinfo (name, wantvote, candidateid, state) VALUES (?, ?, ?, 1)';
    var params = [name, placeID, candidateID];
        
    db.query(sql, params, function(err, res){
        if(!err) {
            console.log("insert success");
            
            var sql1='UPDATE wp_users SET state=1 WHERE user_login=?';
            var params1=[user_login]
            db.query(sql1, params1, function(err, res){
                if(!err){
                    console.log("the end")
                    result(null, res);
                } else {
                    console.log("not end")
                    result(err, null);
                }
            })

        } else {
            console.log(err);
        }
    })
}

module.exports.updateCandidateState = function(candidateid, result){
    var sql = 'UPDATE candidateinfo SET state=3 WHERE candidateid=?'
    var params = [candidateid]
    db.query(sql, params, function(err, res){
        if(!err){
            result(null, res);
        } else {
            result(err, null);
        }
    })
}

module.exports.selectBookedCandidateList = function(placeid, result) {
    var sql = 'SELECT * FROM candidateinfo WHERE placeid=?'
    var params = [placeid];
    db.query(sql, params, function(err, res){
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
}

//투표장 아이디를 가져옵니다.
module.exports.searchPlaceId = function(placename, result) {
    var sql = 'SELECT placeid FROM vote.placeinfo WHERE name=?';
    var name=placename;
    var param =[name];
    db.query(sql, param, function(err, res){
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
}


// db에서 후보자의 정보를 가져옵니다.
module.exports.searchCandidateInfo = function(placeid, candidateid, result) {
    var sql = 'SELECT * FROM candidateinfo WHERE wantvote=? AND candidateid=?';
    var params = [placeid, candidateid]

    db.query(sql, params, function(err, res) {
        if(!err) {
            result(null, res)
        } else {
            result(err, null)
        }
    })
}



module.exports.searchPlaceInfo = function(placeid, result) {
    var sql = 'SELECT * FROM placeinfo WHERE placeid=?';
    var params = [placeid]
    db.query(sql, params, function(err, res){
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
}

module.exports.updateIsStarted = function(placeid, isStarted, result) {
    var sql = 'UPDATE placeinfo SET isStarted=? WHERE placeid=?;';

    var params = [isStarted, placeid];
    db.query(sql, params, function(err, res){
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
}

// db의 미등록 후보자 정보를 불러옵니다.
module.exports.selectCandidateList = function(placeid, result){
    var wantVote = placeid;
    var sql = 'SELECT u.user_login, u.user_email, u.user_registered, SUBSTRING_INDEX(group_concat(m.meta_value), \',\', -1) AS \'wantVote\', SUBSTRING_INDEX(group_concat(m.meta_value), \',\', 1) AS \'name\', u.state FROM wp_users u JOIN wp_usermeta m ON u.ID = m.user_id WHERE m.meta_key= "wantVote" OR m.meta_key= "first_name" GROUP BY user_login HAVING SUBSTRING_INDEX(group_concat(m.meta_value), \',\', -1)=?';
    var params = [wantVote]
    db.query(sql, params, function(err, res){
        if(!err){
            result(null, res);
        }else{
            result(err, null);    
        }
    })
}


