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
    
    func setPollingPlace() {
        let network = Network(siteURL.setPollingPlace.rawValue, method: .get)
        network.connetion(){ response in
            print(response)
            if let resultCode = response["code"] as? Int, let resultMessage = response["message"] as? String, let resultData = response["data"] as? [String: String] {
                switch resultCode {
                case 200:
                    print(resultData)
//                    for index in resultData {
//                        if let placeid = index["placeid"] {
//                            self.appDelegate.showAlert(String(placeid))
//                        }
//                    }
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

