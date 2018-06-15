// 웹과 연동하는 라우터입니다.
var async = require('async');
var ejs = require('ejs')
var fs = require('fs');
var express = require('express');
var router = express.Router();

var bodyParser = require('body-parser');
router.use(bodyParser.json());
router.use(bodyParser.urlencoded({extended : false}));

var path = process.cwd();
var blockFunc = require( path + '/model/blockFunc' );
var dbFunc = require( path + '/model/dbFunc' );

// 1-1. 선거장 생성 page open
router.get('/setPollingPlace', function(req, res){
    res.sendFile( path + '/public/setPollingPlace.html');
});

// 1-2. 선거장 생성하는 메소드
router.post('/setPollingPlace', function(req, res){
    var info = [req.body.user_name,
                req.body.start_regist_period,
                req.body.end_regist_period,
                req.body.votedate,
                req.body.place_contents,
                req.body.start_vote_time,
                req.body.end_vote_time];

    blockFunc.setPollingPlace(function(err, placeid, isStarted){
        if (!err) {
            if (placeid != null){
                dbFunc.insertPlaceInfo(placeid, isStarted, info, function(result){
                    res.redirect('/web/getAllplace');
                });
            } else {
                res.send('block Chain err!')
            }
        } else {
            res.send('setPollingPlace... err!!!');
            console.log(err);
        }
    });
});

// 2-1. 모든 선거리스트를 전송합니다.
router.get('/getAllplace', function(req, res){
    fs.readFile( path + '/public/getAllplace.html', 'utf8', function(err, data){
        if(!err){
            blockFunc.placeLength(function(err, length){
                if(!err){
                    blockFunc.extractArr(0, 0, length, function(err, result){
                        var outcome = [];

                        if(!err) {
                            result.map(function (item, index) {
                                outcome.push(webClosureAdd(0, item["placeid"], null, null));
                            })

                            async.series(outcome, function(err, resEnd){
                                if (!err){
                                    res.send(ejs.render(data, { placeInfoList : resEnd }));
                                } else {
                                    res.send(err);
                                }
                            })
                        } else {
                            res.send('err')
                        }
                    })
                } else {
                    res.send('err')
                }
            })
        } else {
            res.send("투표 시작 페이지를 불러올 수 없습니다. 잠시 후 다시 접속해주세요.");
        }
    })
});

// 2-2. 투표를 시작합니다. (정해진 기간동안 투표권을 행사할 수 있습니다.)
router.get('/setVoteStart/:placeid', function (req, res) {
    var placeid = req.params.placeid;

    blockFunc.setVoteStart(placeid, function(err, result) {
        if (!err) {
            dbFunc.updateIsStarted(placeid, true, function(_err, _res) {
                if (!_err) {
                    res.redirect('/web/getAllplace');
                } else {
                    result('<h1>투표를 시작하지 못했습니다.....db err</h1>');
                }
            })
        } else {
            result('<h1>투표를 시작하지 못했습니다.....err</h1>');
        }
    });
});

// 2-3. 투표를 종료합니다. (투표권을 더 이상 행사할 수 없습니다.)
router.get('/setVoteEnd/:placeid', function (req, res) {
    var placeid = req.params.placeid;

    blockFunc.setVoteEnd(placeid, function(err, result) {
        if (!err) {
            dbFunc.updateIsStarted(placeid, 3, function(_err, _res) {
                if (!_err) {
                    res.redirect('/web/getAllplace');
                } else {
                    result('<h1>투표를 종료하지 못했습니다.....db err</h1>');
                }
            })
        } else {
            result('<h1>투표를 종료하지 못했습니다.....err</h1>');
        }
    });
});

// 3-1. 입력한 투표장의 모든 후보자를 볼 수 있습니다.
router.get('/getAllCandidate/:placeid', function(req, res){
    var placeid = req.params.placeid;
    var nowcandidate = [];
    var bookedCandidate = [];

    fs.readFile('public/getAllCandidate.html', 'utf8', function(err, data){
        dbFunc.selectCandidateList(placeid, function(_err, _res) {
            if(!_err){
                var result = []

                _res.map(function (item, index) {
                    result.push(webClosureAdd(1, null, item, null));
                })

                async.series(result, function(err, resEnd){
                    nowcandidate = resEnd
                })

                blockFunc.candidateLength(function(err, length){
                    if(!err){
                        blockFunc.extractArr(1, placeid, length, function(_err, _result){
                            if(!_err) {
                                var outcomeBooked = []

                                _result.map(function (item, index) {
                                    if(item == null) {
                                        outcomeBooked.push(webClosureAdd(2, placeid, null, null));
                                    } else {
                                        outcomeBooked.push(webClosureAdd(2, placeid, null, item["CandidateID"]));
                                    }

                                })

                                async.series(outcomeBooked, function(err1, resEnd1){
                                    bookedCandidate = resEnd1
                                    console.log(resEnd1)
                                    res.send(ejs.render(data, {candidateList : nowcandidate, bookedCandidateList : bookedCandidate}));
                                })

                            } else {
                                res.send('err');
                            }
                        })
                    } else {
                        res.send('err');
                    }
                })
            } else {
                res.send("err candidateList를 가져오지 못했습니다.")
            }
        })
    })
})

// 3-2. 입력한 투표장의 등록된 후보자를 볼 수 있습니다.
router.get('/getBookedCandidate/:placeid', function (req, res){
    var placeid = req.params.placeid;

    fs.readFile( path + '/public/getBookedCandidate.html', 'utf8', function(err, data) {
        blockFunc.candidateLength(function(err, length){
            if(!err){
                blockFunc.extractArr(1, placeid, length, function(_err, _result){
                    if(!_err) {
                        var outcomeBooked = []

                        _result.map(function (item, index) {
                            if(item == null) {
                                outcomeBooked.push(webClosureAdd(2, placeid, null, null));
                            } else {
                                outcomeBooked.push(webClosureAdd(2, placeid, null, item["CandidateID"]));
                            }
                        })

                        async.series(outcomeBooked, function(err1, resEnd1){
                            res.send(ejs.render(data, {bookedCandidateList : resEnd1}));
                        })

                    } else {
                        res.send('err');
                    }
                })
            } else {
                res.send('err');
            }
        })
    });
});

// 3-3. 후보자를 등록합니다. 웹페이지
router.get('/getAllCandidate/setCandidate/:placeid/:user_login/:name', function (req, res) {
    var user_login=req.params.user_login;
    var name=req.params.name;
    var placeid=req.params.placeid;

    blockFunc.setCandidate(placeid, function(err, candidateid){
        if(!err) {
            dbFunc.insertCandidateInfo(placeid, candidateid, name, user_login, function(result){
                if (!err) {
                    res.redirect('/web/getAllCandidate/' + placeid);
                } else {
                    console.log('candidate insert fail');
                }
            })
        }else{
            console.log('setCandidate bv fail')
        }
    })
});

// 3-4. 후보자를 사퇴시킵니다.
router.get('/getAllCandidate/setCandidateResign/:candidateid/:placeid', function(req, res){
    var candidateid = req.params.candidateid;
    var placeid = req.params.placeid;
    dbFunc.updateCandidateState(candidateid, function(_err, _res){
        if(!_err){
            console.log('state update success');
            res.redirect('/web/getAllCandidate/' + placeid);
        } else {
            console.log('state update err : ' + err);
        }
    })
})

// 6. 개표합니다.
router.get('/getCounting', function(req, res){
    fs.readFile( path + '/public/getCounting.html', 'utf8', function(err, data){
        if(!err){
            blockFunc.placeLength(function(err, length){
                if(!err){
                    blockFunc.extractArr(0, 0, length, function(err, result){
                        var outcome = [];

                        if(!err) {
                            result.map(function (item, index) {
                                outcome.push(webClosureAdd(0, item["placeid"], null, null));
                            })

                            async.series(outcome, function(err, resEnd){
                                if (!err){
                                    res.send(ejs.render(data, { placeInfoList : resEnd }));
                                } else {
                                    res.send(err);
                                }
                            })
                        } else {
                            res.send('err')
                        }
                    })
                } else {
                    res.send('err')
                }
            })
        } else {
            res.send("투표 시작 페이지를 불러올 수 없습니다. 잠시 후 다시 접속해주세요.");
        }
    })
});

// 7. 개표결과 페이지입니다.
router.get('/getVotingCount/:placeid', function(req, res){
  var placeid = req.params.placeid;
  
  fs.readFile( path + '/public/getVotingCount.html', 'utf8', function(err, data){
    if(!err){
      blockFunc.candidateLength(function(err, length){
          if(!err){
              blockFunc.extractArr(1, placeid, length, function(_err, _result){
                  if(!_err) {
                      var outcomeBooked = []

                      _result.map(function (item, index) {
                          if(item == null) {
                              outcomeBooked.push(webClosureAdd(2, placeid, null, null));
                          } else {
                              outcomeBooked.push(webClosureAdd(2, placeid, null, item["CandidateID"]));
                          }
                      })

                      async.series(outcomeBooked, function(err1, resEnd1){
                          res.send(ejs.render(data, {bookedCandidateList : resEnd1}));
                      })

                  } else {
                      res.send('err');
                  }
              })
          } else {
              res.send('err');
          }
      })
    } else {
        res.send("투표 시작 페이지를 불러올 수 없습니다. 잠시 후 다시 접속해주세요.");
    }
  })
});

function webClosureAdd(selector, placeid, item, candidateid){
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
        case 2:
            return function(callback){
                dbFunc.searchCandidateInfo(placeid, candidateid, function(err, result){
                    callback(null, result)
                })
            }
        default:
            console.log("why?")
    }
}


module.exports = router;
