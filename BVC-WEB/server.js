// 필요한 npm 설치
var Web3 = require('web3');
var express = require('express');
var mysql = require('mysql');
var solc = require('solc');
var fs = require('fs');
var bodyParser = require('body-parser');

// web3와 express 변수를 선언합니다.
var app = express();
var web3 = new Web3();
var conn = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'arch0115',
  database : 'vote'
});

conn.connect();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended : false}));

// web3의 위치를 지정하는 함수입니다. web3의 위치는 http://yangarch.iptime.org:8545에 있습니다.
web3.setProvider(new web3.providers.HttpProvider('http://yangarch.iptime.org:4211'));

var code = fs.readFileSync('BVC.sol').toString();
var compiledCode = solc.compile(code);

// sol파일의 abi 값입니다.
var abiDefinition = JSON.parse(compiledCode.contracts[':BVC'].interface);

// eth를 지불할 eth지갑을 선택합니다.
web3.eth.defaultAccount = web3.eth.accounts[0];

// sol파일의 컨트랙트 주소입니다.
var contractAddress = '0xce519da8449172cf285dc3410f261637c848787f';

// 컨트랙트를 연결합니다.
var contract = web3.eth.contract(abiDefinition);
var BVC = contract.at(contractAddress);



// ------------------------- 기본세팅 변경될 사항은 web3주소와 컨트랙트 주소, abi만 가변성이 있습니다. -----------------------------------
//등록 페이지를 실행합니다.
app.get('/set', function(req, res){
    res.sendFile(__dirname + '/public/setpolling.html');
});

// 투표장을 생성합니다.
app.post('/public/finishset', function(req, res){
    var name=req.body.user_name;
    var start_regist_period=req.body.start_regist_period;
    var end_regist_period=req.body.end_regist_period;
    var votedate=req.body.votedate;
    var start_vote_time=req.body.start_vote_time;
    var end_vote_time=req.body.end_vote_time;

    setPollingPlace(function(jsonData){
        var placeID = jsonData["data"];

        var sql= 'INSERT INTO placeinfo (name, start_regist_period, end_regist_period, votedate, start_vote_time, end_vote_time, placeid) VALUES(?,?,?,?,?,?,?)' ;
        conn.query(sql, [name, start_regist_period, end_regist_period, votedate, start_vote_time, end_vote_time, placeID], function(err, result, fields){
            if(!err){
                console.log("insert success");
                res.sendFile(__dirname + '/public/finishset.html');
            }else{
                console.log("오류남");
                console.log(err);
            }
        });
    });
    // res.sendFile(__dirname + '/public/finishset.html');
});

// 후보자를 등록합니다.
app.get('/setCandidate', function (req, res) {
});


// 등록된 투표장을 볼 수 있습니다.
app.get('/getAllplace', function (req, res) {
    getAllplace(function(jsonData){
        res.json(jsonData);
    });
});


// 투표권을 행사합니다.
app.get('/setVote', function (req, res) {  
    var placeid = req.param('placeid');
    var candidateid = req.param('candidateid');
    var phone = req.param('phone');

    setVote(placeid, candidateid, phone, function(jsonData) {
        res.json(jsonData);
    });
});

// 투표했는지 여부를 확인합니다.
app.get('/getCheckVoted', function (req, res) {
    var placeid = req.param('placeid');
    var phone = req.param('phone');

    getCheckVoted(placeid, phone, function(jsonData) {
        res.json(jsonData);
    });
});

// 투표를 시작합니다. (정해진 기간동안 투표권을 행사할 수 있습니다.)
app.get('/setVoteStart', function (req, res) {

    setVoteStart(0, function(jsonData){
        res.json(jsonData);
    });
});

// 투표를 종료합니다. (투표권을 더 이상 행사할 수 없습니다.)
app.get('/setVoteEnd', function (req, res) {  
  
});

// 개표합니다.
app.get('/getCounting', function (req, res) {  
  
});


// ------------------------- 메소드입니다 -----------------------------

function jsonParsing(code, message, data, json) {
    var jsonString = {
        "code"     : code,
        "message"  : message,
        "data"     : data
    }
    json(jsonString);
}

// 1. 투표장을 생성하는 메소드입니다.
function setPollingPlace(json){
  BVC.setPollingPlace.sendTransaction(function(err, res){
    if(!err) {
      BVC.getPollingPlace.call(function(err, res){
        // 방금 생성한 투표장의 번호를 반환합니다.
        if(!err) {
            jsonParsing(200, "success", res, json);
        } else {
            console.log(err);
        }
      })
    } else {
        console.log(err);
    }
  })
}

// 2. 후보자 등록하는 메소드입니다.
function setCandidate(placeid, json) {
    // getCandidate로 등록한 후보자 ID 반환
}

// 3. 등록된 투표장 보는 메소드입니다.
function getAllplace(json) {
    BVC.getPlaceLength(function(err, length){
        if(!err) {
            if(length > 0){

                var result = [];

                for(var i=0; i<length; i++){
                    BVC.getPlaceId(i, function(err, res){
                        if(!err) {
                            var contents = { "placeid" : res[0], "isStarted" : res[1]}
                            result.push(contents)
                        } else {
                            console.log(err);
                        }
                    })
                }

                //for문 종료 후 파시앟면 되는데 콜백이 안대...

            } else {
                jsonParsing(201, "등록된 투표장이 없습니다.", length, json);
            }
        } else {
            console.log(err);
            jsonParsing(400, err, "", json);
        }
    })
}

// 4. 등록된 후보자보기
function getAllCandidate(placeid, json){

}

// 5. 투표하는 메소드입니다.
function setVote(placeid, candidateid, phone, json) {
    BVC.setVote(placeid, candidateid, phone, function(err, res) {
        // 트랜젝션 주소가 err로 갈지 res로 갈지 체크해봐야함. 이 구문이 제대로 돌지 못할 수 있음을 유의하셈.
        if(!err) {
            console.log(res);
            jsonParsing(200, "success", "", json);
        } else {
            console.log(err);
            jsonParsing(400, err, "", json);
        }
    })
}

// 6. 개표합니다.
function getCounting(candidateid) {

}

// 7. 투표를 했는지 확인하는 메소드입니다.
function getCheckVoted(placeid, phone, json) {
    BVC.getCheckVoted(phone, placeid, function(err, res) {
        if(!err) {
            console.log(res);
            jsonParsing(200, "success", "", json);
        } else {
            console.log(err);
            jsonParsing(400, err, "", json);
        }
    });
}

// 8. 투표를 시작합니다.
function setVoteStart(placeid, json) {

    BVC.setVoteStart(1, function(err, res){
        if(!err) {
            jsonParsing(200, "success", "", json);
        } else {
            jsonParsing(400, err, "", json);
        }
    })
}

// 9. 투표를 종료합니다.
function setVoteEnd(placeid) {

}




app.listen(4210, function () {
  console.log('eth server start: 4210');
});
