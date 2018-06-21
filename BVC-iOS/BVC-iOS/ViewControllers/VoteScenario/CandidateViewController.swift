
import UIKit

private let candidateImage = "image"
private let candidateName = "candidateName"
private let partyName = "partyName"

private let reuseIdentifier = "CandidateViewCell"

class CandidateViewController: UIViewController {
    
    var candidateInfot: [CandidateInfo] = []
    var refresher:UIRefreshControl!
    
    fileprivate let cellAnumationDuration: Double = 0.25
    fileprivate let animationDelayStep: Double = 0.1
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.CStabBarViewColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    
    //MARK: - View & VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "후보자 명단"
        
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CandidateViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.white
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        prepareVisibleCellsForAnimation()
        loadAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateVisibleCells()
    }
    
    func loadAPI(){
        guard let selectedPlaceid = userInfo.selectPlaceid else {
            let alert = UIAlertController(title: nil, message: "잘못된 경로입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return;
        }
        
        let apiClient = APIClient()
        apiClient.getBookedCandidate(placeid: selectedPlaceid) { response in
            self.candidateInfot.removeAll()
            self.candidateInfot = response
            self.collectionView.reloadData()
        }
    }
    
    @objc func refresh(){
        loadAPI()
        self.refresher.endRefreshing()
    }
}

extension CandidateViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidateInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CandidateViewCell

        cell.configure(
            imageURL: candidateInfo[indexPath.row].imageURL,
            candidateName: candidateInfo[indexPath.row].name
            //partyName: candidateInfo[indexPath.row].candidateid
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.setSelectedIndex(value: indexPath.row)
        userInfo.selectCandidateid = String(candidateInfo[indexPath.row].candidateid)
        userInfo.name = candidateInfo[indexPath.row].name
        navigationController?.pushViewController(PromiseViewController(), animated: true)
    }
}

extension CandidateViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        return CGSize(width: view.bounds.width, height: layout.itemSize.height)
        return CGSize(width: view.bounds.width, height: view.bounds.height / 4)
    }
}

extension CandidateViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
    }
}

//MARK: - Cell's animation

private extension CandidateViewController {
    
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
