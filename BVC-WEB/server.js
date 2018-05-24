
// 필요한 npm 설치
var Web3 = require('web3');
var express = require('express');

// web3와 express 변수를 선언합니다.
var app = express();
var web3 = new Web3();

// web3의 위치를 지정하는 함수입니다. web3의 위치는 bug.lasel.kr:8545에 있습니다.
web3.setProvider(new web3.providers.HttpProvider('http://bug.lasel.kr:8545'));

// sol파일의 컨트랙트 주소입니다.
var contractAddress = '0x13d45b0f37d96d12cf230714bdf764a987c63466';
// sol파일의 abi 값입니다.
var interface = [{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"getCandidate","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"getAllPlace","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"voterList","outputs":[{"name":"phone","type":"uint256"},{"name":"votedPlace","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_phone","type":"uint256"},{"name":"_votedPlace","type":"uint256"}],"name":"checkVoted","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_votedPlace","type":"uint256"},{"name":"_candidateID","type":"uint256"},{"name":"_phone","type":"uint256"}],"name":"vote","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getPollingPlace","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"setPollingPlace","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"candidateList","outputs":[{"name":"placeID","type":"uint256"},{"name":"voteCount","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"voteEnd","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"placeList","outputs":[{"name":"voting","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"setCandidate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_placeID","type":"uint256"}],"name":"voteStart","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"v","type":"uint256"}],"name":"uintToString","outputs":[{"name":"str","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_candidateID","type":"uint256"}],"name":"counting","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"}]
// 컨트랙트를 연결합니다.
var contract = web3.eth.contract(interface);
var BVC = contract.at(contractAddress);
// eth를 지불할 eth지갑을 선택합니다.
web3.eth.defaultAccount = web3.eth.accounts[0];
// ------------------------- 기본세팅 변경될 사항은 web3주소와 컨트랙트 주소, abi만 가변성이 있습니다. -----------------------------------

app.get('/', function (req, res) {
  
  setPollingPlace(function(jsonData){
    res.json(jsonData);
  });
});

// 투표장을 생성하는 메소드입니다.
function setPollingPlace(json){
  BVC.setPollingPlace.sendTransaction(function(err, res){
    if(!err) {
      
      BVC.getPollingPlace.call(function(err, res){
        if(!err) {
          console.log(res);
          var jsonString = {
            "result" : "",
            "placeid" : ""
          }
          jsonString["result"] = "success";
          jsonString["placeid"] = res;
          json(jsonString);
        } else {
          console.log(err);
        }
      })

    } else {
      console.log(err);
      
    }
  })
}



app.listen(4210, function () {
  console.log('eth server start: 4210');
});

