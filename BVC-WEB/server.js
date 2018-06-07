// 필요한 npm 설치

var express = require('express');
// web3와 express 변수를 선언합니다.
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended : false}));

var path = process.cwd();
var blockFunc = require( path + '/function/blockFunc' );
var dbFunc = require( path + '/function/dbFunc' );
var view = require( path + '/function/view' );


// <--------------------- server Start ----------------------->

//등록 페이지를 실행합니다.
app.get('/set', function(req, res){
    res.sendFile(__dirname + '/public/setpolling.html');
});

// 1. 투표장을 생성합니다.
app.post('/public/finishset', function(req, res){
    var info = [req.body.user_name,
                req.body.start_regist_period,
                req.body.end_regist_period,
                req.body.votedate,
                req.body.place_contents,
                req.body.start_vote_time,
                req.body.end_vote_time];

    blockFunc.setPollingPlace(function(placeid){

        dbFunc.InsertPlaceInfo(placeid, info,function(result){
            res.send(result);
        });
    });
});

// 2. 후보자를 등록합니다.
app.get('/setCandidate', function (req, res) {
    blockFunc.setCandidate(1, function(json){
        console.log(json)
    })
});


// 3. 등록된 투표장을 볼 수 있습니다.
app.get('/getAllplace', function (req, res) {
    blockFunc.placeLength(function(length){
        blockFunc.searchList(0, length, res)
    })
});

// 4. 입력한 투표장의 모든 후보자를 볼 수 있습니다.
app.get('/getAllCandidate', function (req, res){
    blockFunc.candidateLength(function(length){
        blockFunc.searchList(1, length, res);
    })
});


// 5. 투표권을 행사합니다.
app.get('/setVote', function (req, res) {
    var placeid = req.param('placeid');
    var candidateid = req.param('candidateid');
    var phone = req.param('phone');

    blockFunc.setVote(placeid, candidateid, phone, function(jsonData) {
        res.json(jsonData);
    });
});

// 6. 개표합니다.
app.get('/getCounting', function (req, res) {
    blockFunc.getCounting('testestestes');
});

// 7. 투표했는지 여부를 확인합니다.
app.get('/getCheckVoted', function (req, res) {
    var placeid = req.param('placeid');
    var phone = req.param('phone');

    blockFunc.getCheckVoted(placeid, phone, function(jsonData) {
        res.json(jsonData);
    });
});

// 8. 투표를 시작합니다. (정해진 기간동안 투표권을 행사할 수 있습니다.)
app.get('/setVoteStart', function (req, res) {
    //var placeid = req.param('placeid');

    blockFunc.setVoteStart(0, function(jsonData){
        res.json(jsonData);
    });
});

// 9. 투표를 종료합니다. (투표권을 더 이상 행사할 수 없습니다.)
app.get('/setVoteEnd', function (req, res) {
    //var placeid = req.param('placeid');

    blockFunc.setVoteEnd(0, function(jsonData){
        res.json(jsonData);
    });
});




app.listen(4210, function () {
  console.log('eth server start: 4210');
});
