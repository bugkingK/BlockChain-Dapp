// 공통으로 사용되는 함수들입니다.
var path = process.cwd();
var dbFunc = require( path + '/model/dbFunc' );

module.exports.handlingClosureAdd = function(selector, placeid, item, candidateid, counting) {
    switch(selector) {
        case 0:
            return function(callback){
                dbFunc.searchPlaceInfo(placeid, function(err, result){
                    callback(null, result)
                })
            }
            break;
        case 1:
            return function(callback){
                callback(null, item)
            }
            break;
        case 2:
            return function(callback){
                dbFunc.searchCandidateInfo(placeid, candidateid, function(err, result){
                    callback(null, result)
                })
            }
        case 3:
            return function(callback){
                dbFunc.updateCounting(placeid, candidateid, counting, function(err, result){
                    callback(null, result)
                })
            }
        default:
            console.log("why?")
    }
};