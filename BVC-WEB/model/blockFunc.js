// 블록체인에 연결하는 함수들입니다.

var async = require('async');
var path = process.cwd();
var view = require( path + '/view/json' );
var BVC = require( path + '/config/blockChain')

// 1. 투표장 등록하는 메소드입니다. 결과로 placeid를 반환합니다.
module.exports.setPollingPlace = function(result) {
    BVC.setPollingPlace.sendTransaction(function(_err, _res){
        if(!_err) {
            BVC.getPollingPlace.call(function(err, res){
                if(!err) {
                    result(null, res[0].toLocaleString(), res[1].toLocaleString());
                } else {
                    result(err, null);
                }
            })
        } else {
            result(_err, null);
        }
    });
};

// 2. 후보자 등록하는 메소드입니다. 결과로 candidateid를 반환합니다.
module.exports.setCandidate = function(placeid, result) {
    BVC.setCandidate.sendTransaction(placeid, function(_err, _res){
        if(!_err) {
            BVC.getCandidate.call(function(err, res){
                if(!err) {
                    result(null, res.toLocaleString());
                } else {
                    result(err, null);
                }
            })
        } else {
            result(_err, null);
        }
    })
};

// 3. 등록된 투표장 보는 메소드입니다.
// 등록된 투표장 길이 반환
module.exports.placeLength = function(length) {
    BVC.getPlaceLength(function(err, res){
        if(!err) {
            length(res.toLocaleString());
        } else {
            console.log(err);
        }
    })
};

// 등록된 투표장의 정보를 반환
module.exports.getPlaceId = function(index, placeInfo) {
    BVC.getPlaceId(index, function(err, res){
        if(!err) {
            var contents = { "placeid" : res[0].toLocaleString(), "isStarted" : res[1].toLocaleString()}
            placeInfo(contents)
        } else {
            console.log(err);
        }
    })
};


// 4. 등록된 후보자를 보는 메소드입니다.
// 등록된 후보자 길이 반환
module.exports.candidateLength = function(length) {
    BVC.getCandidateLength(function(err, res){
        if(!err) {
            length(res.toLocaleString());
        } else {
            console.log(err);
        }
    })
};

// 등록된 후보자의 정보를 반환
module.exports.getCandidateId = function(index, candidateInfo) {
    BVC.getCandidateId(index, function(err, res){
        if(!err) {
            var contents = { "placeID" : res[0].toLocaleString(), "CandidateID" : res[1].toLocaleString()}
            candidateInfo(contents)
        } else {
            console.log(err);
        }
    })
};

// 5. 투표하는 메소드입니다.
module.exports.setVote = function(placeid, candidateid, phone, result) {
    BVC.setVote(placeid, candidateid, phone, function(err, res) {
        // 트랜젝션 주소가 err로 갈지 res로 갈지 체크해봐야함. 이 구문이 제대로 돌지 못할 수 있음을 유의하셈.
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
};

// 6. 개표합니다.
module.exports.getCounting = function(candidateid, res) {
    console.log(" counting test ");
};


// 7. 투표를 했는지 확인하는 메소드입니다.
module.exports.getCheckVoted = function(placeid, phone, result) {
    BVC.getCheckVoted(phone, placeid, function(err, res) {
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    });
};

// 8. 투표를 시작합니다.
module.exports.setVoteStart = function(placeid, result) { 
    BVC.setVoteStart(placeid, function(err, res){
        if(!err) {
            result(null, res)
        } else {
            result(err, null);
        }
    })
};

// 9. 투표를 종료합니다.
module.exports.setVoteEnd = function(placeid, result) { 
    BVC.setVoteEnd(placeid, function(err, res){
        if(!err) {
            console.log('투표장 번호 : ' + placeid + ' 가 종료되었습니다.');
            result('<h1>투표장 번호 : ' + placeid + ' 가 종료되었습니다.....end</h1>');
        } else {
            console.log(err);
            result('<h1>투표를 끝내지 못했습니다.....err</h1>');
        }
    })
};


module.exports.searchList = function(selecter, isjson, length, res) {
    var result = []

    Array.apply(null, Array(parseInt(length))).map(function (item, index) {
        result.push(closureAdd(selecter, index));
    })

    async.series(result, function(err, resEnd){
        if (isjson) {
            view.jsonParsing(200, "success", resEnd, function(jsonData){
                res.json(jsonData)
            })
        } else {
            res.send('html')
        }
    })
};

function closureAdd(number, index){
    switch(number) {
        case 0:
            return function(callback){
                exports.getPlaceId(index, function(placeInfo){
                    callback(null, placeInfo)
                })
            }
            break;
        case 1:
            return function(callback){
                exports.getCandidateId(index, function(CandidateInfo){
                    callback(null, CandidateInfo)
                })
            }
            break;
        default:
            console.log("why?")

    }
}
