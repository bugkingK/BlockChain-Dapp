//
//  ReportViewController.swift
//  Example-Swift
//
//  Created by kimun on 2018. 4. 29..
//  Copyright © 2018년 Yalantis. All rights reserved.
//

import UIKit
import Alamofire

class ReportViewController: UIViewController {

    @IBOutlet weak var votedNumber: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    
    var placeid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        getCounting(placeid: UserDefaults.standard.getselectedPlaceId())
    }

    func getCurrentDate() {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale?
        currentDate.text = dateFormatter.string(from: now as Date)
    }
    
    //// 개표하기 APIClient - getCounting을 불러옵니다.
    
    func getCounting(placeid: String) {
        let api = APIClient()
        api.getCounting(placeid: placeid)
    }
}
