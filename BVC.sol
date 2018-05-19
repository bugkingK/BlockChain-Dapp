pragma solidity ^0.4.0;


contract BVC {

    struct Voter {
        uint phone;
        uint votedPlace;
    }

    struct Candidate {
        uint placeID
        uint voteCount; 
    }

    struct PollingPlace {
        bool voting;
    }

    Voter[] public voterList;
    Candidate[] public candidateList;
    PollingPlace[] public placeList;

    function setPollingPlace() returns(uint) {
        // 투표장 구조체 생성
        placeList.length += 1;
        uint placeID = placeList.length - 1;
        return placeID;
    }

    function setCandidate(uint _placeID) returns(uint) {
        // 후보자구조체 등록 
        candidateList.length += 1;
        uint candidateID = candidateList.length - 1;
        candidateList[candidateID].placeID = _placeID;
        return candidateID;
    }

    function getAllPlace() returns(string) {
        // 등록된 투표장 보기
        // return placeCode 필요
        string tmpPlace;
        for (uint i =0; i < pollingPlace.length; i++) {
            if (placeList[i].voting = true) {
                tmpPlace += (tostring(i) + ",");
            }
        }
        return tmpPlace;
    }

    function getCandidate(uint _placeID) returns(string) {
        // 등록된 후보 보기
        // return candidateCode 필요
        string tmpCandidate;
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i].placeID == _placeID) {
                tmpCandidate += (tostring(i) + ",");
            }
        }
        return tmpCandidate;        
    }

    function vote(uint _votedPlace, uint candidateCode, uint _phone) returns(bool) {
        // 투표하기 실패 성공 여부 확인해야할까?
        // 전화번호 중복여부
        if (checkVoted() == false) {
            voterList.length += 1;
            uint voterID = voterList.length - 1;
            voterList[voterID].phone = _phone;
            voterList[voterID].votedPlace = _votedPlace;
            return true;
        } else {
            return false;
        }

    }

    function checkVoted(uint _phone, uint _votedPlace) returns(bool) {
        for (uint i = 0; i < voterList.length; i++) {
            if (voterList[i].phone == _phone) {
                if (voterList[i].votedPlace == _votedPlace) {
                    return true;
                }
            }
        }

        return false;

    }

    function voteStart(uint _placeID) {
        placeList[_placeID].voting = 1;
    }

    function voteEnd(uint _placeID) {
        placeList[_placeID].voting = 0;
    }

    function counting(uint _candidateID) returns(uint) {
        // 개표하기
        return candidateList[_candidateID].voteCount;
    }
}

