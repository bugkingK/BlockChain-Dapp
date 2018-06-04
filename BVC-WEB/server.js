// 필요한 npm 설치
var Web3 = require('web3');
var express = require('express');
var mysql = require('mysql');

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

// web3의 위치를 지정하는 함수입니다. web3의 위치는 http://yangarch.iptime.org:8545에 있습니다.
web3.setProvider(new web3.providers.HttpProvider('http://yangarch.iptime.org:8545'));

// sol파일의 컨트랙트 주소입니다.
var contractAddress = '0x297d224cab15ab34c4cbe81920069dc7c88bd763';
// sol파일의 abi 값입니다.
var interface = [{"constant":false,"inputs":[],"name":"setAllPlace","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"voterList","outputs":[{"name":"phone","type":"uint256"},{"name":"votedPlace","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"setVoteStart","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getCandidate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"setAllCandidate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getAllplace","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_phone","type":"uint256"},{"name":"_votedPlace","type":"uint256"}],"name":"getCheckVoted","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getPollingPlace","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_votedPlace","type":"uint256"},{"name":"_candidateID","type":"uint256"},{"name":"_phone","type":"uint256"}],"name":"setVote","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"setPollingPlace","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"candidateList","outputs":[{"name":"placeID","type":"uint256"},{"name":"voteCount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_candidateID","type":"uint256"}],"name":"getCounting","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"setVoteEnd","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"placeList","outputs":[{"name":"voting","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"setCandidate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"v","type":"uint256"}],"name":"uintToString","outputs":[{"name":"str","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getAllCandidate","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"}];
// 컨트랙트를 연결합니다.
var contract = web3.eth.contract(interface);
var BVC = contract.at(contractAddress);
// eth를 지불할 eth지갑을 선택합니다.
web3.eth.defaultAccount = web3.eth.accounts[0];

// ------------------------- 기본세팅 변경될 사항은 web3주소와 컨트랙트 주소, abi만 가변성이 있습니다. -----------------------------------
//등록 페이지를 실행합니다.
app.get('/set', function(req, res){
    res.sendFile(__dirname + '/public/setpolling.html');
});

// 투표장을 생성합니다.
app.post('/public/finishset', function(req, res){
    res.sendFile(__dirname + '/public/finishset.html');
    
    var name=req.body.user_name;
    var start_regist_period=req.body.start_regist_period;
    var end_regist_period=req.body.end_regist_period;
    var votedate=req.body.votedate;
    var start_vote_time=req.body.start_vote_time;
    var end_vote_time=req.body.end_vote_time;
    
    setPollingPlace(function(placeID){
        var sql= 'INSERT INTO placeinfo (name, start_regist_period, end_regist_period, votedate, start_vote_time, end_vote_time,placeid) VALUES(?,?,?,?,?,?,?)' ;
        conn.query(sql, [name, start_regist_period, end_regist_period, votedate, start_vote_time, end_vote_time,placeID], function(err, result, fields){
            if(!err){
                res.sendFile(__dirname + '/public/finishset.html');
            }else{
                console.log(err);
            }
        });
    });
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

app.get('/dbtest', function (req, res) {
    dbTest();
});

app.get('/timeout', function (req, res) {
    setTimeout(timeout, 5000, '원하는 값 입력');
});


// ------------------------- 메소드입니다 -----------------------------

// db 연결 예제
function dbTest(){
    var sql_ID = 'SELECT * from placeinfo';
    conn.query(sql_ID, function(err, res){
      if(!err) {
        console.log(res);
      } else {
        console.log(err);
      }
    })
  }

  // timeout 테스트
  function timeout(arg) {
    console.log('5초 후 작동합니다. 원하는 값도 넣을 수 있습니다. ${arg}');
  }

function jsonParsing(code, message, data, json) {
    var jsonString = {
        "code"     : code,
        "message"  : message,
        "data"     : data
    }
    json(jsonString);
}

// 1. 투표장을 생성하는 메소드입니다.
function setPollingPlace(placeID){
  BVC.setPollingPlace.sendTransaction(function(err, res){
    if(!err) {
      BVC.getPollingPlace.call(function(err, res){
        // 방금 생성한 투표장의 번호를 반환합니다.
        if(!err) {
            placeID = res;
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
    // set에서 get으로 
    BVC.setAllPlace.sendTransaction(function(err, res){
        if(!err) {
            BVC.getAllplace.call(function(err, res){
                if(!err) {
                    var placeid = { "placeid" : res };

                    jsonParsing(200, "success", placeid, json);
                } else {
                    jsonParsing(400, err, "", json);
                }
            })
        } else {
            jsonParsing(400, err, "", json);
        }
    });
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
