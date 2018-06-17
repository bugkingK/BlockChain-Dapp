//
//  Network.swift
//  BVC
//
//  Created by kimun on 2018. 5. 27..
//  Copyright © 2018년 Yalantis. All rights reserved.
//


import UIKit
import Alamofire

private enum siteURL: String {
    case server             = "http://yangarch.iptime.org:4210/app/"
    case getStartedPlace    = "getStartedPlace"
    case getEndedPlace      = "getEndedPlace"
    case getBookedCandidate = "getBookedCandidate"
    case setVote            = "setVote"
    case getCounting        = "getCounting"
}

class Network{
    let url: URL
    let method: HTTPMethod
    let parameters: Parameters
    
    init(_ path: String, method: HTTPMethod = .post, parameters: Parameters = [:]) {
        if let url = URL(string: siteURL.server.rawValue + path) {
            self.url = url
        } else {
            self.url = URL(string: siteURL.server.rawValue)!
        }
        
        self.method = method
        self.parameters = parameters
    }
    
    deinit {
        print("network deinit")
    }
    
    func connetion(completion: @escaping ( [String: AnyObject] ) -> Void) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.isshowActivityIndicatory()
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if let JSON = response.result.value{
                completion(JSON as! [String : AnyObject])
            } else{
                appdelegate.showAlert("서버와의 연결이 불안정합니다.")
            }
            appdelegate.invisibleActivityIndicatory()
        }
    }
}

class APIClient {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //선거가 시작 중인 선거장
    func getStartedPlace(completion: @escaping ( [PlaceInfo] ) -> Void) {
        let network = Network(siteURL.getStartedPlace.rawValue, method: .get)
        network.connetion(){ response in
            
            guard let resultCode = response["code"] as? Int,
                  let resultMessage = response["message"] as? String else {
                    self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
                    return
            }
            
            var startedPlaceinfo: [PlaceInfo] = []
            
            if let data = response["data"] {
                for index in data as! [[[String: AnyObject]]] {
                    for _index in index {
                        guard let placeid = _index["placeid"] as? Int,
                              let name = _index["name"] as? String,
                              let start_regist_period = _index["start_regist_period"] as? String,
                              let end_regist_period = _index["end_regist_period"] as? String,
                              let votedate = _index["votedate"] as? String,
                              let start_vote_time = _index["start_vote_time"] as? String,
                              let end_vote_time = _index["end_vote_time"] as? String,
                              let contents = _index["contents"] as? String,
                              let isStarted = _index["isStarted"] as? Int else {
                                self.appDelegate.showAlert("선거장 정보를 가져오지 못했습니다. 재 접속해주세요.")
                                return
                        }
                        let period = Period(start_regist_period: start_regist_period, end_regist_period: end_regist_period, votedate: votedate, start_vote_time: start_vote_time, end_vote_time: end_vote_time)
                        let placeinfo = PlaceInfo(placeid: placeid, name: name, period: period, contents: contents, isStarted: isStarted)
                        startedPlaceinfo.append(placeinfo)
                    }
                }
            }
            
            switch resultCode {
            case 200:
                completion(startedPlaceinfo)
                break
            default:
                self.appDelegate.showAlert(resultMessage)
                break
            }
        }
    }
    
    //선거가 시작 중인 선거장
    func getEndedPlace(completion: @escaping ( [PlaceInfo] ) -> Void) {
        let network = Network(siteURL.getEndedPlace.rawValue, method: .get)
        network.connetion(){ response in
            
            guard let resultCode = response["code"] as? Int,
                let resultMessage = response["message"] as? String else {
                    self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
                    return
            }
            
            var endedPlaceinfo: [PlaceInfo] = []
            
            if let data = response["data"] {
                for index in data as! [[[String: AnyObject]]] {
                    for _index in index {
                        guard let placeid = _index["placeid"] as? Int,
                            let name = _index["name"] as? String,
                            let start_regist_period = _index["start_regist_period"] as? String,
                            let end_regist_period = _index["end_regist_period"] as? String,
                            let votedate = _index["votedate"] as? String,
                            let start_vote_time = _index["start_vote_time"] as? String,
                            let end_vote_time = _index["end_vote_time"] as? String,
                            let contents = _index["contents"] as? String,
                            let isStarted = _index["isStarted"] as? Int else {
                                self.appDelegate.showAlert("선거장 정보를 가져오지 못했습니다. 재 접속해주세요.")
                                return
                        }
                        let period = Period(start_regist_period: start_regist_period, end_regist_period: end_regist_period, votedate: votedate, start_vote_time: start_vote_time, end_vote_time: end_vote_time)
                        let placeinfo = PlaceInfo(placeid: placeid, name: name, period: period, contents: contents, isStarted: isStarted)
                        endedPlaceinfo.append(placeinfo)
                    }
                }
            }
            
            switch resultCode {
            case 200:
                completion(endedPlaceinfo)
                break
            default:
                self.appDelegate.showAlert(resultMessage)
                break
            }
        }
    }
    
    // placeid에 해당하는 후보자 리스트
    func getBookedCandidate(placeid: String, completion: @escaping ( [CandidateInfo] ) -> Void) {
        let parameters: Parameters = ["placeid" : placeid]
        
        let network = Network(siteURL.getBookedCandidate.rawValue, method: .get, parameters : parameters)
        network.connetion(){ response in
            
            guard let resultCode = response["code"] as? Int,
                let resultMessage = response["message"] as? String else {
                    self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
                    return
            }
            
            var candidateInfo: [CandidateInfo] = []
            
            if let data = response["data"] {
                for index in data as! [[[String: AnyObject]]] {
                    for _index in index {
                        guard
                              let candidateid = _index["candidateid"] as? String,
                              let name = _index["name"] as? String,
                              let wantvote = _index["wantvote"] as? String else {
                                self.appDelegate.showAlert("후보자 정보를 가져오지 못했습니다. 재 접속해주세요.")
                                return
                        }
                        let candidateinfo = CandidateInfo(candidateid: candidateid, name: name, wantvote: wantvote)
                        candidateInfo.append(candidateinfo)
                        
                    }
                }
            }
            
            switch resultCode {
            case 200:
                completion(candidateInfo)
                break
            default:
                self.appDelegate.showAlert(resultMessage)
                break
            }
        }
    }
   
    // 투표하기
    func setVote(placeid: String, candidateid: String, phone: String) {
        let parameters: Parameters = ["placeid" : placeid, "candidateid" : candidateid, "phone" : phone]
        
        let network = Network(siteURL.setVote.rawValue, method: .get, parameters : parameters)
        network.connetion(){ response in
            print(response)
            
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String {
                switch resultCode {
                case 200:
                    self.appDelegate.showAlert(resultMessage)
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            } else {
                self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
            }
        }
    }
    
    // 투표 결과 가져오기
    func getCounting(placeid: String) {
        let parameters: Parameters = ["placeid" : placeid]
        
        let network = Network(siteURL.getCounting.rawValue, method: .get, parameters : parameters)
        network.connetion(){ response in
            print(response)
            
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [[String: String]] {
                switch resultCode {
                case 200:
                    print(resultData)
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            } else {
                self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
            }
        }
    }
}

