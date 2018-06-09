var async = require('async');
var path = process.cwd();
var view = require( path + '/function/view' );

var Web3 = require('web3');
var solc = require('solc');
var fs = require('fs');
var web3 = new Web3();
// web3의 위치를 지정하는 함수입니다. web3의 위치는 http://yangarch.iptime.org:8545에 있습니다.
web3.setProvider(new web3.providers.HttpProvider('http://yangarch.iptime.org:4211'));

var code = fs.readFileSync('BVC.sol').toString();
var compiledCode = solc.compile(code);

// sol파일의 abi 값입니다.
var abiDefinition = JSON.parse(compiledCode.contracts[':BVC'].interface);

// eth를 지불할 eth지갑을 선택합니다.
web3.eth.defaultAccount = web3.eth.accounts[0];

// sol파일의 컨트랙트 주소입니다.
var contractAddress = '0xd69f8e8523981441671cc93abc4ff596115aed7b';

// 컨트랙트를 연결합니다.
var contract = web3.eth.contract(abiDefinition);
var BVC = contract.at(contractAddress);

module.exports.example = function(req, res) { 
    console.log(" This is an example " + req); 
};








// 1. 투표장 등록하는 메소드입니다.
module.exports.setPollingPlace = function(result) { 
    BVC.setPollingPlace.sendTransaction(function(err, res){
    if(!err) {
      BVC.getPollingPlace.call(function(err, res){
        // 방금 생성한 투표장의 번호를 반환합니다.
        if(!err) {
            result(res.toLocaleString());
        } else {
            console.log(err);
        }
      })
    } else {
        console.log(err);
    }
  })
};

// 2. 후보자 등록하는 메소드입니다.
module.exports.setCandidate = function(placeid, json) { 
    // getCandidate로 등록한 후보자 ID 반환
     BVC.setCandidate.sendTransaction(placeid,function(err, res){
        if(!err) {
            BVC.getCandidate.call(function(err, res){
                // 방금 생성한 투표장의 번호를 반환합니다.
                if(!err) {
                    result(res.toLocaleString());
                } else {
                    console.log(err);
                }
            })
        } else {
            console.log(err);
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
            view.jsonParsing(400, err, "", json);
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
            view.jsonParsing(400, err, "", json);
        }
    })
};

// 4. 등록된 후보자보기
module.exports.getAllCandidate = function(placeid, json) { 
    console.log(" getAllCandidate example "); 
};

// 5. 투표하는 메소드입니다.
module.exports.setVote = function(placeid, candidateid, phone, json) { 
    BVC.setVote(placeid, candidateid, phone, function(err, res) {
        // 트랜젝션 주소가 err로 갈지 res로 갈지 체크해봐야함. 이 구문이 제대로 돌지 못할 수 있음을 유의하셈.
        if(!err) {
            console.log(res);
            view.jsonParsing(200, "success", "", json);
        } else {
            console.log(err);
            view.jsonParsing(400, err, "", json);
        }
    })
};

// 6. 개표합니다.
module.exports.getCounting = function(candidateid, res) { 
    console.log(" counting test "); 
};


// 7. 투표를 했는지 확인하는 메소드입니다.
module.exports.getCheckVoted = function(placeid, phone, json) { 
    BVC.getCheckVoted(phone, placeid, function(err, res) {
        if(!err) {
            console.log(res);
            view.jsonParsing(200, "success", "", json);
        } else {
            console.log(err);
            view.jsonParsing(400, err, "", json);
        }
    });
};

// 8. 투표를 시작합니다.
module.exports.setVoteStart = function(placeid, json) { 
    BVC.setVoteStart(placeid, function(err, res){
        if(!err) {
            view.jsonParsing(200, "success", "", json);
        } else {
            view.jsonParsing(400, err, "", json);
        }
    })
};

// 9. 투표를 종료합니다.
module.exports.setVoteEnd = function(placeid, json) { 
    BVC.setVoteEnd(placeid, function(err, res){
        if(!err) {
            view.jsonParsing(200, "success", "", json);
        } else {
            view.jsonParsing(400, err, "", json);
        }
    })
};


module.exports.searchList = function(length, res) { 
    var result = []

    Array.apply(null, Array(parseInt(length))).map(function (item, index) {
        result.push(closureAdd(0, index));
    })

    async.series(result, function(err, resEnd){
        view.jsonParsing(200, "success", resEnd, function(jsonData){
            res.json(jsonData)
        })
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
            console.log("test")
            break;
        default:
            console.log("why?")

    }
}













