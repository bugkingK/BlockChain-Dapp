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
    case server             = "http://yangarch.iptime.org:4210/"
    case getAllplace        = "getAllplace"
    case getAllCandidate    = "getAllCandidate"
    case setVote            = "setVote"
    case getCounting        = "getCounting"
    case setPollingPlace    = "setPollingPlace"
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
    
    //등록된 투표장보기
    func getAllplace() {
        let network = Network(siteURL.getAllplace.rawValue, method: .get)
        network.connetion(){ response in
            print(response)
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [String: String] {
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
    
    // 등록된 후보자 보기
    func getAllCandidate(placeid: String) {
        let parameters: Parameters = ["placeid" : placeid]
        
        let network = Network(siteURL.getAllCandidate.rawValue, method: .get, parameters : parameters)
        network.connetion(){ response in
            print(response)
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [String: String] {
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
   
    // 투표하기
    func setVote(placeid: String, candidateid: String, phone: String) {
        let parameters: Parameters = ["placeid" : placeid, "candidateid" : candidateid, "phone" : phone]
        
        let network = Network(siteURL.setVote.rawValue, method: .get, parameters : parameters)
        network.connetion(){ response in
            print(response)
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [String: String] {
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
    
    // 투표 결과 가져오기
    func getCounting(placeid: String) {
        
    }
    
    func setPollingPlace() {
        let network = Network(siteURL.setPollingPlace.rawValue, method: .get)
        network.connetion(){ response in
            print(response)
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String {
                switch resultCode {
                case 200:
                    
                    break
                default:
                    self.appDelegate.showAlert(resultMessage)
                    break
                }
            }
            self.appDelegate.showAlert("오류가 발생하였습니다. 재 접속해주세요")
        }
    }
    
    
}

