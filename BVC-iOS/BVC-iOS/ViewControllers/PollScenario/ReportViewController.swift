//
//  ReportViewController.swift
//  Example-Swift
//
//  Created by kimun on 2018. 4. 29..
//  Copyright © 2018년 Yalantis. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "ReportViewCell"

class ReportViewController: UIViewController {
    
    var countingInfo: [CountingInfo] = []
    
    fileprivate let cellAnumationDuration: Double = 0.25
    fileprivate let animationDelayStep: Double = 0.1
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.CStabBarViewColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "투표 결과"
        
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ReportViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareVisibleCellsForAnimation()
        
        getCounting(placeid: UserDefaults.standard.getselectedPlaceId())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateVisibleCells()
    }
    
    //// 개표하기 APIClient - getCounting을 불러옵니다.
    func getCounting(placeid: String) {
        let api = APIClient()
        api.getCounting(placeid: placeid) { response in
            self.countingInfo.removeAll()
            self.countingInfo = response
            self.collectionView.reloadData()
        }
    }
}

extension ReportViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countingInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReportViewCell
        
        cell.configure(
            imageURL: countingInfo[indexPath.row].imageURL,
            candidateName: countingInfo[indexPath.row].name,
            voteCount: countingInfo[indexPath.row].voteCount)
        
        return cell
    }
}

extension ReportViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        //        return CGSize(width: view.bounds.width, height: layout.itemSize.height)
        return CGSize(width: view.bounds.width, height: view.bounds.height / 4)
    }
}

extension ReportViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
}

//MARK: - Cell's animation

private extension ReportViewController {
    
    func prepareVisibleCellsForAnimation() {
        collectionView.visibleCells.forEach {
            $0.frame = CGRect(
                x: -$0.bounds.width,
                y: $0.frame.origin.y,
                width: $0.bounds.width,
                height: $0.bounds.height
            )
            $0.alpha = 0
        }
    }
    
    func animateVisibleCells() {
        collectionView.visibleCells.enumerated().forEach { offset, cell in
            cell.alpha = 1
            UIView.animate(
                withDuration: self.cellAnumationDuration,
                delay: Double(offset) * self.animationDelayStep,
                options: .curveEaseOut,
                animations: {
                    cell.frame = CGRect(
                        x: 0,
                        y: cell.frame.origin.y,
                        width: cell.bounds.width,
                        height: cell.bounds.height
                    )
            })
        }
    }
    //options: .curveEaseOut,
}
