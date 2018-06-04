
import UIKit

private let statusImage = "image"
private let statusTitle = "title"
private let statusDate = "date"
class VoteListViewController: UIViewController{
    
    private let cellId = "VoteListViewCell"
    typealias Message = [String: String]
    fileprivate var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages = NSArray(contentsOfFile: Bundle.main.path(forResource: "StatusDataList", ofType: "plist")!) as! [Message]
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        
    }
}

extension VoteListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VoteListViewCell
        let message = messages[(indexPath as NSIndexPath).row]
        cell.configure(
            image: UIImage(named: message[statusImage]!)!,
            title: message[statusTitle]!,
            contents: message[statusDate]!
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let whyVC = WhyViewController()
            self.present(whyVC, animated: true, completion: nil)
        }
        
        navigationController?.pushViewController(CandidateViewController(), animated: true)
    }
    
}

