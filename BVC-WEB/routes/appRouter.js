// 앱과 연동하는 라우터입니다.
// output으로 json이 출력되어야 합니다.
var async = require('async');
var express = require('express');
var router = express.Router();
var path = process.cwd();
var blockFunc = require( path + '/model/blockFunc' );
var dbFunc = require( path + '/model/dbFunc' );
var view = require( path + '/view/json' );

// 1. 선거가 시작 중인 선거장
router.get('/getStartedPlace', function(req, res){
    blockFunc.placeLength(function(err, length){
        if(!err){
            blockFunc.extractArr(0, 0, length, function(err, result){
                var outcome = [];

                if(!err) {
                    result.map(function (item, index) {
                        outcome.push(appClosureAdd(0, item["placeid"], null, null));
                    })

                    async.series(outcome, function(err, resEnd){
                        if (!err){
                            var startedOutcom = [];

                            if(!err) {
                                resEnd.map(function (item, index){
                                    item.map(function(_item, _index){
                                        if(_item["isStarted"] == 1){
                                            startedOutcom.push(appClosureAdd(1, null, item, null));
                                        }
                                    })
                                })
                            }

                            async.series(startedOutcom, function(err, finish){
                                view.jsonParsing(200, "success", finish, function(jsonData){
                                    res.json(jsonData);
                                })
                            })
                        } else {
                            view.jsonParsing(400, "등록된 투표장을 확인할 수 없습니다.", "", function(jsonData){
                                res.json(jsonData);
                            })
                        }
                    })
                } else {
                    view.jsonParsing(400, "등록된 투표장을 확인할 수 없습니다.", "", function(jsonData){
                        res.json(jsonData);
                    })
                }
            })
        } else {
            view.jsonParsing(400, "등록된 투표장을 확인할 수 없습니다.", "", function(jsonData){
                res.json(jsonData);
            })
        }
    })
})

// 2. 선거가 종료된 선거장
router.get('/getEndedPlace', function(req, res){
    blockFunc.placeLength(function(err, length){
        if(!err){
            blockFunc.extractArr(0, 0, length, function(err, result){
                var outcome = [];

                if(!err) {
                    result.map(function (item, index) {
                        outcome.push(appClosureAdd(0, item["placeid"], null, null));
                    })

                    async.series(outcome, function(err, resEnd){
                        if (!err){
                            var startedOutcom = [];

                            if(!err) {
                                resEnd.map(function (item, index){
                                    item.map(function(_item, _index){
                                        if(_item["isStarted"] == 3){
                                            startedOutcom.push(appClosureAdd(1, null, item, null));
                                        }
                                    })
                                })
                            }

                            async.series(startedOutcom, function(err, finish){
                                view.jsonParsing(200, "success", finish, function(jsonData){
                                    res.json(jsonData);
                                })
                            })
                        } else {
                            view.jsonParsing(400, "등록된 투표장을 확인할 수 없습니다.", "", function(jsonData){
                                res.json(jsonData);
                            })
                        }
                    })
                } else {
                    view.jsonParsing(400, "등록된 투표장을 확인할 수 없습니다.", "", function(jsonData){
                        res.json(jsonData);
                    })
                }
            })
        } else {
            view.jsonParsing(400, "등록된 투표장을 확인할 수 없습니다.", "", function(jsonData){
                res.json(jsonData);
            })
        }
    })
})

// 4. 입력한 투표장의 모든 후보자를 볼 수 있습니다.
router.get('/getAllCandidate', function(req, res){
    var placeid = req.param('placeid');

	blockFunc.candidateLength(function(err, length){
        if(!err){
            blockFunc.extractArr(1, placeid, length, function(_err, result){
                if(!_err) {
                    view.jsonParsing(200, "success", result, function(jsonData){
                        res.json(jsonData);
                    })
                } else {
                    view.jsonParsing(400, "등록된 후보자를 확인할 수 없습니다.", "", function(jsonData){
                        res.json(jsonData);
                    })
                }
            })
        } else {
            view.jsonParsing(400, "등록된 후보자를 확인할 수 없습니다.", "", function(jsonData){
                res.json(jsonData);
            })
        }
    })
});

// 6. 개표합니다.
router.get('/getCounting', function(req, res){
    var placeid = req.param('placeid');

    blockFunc.candidateLength(function(err, length){
        if(!err){
            blockFunc.extractArr(2, placeid, length, function(_err, result){
                if(!_err) {
                    view.jsonParsing(200, "success", result, function(jsonData){
                        res.json(jsonData);
                    })
                } else {
                    view.jsonParsing(400, "개표 결과를 볼 수 없습니다.", "", function(jsonData){
                        res.json(jsonData);
                    })
                }
            })
        } else {
            view.jsonParsing(400, "개표 결과를 볼 수 없습니다.", "", function(jsonData){
                res.json(jsonData);
            })
        }
    })
});

// 5. 투표권을 행사합니다.
router.get('/setVote', function(req, res){
    var placeid = req.param('placeid');
    var candidateid = req.param('candidateid');
    var phone = req.param('phone');

    blockFunc.getCheckVoted(placeid, phone, function(err, res){
        if(!err){
            blockFunc.setVote(placeid, candidateid, phone, function(_err, _res) {
                if(!err) {
                    view.jsonParsing(200, "success", _res, function(jsonData){
                        res.json(jsonData);
                    })
                } else {
                    view.jsonParsing(400, "투표를 진행할 수 없습니다.", "", function(jsonData){
                        res.json(jsonData);
                    })
                }
            });
        } else {
            view.jsonParsing(401, "이미 투표권을 행사하셨습니다.", "", function(jsonData){
                res.json(jsonData)
            })
        }
    })
});

function appClosureAdd(selector, placeid, item, candidateid){
    switch(selector) {
        case 0:
            return function(callback){
                dbFunc.searchPlaceInfo(placeid, function(err, result){
                    callback(null, result)
                })
            }
            break;

        case 1:
            return function(callback){
                callback(null, item)
            }
            break;
        default:
            console.log("why?")
    }
}

module.exports = router;
