
import UIKit

class HowToViewController: UIViewController {
    
    private let cellId = "HowTo"
    typealias Message = [String: String]
    fileprivate var messages: [Message] = []
    private var bottomBtn = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages = NSArray(contentsOfFile: Bundle.main.path(forResource: "HowToContents", ofType: "plist")!) as! [Message]
        
        setupViews()
    }
    
    deinit {
        print("HowToVC deinit")
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .red
        pc.pageIndicatorTintColor = .gray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("다음", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.tintColor = .white
        btn.backgroundColor = .CStabBarColor
        btn.layer.cornerRadius = 18
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return btn
    }()
    
    private let startBtn: UIButton = {
        // startBtn 초기화
        let btn = UIButton(type: .system)
        btn.setTitle("시작하기", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(.CStabBarColor, for: .normal)
        btn.addTarget(self, action: #selector(handleMain), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc private func handleNext(){
        let nextIndex = min(pageControl.currentPage + 1, messages.count - 1)
        
        if pageControl.currentPage + 1 >= messages.count - 1 {
            bottomBtn[0].constant = 40
            startBtn.isHidden = false
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            startBtn.isHidden = true
        }
        
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleMain(){
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews(){
        // View 초기화
        //        view.backgroundColor = UIColor(red: 94.0/255.0, green: 91.0/255.0, blue: 149.0/255.0, alpha: 1)
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HowToCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        view.addSubview(startBtn)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomBtn.append(nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20))
        bottomBtn.append(nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80))
        bottomBtn.append(nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80))
        bottomBtn.append(nextButton.heightAnchor.constraint(equalToConstant: 40))
        bottomBtn.forEach({ $0.isActive = true })
        
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pageControl.numberOfPages = messages.count
        
        startBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        startBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        startBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        startBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startBtn.isHidden = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        //x / view.frame.width 값이 페이지 번호가 됨
        pageControl.currentPage = pageNumber
        
        if pageNumber >= messages.count - 1 {
            bottomBtn[0].constant = 40
            startBtn.isHidden = false
        } else {
            bottomBtn[0].constant = -20
            startBtn.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension HowToViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HowToCollectionViewCell
        
        let message = messages[(indexPath as NSIndexPath).row]
        
        cell.configure(image: UIImage(named: message["image"]!)!, title: message["title"]!, contents: message["contents"]!)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
