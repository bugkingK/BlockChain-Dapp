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
* 알림창을 띄우는 부분은 appdelegate에 띄워 다른 뷰에 가리지 않도록 구성했습니다.

## :bulb: 인트로 및 투표결과보기
#### 인트로 로직
* 앱을 처음 설치하고 실행시켰을 때 자동으로 실행되는 항목입니다. UserDefault를 사용하여 처음 시작을 체크합니다. 
* [HowToViewController](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/ViewControllers/INTRO/HowToViewController.swift)와 [CollectionViewCell](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/View/HowToCollectionViewCell.swift)을 사용합니다.
* 사용법에 관한 내용은 고정된 내용을 표출하고 수정을 쉽게하기 위해 [.plist](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/HowToContents.plist)에 값을 저장해두었습니다.

#### 투표결과보기 로직
~~~swift
//선거가 종료된 선거장
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

                    let imageURL = "http://yangarch.iptime.org/bvc/uploads/place/\(placeid).png"

                    let period = Period(start_regist_period: start_regist_period, end_regist_period: end_regist_period, votedate: votedate, start_vote_time: start_vote_time, end_vote_time: end_vote_time)
                    let placeinfo = PlaceInfo(placeid: placeid, name: name, period: period, contents: contents, isStarted: isStarted, imageURL: imageURL)
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
~~~
* 선거가 종료된 정보를 서버로부터 가져옵니다. 해당 정보는 [이더리움 블록체인](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-WEB/BVC.sol)에 담겨있는 정보를 담고 있습니다.
* 전달받은 데이터는 [Data.class](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/Model/Data.swift)의 endedPlaceinfo 모델에 담긱 됩니다.
* 비동기가 완료되고 @escaping 시켜 정보를 [VoteStatusViewController](https://github.com/bugkingK/BlockChain-Dapp/blob/master/BVC-iOS/BVC-iOS/ViewControllers/PollScenario/VoteStatusViewController.swift)에게 전달하고 해당 컨트롤러는 화면에 표출합니다.

## :bulb: 인증과 선거장보기

## :bulb: 후보자와 선거공약보기

## :bulb: 1인 1회 투표하기

## :bulb: 투표결과 확인하기
