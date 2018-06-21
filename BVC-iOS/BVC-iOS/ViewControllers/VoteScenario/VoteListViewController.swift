
import UIKit
import Alamofire

private let statusImage = "image"
private let statusTitle = "title"
private let statusDate = "date"
class VoteListViewController: UIViewController{
    
    var startedPlaceinfo: [PlaceInfo] = []
    var refresher:UIRefreshControl!
    private let cellId = "VoteListViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        
        if UserDefaults.standard.getisAutu() == false {
            let alert = UIAlertController(title: "인증이 필요합니다.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
                self.tabBarController?.selectedIndex = 3
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
        loadAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    deinit {
        print("VoteListViewController deinit" )
    }
    
    let collectionView: UICollectionView = {
        let layout = VoteListLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .CStabBarViewColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private func setupViews() {
        collectionView.register(VoteListViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.refresher = UIRefreshControl()
        self.collectionView.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.white
        self.refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.addSubview(refresher)
    }
    
    func loadAPI(){
        let apiClient = APIClient()
        apiClient.getStartedPlace() { response in
            self.startedPlaceinfo.removeAll()
            self.startedPlaceinfo = response
            self.collectionView.reloadData()
        }
    }
    
    @objc func refresh(){
        loadAPI()
        self.refresher.endRefreshing()
    }
}

extension VoteListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return startedPlaceinfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VoteListViewCell
        
        cell.configure(
            imageURL: startedPlaceinfo[indexPath.row].imageURL,
            title: startedPlaceinfo[indexPath.row].name,
            contents: startedPlaceinfo[indexPath.row].contents
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        userInfo.selectPlaceid = String(startedPlaceinfo[indexPath.row].placeid)
        
        navigationController?.pushViewController(CandidateViewController(), animated: true)
    }
    
}

