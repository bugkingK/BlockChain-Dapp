// 앱과 연동하는 라우터입니다.
// output으로 json이 출력되어야 합니다.

var express = require('express');
var router = express.Router();
var path = process.cwd();
var blockFunc = require( path + '/model/blockFunc' );
var view = require( path + '/view/json' );

// 3. 등록된 투표장을 볼 수 있습니다.
router.get('/getAllplace', function(req, res){
	blockFunc.placeLength(function(length){
        blockFunc.searchList(0, true, length, res)
    })
});

// 4. 입력한 투표장의 모든 후보자를 볼 수 있습니다.
router.get('/getAllCandidate', function(req, res){
    var placeid = req.param('placeid');

	blockFunc.candidateLength(function(length){
        blockFunc.searchList(1, true, length, res);
    })		
});

// 5. 투표권을 행사합니다.
// json 성공실패여부
router.get('/setVote', function(req, res){
    var placeid = req.param('placeid');
    var candidateid = req.param('candidateid');
    var phone = req.param('phone');

    blockFunc.getCheckVoted(placeid, phone, function(err, res){
        if(!err){
            blockFunc.setVote(placeid, candidateid, phone, function(_err, _res) {
                if(!err) {
                    // json으로 변경해야해
                    res.send(_res)
                } else {
                    // json으로 변경해야해
                    res.send(_err)
                }
            });
        } else {
            view.jsonParsing(401, "이미 투표권을 행사하셨습니다.", "", function(jsonData){
                res.json(jsonData)
            })
        }
    })
});

// 6. 개표합니다.
router.get('/getCounting', function(req, res){
    var placeid = req.param('placeid');

	blockFunc.getCounting('testestestes');
});

module.exports = router;