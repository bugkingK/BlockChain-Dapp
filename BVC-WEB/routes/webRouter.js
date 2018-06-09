// 웹과 연동하는 라우터입니다.
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

//등록 페이지를 실행합니다. ok
router.get('/setPollingPlace', function(req, res){
    res.sendFile( path + '/public/setPollingPlace.html');
});

// 1. 투표장을 생성합니다. 웹페이지 ok
router.post('/setPollingPlace', function(req, res){
    var info = [req.body.user_name,
                req.body.start_regist_period,
                req.body.end_regist_period,
                req.body.votedate,
                req.body.place_contents,
                req.body.start_vote_time,
                req.body.end_vote_time];

    blockFunc.setPollingPlace(function(err, placeid){
        if (!err) {
            if (placeid != null){
                dbFunc.InsertPlaceInfo(placeid, info,function(result){
                    res.send(result);
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

// 2. 후보자를 등록합니다. 웹페이지
router.get('/setCandidate', function (req, res) {
    blockFunc.setCandidate(1, function(json){
        console.log(json)
    })
});

// 3. 등록된 투표장을 볼 수 있습니다.
router.get('/getAllplace', function (req, res) {
    blockFunc.placeLength(function(length){
        blockFunc.searchList(0, false, length, res)
    })
});

// 4. 입력한 투표장의 모든 후보자를 볼 수 있습니다.
router.get('/getAllCandidate', function (req, res){
    blockFunc.candidateLength(function(length){
        blockFunc.searchList(1, false, length, res);
    })
});


// 6. 개표합니다. - 웹페이지 형태와 json 형태가 필요합니다.
router.get('/getCounting', function (req, res) {
    blockFunc.getCounting('testestestes');
});


// 투표 시작 페이지입니다.
router.get('/setVoteStart', function(req, res){
    fs.readFile( path + '/public/setVoteStart.html', 'utf8', function(err, data){
        if(!err){
            dbFunc.searchPlaceInfo(function(err, result){
                if(!err) {
                    res.send(ejs.render(data, {placeInfoList : result}));
                } else {
                    res.send("데이터를 불러올 수 없습니다. 잠시 후 다시 접속해주세요.")
                }
            })
        } else {
            res.send("투표 시작 페이지를 불러올 수 없습니다. 잠시 후 다시 접속해주세요.");
        }
    })
});

// 8. 투표를 시작합니다. (정해진 기간동안 투표권을 행사할 수 있습니다.) 웹페이지
router.post('/setVoteStart', function (req, res) {
    var placeid = req.body.placeid;
    console.log(placeid)

    blockFunc.setVoteStart(placeid, function(err, result) {
        if (!err) {
            res.send('<h1>투표장 번호 : ' + placeid + ' 가 시작되었습니다.....end</h1>')
        } else {
            result('<h1>투표를 시작하지 못했습니다.....err</h1>');
            console.log('투표 시작 실패 : ' + err);
        }
    });
});

// 9. 투표를 종료합니다. (투표권을 더 이상 행사할 수 없습니다.) 웹페이지
router.get('/setVoteEnd', function (req, res) {
    var placeid = req.body.placeid;

    blockFunc.setVoteEnd(placeid, res);
});

// 후보자 정보를 가져옵니다.
router.get('/searchCandidateInfo', function (req, res) {
    dbFunc.searchCandidateInfo(function(result) {

    })
})

module.exports = router;