function OpenPollingPlace{
    var RegisterPeriod = "":
    var VotePeriod = "":
    var PlaceName = "":
    var PlaceId = "":
    var candidateArr = new List();
}

function setPollingPlaceOpen(){
    var id= "";
    BVC.setPollingPlace(function(e,r){
        id=r.toNumber();
        OpentPollingPlace[id].PlaceId=id;
    })
    BVC.voteStart(OpentPollingPlace[id].PlaceId);
}

function Candidate {
    var CandidateName = "";
    var CandidateCareer = "";
    var CandidateHometown = "";
    var CandidateEmail = "";
    var CandidatePhone = "";
    var CandidateId = "";
    var CandidateResult = "";

}

function setRegisterCandidate(){
    var CandidateCode = "";
    BVX.setCandidate(OpentPollingPlace[id].PlaceId, function(e,r){
        CandidateCode=r.toNumber();
        OpentPollingPlace[id].candidateArr.append(CandidateCode);
        Candidate[CandidateCode].CandidateId=CandidateCode;
    } )
}

function ClosePollingPlace{
    var i = "";
    for(i=0; i<OpentPollingPlace[id].candidateArr.length(); i++){
        BVC.counting(OpentPollingPlace[id].candidateArr.get(i), function(e,r){
            Candidate[OpentPollingPlace[id].candidateArr.get(i)].CandidateResult=r.toNumber();
        })
}
BVC.voteEnd(OpentPollingPlace[id].PlaceId);
}