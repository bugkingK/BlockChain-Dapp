pragma solidity ^0.4.0;


contract BVC {


    struct Voter {
        uint phone;
        uint votedPlace;
    }

    struct Candidate {
        uint candidateID;
        uint placeID;
        uint voteCount;
    }

    struct PollingPlace {
        uint placeID;
        bool isStarted;
    }

    Voter[] public voterList;
    Candidate[] public candidateList;
    PollingPlace[] public placeList;

//-- 투표장 구조체 생성. set 함수와 get 함수를 연달아 사용해야 투표장을 하나 생성하고 해당 투표장의 ID를 가져올 수 있음.
    function setPollingPlace() {
        placeList.length += 1;
        uint placeID = placeList.length - 1;
        placeList[placeID].isStarted = false;

    }
    function getPollingPlace() constant returns(uint){ // return으로 uint 형식의 방금 만든 투표장 번호를 줌
      return placeList.length - 1;
    }
//-- 투표장 구조체 생성

//-- 후보자 구조체 생성 set과 get을 연달아 사용해서 후보자를 등록하고 후보자 ID를 반환받음.
    function setCandidate(uint _placeID) {
        candidateList.length += 1;
        uint candidateID = candidateList.length - 1;
        candidateList[candidateID].placeID = _placeID;
    }
    function getCandidate() constant returns(uint) { //return으로 후보자 ID
      return candidateList.length - 1;
    }
//-- 후보자 구조체 생성

//-- 요청한 투표장이 현재 투표가 진행중인 투표장인지 확인함. 두 함수를 연달아 사용해서 해당 함수가 투표가 진행중인지 알수 있음.
    function setIsPlace(uint _placeID) constant returns(bool){
      returns(placeList[_placdID].isStarted);
    }
    function getIsPlace() constant returns(bool){
      return placeIsVoting;
    }
//-- 투표장이 투표가 진행중인지 확인

//-- 해당 후보자가 해당 투표장에 등록된 후보자가 맞는지 검출. 연달아 사용해서 해당 후보자가 해당 투표장에 존재하면 true를 리턴
    function setIsCandidate (uint _placeID, uint _candidateID) returns(bool) {
        // 등록된 후보 보기
        if(candidateList[_candidateID].placeID == _placeID){
          isCandidate = true;
        }
        else{
          isCandidate = false;
        }
    }

    function getIsCandidate() constant returns(bool) {
      return isCandidate;
    }
//-- 해당 후보자가 해당 투표장에 등록된 후보자가 맞는지 검출

//js에서 반복문 사용을 위해 배열 길이를 알아내는 함수
    function getPlaceLength() constant returns(uint){
      return placeList.length;
    }

    function getCandidateLength() constant returns (uint){
      return candidateList.length;
    }


    // set 함수지만 return이 bool 이고
    function setVote(uint _placeID, uint _candidateID, uint _phone) {
      // 투표를 진행. getCheckVoted에서 true를 반환받았을 때에만 실행할 수 있어야 함.
      voterList.length += 1;
      uint voterID = voterList.length - 1;
      voterList[voterID].phone = _phone;
      voterList[voterID].votedPlace = _placeID;
      candidateList[_candidateID].voteCount += 1;

    }
    // 전화번호가 중복인지 체크하는 함수
    function getCheckVoted(uint _placeID, uint _phone) constant returns(bool) {
        for (uint i = 0; i < voterList.length; i++) {
            if (voterList[i].phone == _phone) {
                if (voterList[i].votedPlace == _placeID) {
                    return true;
                }
            }
        }
        return false;
    }

// 투표를 시작하도록 하는 함수
    function setVoteStart(uint _placeID) {
        placeList[_placeID].isStarted = true;
    }
// 투표를 중지하는 함수
    function setVoteEnd(uint _placeID) {
        placeList[_placeID].isStarted = false;
    }
// 해당 후보자의 득표수를 리턴하는 get 함수
    function getCounting(uint _candidateID) constant returns(uint, bool) {
        // 개표하기
        return candidateList[_candidateID].voteCount;
    }

}
