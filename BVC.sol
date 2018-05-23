pragma solidity ^0.4.0;


library Strings {

    function concat(string _base, string _value) internal returns (string) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for (i = 0; i < _baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for (i = 0; i < _valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i++];
        }

        return string(_newValue);
    }

}


contract BVC {

    using Strings for string;

    struct Voter {
        uint phone;
        uint votedPlace;
    }

    struct Candidate {
        uint placeID;
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
        for (uint i =0; i < placeList.length; i++) {
            if (placeList[i].voting = true) {
                tmpPlace.concat(uintToString(i));
                tmpPlace.concat("/");
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
                tmpCandidate.concat(uintToString(i));
                tmpCandidate.concat("/");
                
            }
        }
        return tmpCandidate;        
    }

    function vote(uint _votedPlace, uint _candidateID, uint _phone) returns(bool) {
        // 투표하기 실패 성공 여부 확인해야할까?
        // 전화번호 중복여부
        if (checkVoted(_phone, _votedPlace) == false) {
            voterList.length += 1;
            uint voterID = voterList.length - 1;
            voterList[voterID].phone = _phone;
            voterList[voterID].votedPlace = _votedPlace;
            candidateList[_candidateID].voteCount += 1;
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
        placeList[_placeID].voting = true;
    }

    function voteEnd(uint _placeID) {
        placeList[_placeID].voting = false;
    }

    function counting(uint _candidateID) returns(uint) {
        // 개표하기
        return candidateList[_candidateID].voteCount;
    }
       
        //uintToString 함수
    function uintToString(uint v) constant returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }
        str = string(s);
    }
}

