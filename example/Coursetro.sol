pragma solidity ^0.4.18;


contract Coursetro {

    string fName;
    uint age;

    // 이벤트 확인
    event Instructor(
        string name,
        uint age
    );

    // set, 이름과 나이 지정하기.
    function setInstructor(string _fName, uint _age) public {
        fName = _fName;
        age = _age;
        Instructor(_fName, _age);
    }

    // get, 이름과 나이 가져오기.
    function getInstructor() public constant returns (string, uint) {
        return (fName, age);
    }
}
