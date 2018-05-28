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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getCurrentDate()
        getVotedNumber()
        getCheckVoted()
    }

    func getCurrentDate() {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale?
        currentDate.text = dateFormatter.string(from: now as Date)
    }
    
    func getVotedNumber() {
        let api = APIClient()
        api.setPollingPlace()
    }
    
    func getCheckVoted() {
        let api = APIClient()
        api.getCheckVoted()
    }
    
    
}
