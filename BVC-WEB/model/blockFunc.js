// 블록체인에 연결하는 함수들입니다.

var async = require('async');
var path = process.cwd();
var BVC = require( path + '/config/blockChain')

// 1. 블록체인에 선거장을 생성합니다. placeid를 반환합니다.
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

// 2. 블록체인에 후보자를 생성합니다. candidateid를 반환합니다.
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

// 5. 투표하는 메소드입니다.
module.exports.setVote = function(placeid, candidateid, phone, result) {
    BVC.setVote.sendTransaction(placeid, candidateid, phone, {gas: 900000, gasPrice: 1}, function(err, res) {
        if(!err) {
            result(null, res);
        } else {
            result(err, null);
        }
    })
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
            result(null, res)
        } else {
            result(err, null);
        }
    })
};

// selector = 0인 경우 등록된 선거장을 추출합니다. extractArr(0, null, length, function(err, res))
// selector = 1인 경우 등록된 후보자를 추출합니다. extractArr(1, placeid, length, function(err, res))
// selector = 2인 경우 개표를 결과를 추출합니다. extractArr(2, placeid, length, function(err, res))
module.exports.extractArr = function(selector, placeid, length, outcome) {
    var result = []

    Array.apply(null, Array(parseInt(length))).map(function (item, index) {
        result.push(closureAdd(selector, index, placeid));
    })

    async.series(result, function(err, resEnd){
        if (!err){
            outcome(null, resEnd)
        } else {
            outcome(err, null)
        }
    })
};

function closureAdd(number, index, placeid){
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
                exports.getCandidateId(index, placeid, function(err, result){
                    callback(null, result)
                })
            }
            break;
        case 2:
            return function(callback){
                exports.getCounting(index, placeid, function(err, result){
                    if(!err){
                        callback(null, result)
                    }
                })
            }
            break;
        default:
            console.log("why?")
    }
}

// 등록된 투표장 길이 반환
module.exports.placeLength = function(result) {
    BVC.getPlaceLength(function(err, res){
        if(!err) {
            result(null, res.toLocaleString());
        } else {
            result(err, null);
        }
    })
};

// 등록된 후보자 길이 반환
module.exports.candidateLength = function(result) {
    BVC.getCandidateLength(function(err, res){
        if(!err) {
            result(null, res.toLocaleString());
        } else {
            result(err, null);
        }
    })
};

// 등록된 투표장의 정보를 반환
module.exports.getPlaceId = function(placeid, placeInfo) {
    BVC.getPlaceId(placeid, function(err, res){
        if(!err) {
            var contents = { "placeid" : res[0].toLocaleString(), "isStarted" : res[1].toLocaleString()}
            placeInfo(contents)
        } else {
            console.log(err);
        }
    })
};

// 등록된 후보자의 정보를 반환
module.exports.getCandidateId = function(index, placeid, candidateInfo) {
    BVC.getCandidateId(index, function(err, res){
        if(!err) {
            if(parseInt(placeid) == parseInt(res[0].toLocaleString())){
                var contents = { "placeID" : res[0].toLocaleString(), "CandidateID" : res[1].toLocaleString()}
                candidateInfo(null, contents)
            } else {
                candidateInfo(null, null)
            }
        } else {
            console.log(err);
        }
    })
};

// 6. 개표합니다.
module.exports.getCounting = function(index, placeid, candidateInfo) {
    BVC.getCounting(placeid, index, function(err, res){
        if(!err){
            if(parseInt(placeid) == parseInt(res[0].toLocaleString())){
                var contents = {"placeid" : res[0].toLocaleString(), "candidateid" : res[1].toLocaleString(), "voteCount" : res[2].toLocaleString()};
                candidateInfo(null, contents)
            } else {
                candidateInfo(null, null)
            }
        } else {
            console.log(err);
        }
    })
};
