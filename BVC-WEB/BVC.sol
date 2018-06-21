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
        uint extensionPlaceID = placeList.length - 1;
        placeList[extensionPlaceID].placeID = extensionPlaceID;
        placeList[extensionPlaceID].isStarted = false;
    }

    function getPollingPlace() constant returns(uint, bool){ // return으로 uint 형식의 방금 만든 투표장 번호를 줌
        return (placeList[placeList.length - 1].placeID, placeList[placeList.length -1].isStarted);
    }
    //-- 투표장 구조체 생성

    //-- 후보자 구조체 생성 set과 get을 연달아 사용해서 후보자를 등록하고 후보자 ID를 반환받음.
    function setCandidate(uint _placeID) {
        candidateList.length += 1;
        uint extensionCandidateID = candidateList.length - 1;
        candidateList[extensionCandidateID].candidateID = extensionCandidateID;
        candidateList[extensionCandidateID].placeID = _placeID;
        candidateList[extensionCandidateID].voteCount = 0;
    }

    function getCandidate() constant returns(uint) { //return으로 후보자 ID
        return candidateList[candidateList.length - 1].candidateID;
    }
    //-- 후보자 구조체 생성

    //-- 요청한 투표장이 현재 투표가 진행중인 투표장인지 확인함. 두 함수를 연달아 사용해서 해당 함수가 투표가 진행중인지 알수 있음.
    function getPlaceLength() constant returns(uint){
        return placeList.length;
    }

    function getPlaceId(uint index) constant returns(uint, bool){
        return (placeList[index].placeID, placeList[index].isStarted);
    }
    //-- 투표장이 투표가 진행중인지 확인

    //-- 해당 후보자가 해당 투표장에 등록된 후보자가 맞는지 검출. 연달아 사용해서 해당 후보자가 해당 투표장에 존재하면 true를 리턴
    function getCandidateId(uint index) constant returns(uint, uint) {
        return (candidateList[index].placeID, candidateList[index].candidateID);
    }

    function getCandidateLength() constant returns (uint){
        return candidateList.length;
    }
    //-- 해당 후보자가 해당 투표장에 등록된 후보자가 맞는지 검출

    // 투표를 진행. getCheckVoted에서 true를 반환받았을 때에만 실행할 수 있어야 함.
    function setVote(uint _placeID, uint _candidateID, uint _phone) {
         voterList.length += 1;
         uint index = voterList.length - 1;
         voterList[index].phone = _phone;
         voterList[index].votedPlace = _placeID;
        for (uint i = 0; i < candidateList.length; i++) {
            if(candidateList[i].candidateID == _candidateID) {
                candidateList[i].voteCount += 1;
                break;
            }
        }
    }

    // 전화번호가 중복인지 체크하는 함수           phone number check
    function getCheckVoted(uint _placeID, string _phone) constant returns(bool) {
        for (uint i = 0; i < voterList.length; i++) {
            if (keccak256(voterList[i].phone) == keccak256(_phone) && voterList[i].votedPlace == _placeID) {
                return (true);
            }
        }
        return (false);
    }

    // 투표를 시작하도록 하는 함수
    function setVoteStart(uint _placeID) {
        setStarted(_placeID, true);
    }
    // 투표를 중지하는 함수
    function setVoteEnd(uint _placeID) {
        setStarted(_placeID, false);
    }

    function setStarted(uint _placeID, bool started) {
        for (uint i = 0; i < placeList.length; i++) {
            if(placeList[i].placeID == _placeID) {
                placeList[_placeID].isStarted = started;
            }
        }
    }

    // 해당 후보자의 득표수를 리턴하는 get 함수
    function getCounting(uint _placeID, uint _index) constant returns(uint, uint, uint) {
        for (uint i = 0; i < placeList.length; i++) {
            if(candidateList[i].placeID == _placeID) {
                return (candidateList[_index].placeID, candidateList[_index].candidateID, candidateList[_index].voteCount);
            }
        }
    }
}
