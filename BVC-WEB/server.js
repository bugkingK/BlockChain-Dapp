// 필요한 npm 설치
var async = require('async');
var express = require('express');
var mysql = require('mysql');
var bodyParser = require('body-parser');
var path = process.cwd();
var func = require( path + '/function/func' );
var view = require( path + '/function/view' );

// web3와 express 변수를 선언합니다.
var app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended : false}));

var conn = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'arch0115',
  database : 'vote'
});

conn.connect();

// <--------------------- server Start ----------------------->

//등록 페이지를 실행합니다.
app.get('/set', function(req, res){
    res.sendFile(__dirname + '/public/setpolling.html');
});

// 1. 투표장을 생성합니다.
app.post('/public/finishset', function(req, res){
    var name=req.body.user_name;
    var start_regist_period=req.body.start_regist_period;
    var end_regist_period=req.body.end_regist_period;
    var votedate=req.body.votedate;
    var start_vote_time=req.body.start_vote_time;
    var end_vote_time=req.body.end_vote_time;
    var contents=req.body.place_contents;

    func.setPollingPlace(function(placeid){
        var placeID = parseInt(placeid);

        var sql_ID = 'INSERT INTO placeinfo (name, start_regist_period, end_regist_period, votedate, contents, start_vote_time, end_vote_time, placeid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
        var params = [name, start_regist_period, end_regist_period, votedate, contents, start_vote_time, end_vote_time, placeID];
        conn.query(sql_ID, params, function(err, res){
            if(!err) {
                console.log("insert success");

            } else {
                console.log(err);
            }
        })

    });
    res.send("투표장이 등록되었습니다.");
});

// 2. 후보자를 등록합니다.
app.get('/setCandidate', function (req, res) {
    func.setCandidate(1, function(json){
        console.log(json)
    })
});


// 3. 등록된 투표장을 볼 수 있습니다.
app.get('/getAllplace', function (req, res) {
    func.placeLength(function(length){
        var result = []

        Array.apply(null, Array(parseInt(length))).map(function (item, index) {
            result.push(closureAdd(index));
        })

        async.series(result, function(err, resEnd){
            //console.log(resEnd)
            view.jsonParsing(200, "success", resEnd, function(jsonData){
                res.json(jsonData)
            })
        })

        function closureAdd(index){
            return function(callback){
                func.getPlaceId(index, function(placeInfo){
                    callback(null, placeInfo)
                })
            }
        }
    })
});

// 4. 입력한 투표장의 모든 후보자를 볼 수 있습니다.
app.get('getAllCandidate', function (req, res){
    func.getAllCandidate(1,1);
})


// 5. 투표권을 행사합니다.
app.get('/setVote', function (req, res) {  
    var placeid = req.param('placeid');
    var candidateid = req.param('candidateid');
    var phone = req.param('phone');

    func.setVote(placeid, candidateid, phone, function(jsonData) {
        res.json(jsonData);
    });
});

// 6. 개표합니다.
app.get('/getCounting', function (req, res) {
    func.getCounting('testestestes');
});

// 7. 투표했는지 여부를 확인합니다.
app.get('/getCheckVoted', function (req, res) {
    var placeid = req.param('placeid');
    var phone = req.param('phone');

    func.getCheckVoted(placeid, phone, function(jsonData) {
        res.json(jsonData);
    });
});

// 8. 투표를 시작합니다. (정해진 기간동안 투표권을 행사할 수 있습니다.)
app.get('/setVoteStart', function (req, res) {
    //var placeid = req.param('placeid');

    func.setVoteStart(0, function(jsonData){
        res.json(jsonData);
    });
});

// 9. 투표를 종료합니다. (투표권을 더 이상 행사할 수 없습니다.)
app.get('/setVoteEnd', function (req, res) {
    //var placeid = req.param('placeid');

    func.setVoteEnd(0, function(jsonData){
        res.json(jsonData);
    });
});





app.listen(4210, function () {
  console.log('eth server start: 4210');
});
