# iOS

## :memo: Table of Contents
* [네트워크통신의 공통로직](#bulb-네트워크통신의-공통로직)
* [인트로 및 투표결과보기](#bulb-인트로-및-투표결과보기)
* [인증과 선거장보기](#bulb-인증과-선거장보기)
* [후보자와 선거공약보기](#bulb-후보자와-선거공약보기)
* [1인 1회 투표하기](#bulb-1인-1회-투표하기)
* [투표결과 확인하기](#bulb-투표결과-확인하기)


## :bulb: 네트워크통신의 공통로직
#### 공통로직
~~~swift
private enum siteURL: String {
    case server             = "server address"
    case getStartedPlace    = "url"
    case getEndedPlace      = "url"
    case getBookedCandidate = "url"
    case setVote            = "url"
    case getCounting        = "url"
    case isAuth             = "url"
    case isAction           = "url"
    case setAuth            = "url"
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
~~~
* 서버와 통신하는 부분 중 공통적으로 사용되는 로직을 분리하여 관리합니다. [Network.class](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/Model/Network.swift)
* URL정보는 변경하기 쉽도록 enum을 사용하여 관리합니다.

## :bulb: 인트로 및 투표결과보기
#### 인트로 로직
* 앱을 처음 설치하고 실행시켰을 때 자동으로 실행되는 항목입니다. UserDefault를 사용하여 처음 시작을 체크합니다. 
* [HowToViewController](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/ViewControllers/INTRO/HowToViewController.swift)와 [CollectionViewCell](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/View/HowToCollectionViewCell.swift)을 사용합니다.
* 사용법에 관한 내용은 고정된 내용을 표출하고 수정을 쉽게하기 위해 [.plist](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/HowToContents.plist)에 값을 저장해두었습니다.

#### 투표결과보기 로직




## :bulb: 인증과 선거장보기

## :bulb: 후보자와 선거공약보기

## :bulb: 1인 1회 투표하기

## :bulb: 투표결과 확인하기
