
import UIKit

private let listTitle = "title"
private let listDate = "date"

private let reuseIdentifier = "VoteStatusViewCell"

class VoteStatusViewController: UIViewController {
  
  typealias Message = [String: String]
  
  fileprivate var messages: [Message] = []
  fileprivate let cellAnumationDuration: Double = 0.25
  fileprivate let animationDelayStep: Double = 0.1
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  //MARK: - View & VC life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    messages = NSArray(contentsOfFile: Bundle.main.path(forResource: "StatusDataList", ofType: "plist")!) as! [Message]
    
    // 앱 처음 설치 후 한 번만 실행됩니다.
    if !UserDefaults.standard.isFirstExcuteIn() {
        UserDefaults.standard.setisFirstExcuteIn(value: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.showHowToVC()
        }
    }
    
  }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    prepareVisibleCellsForAnimation()
        let apiClient = APIClient()
//        apiClient.getEndedPlace()
        apiClient.setVote(placeid: "1", candidateid: "1", phone: "1")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateVisibleCells()
    }
  
    private func showHowToVC() {
        // 앱 사용법을 팝업창으로 실행시킵니다.
        
        // if 처음이라면... 실행
        let howToVC = HowToViewController()
        present(howToVC, animated: true, completion: nil)
    }
}

extension VoteStatusViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VoteStatusViewCell
    
    let message = messages[(indexPath as NSIndexPath).row]
    
    cell.configure(
      title: message[listTitle]!,
      date: message[listDate]!
    )
    
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = messages[(indexPath as NSIndexPath).row]
        
        print(message)
    }
}

extension VoteStatusViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    return CGSize(width: view.bounds.width, height: layout.itemSize.height)
  }
}

extension VoteStatusViewController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segue.destination.hidesBottomBarWhenPushed = true
  }
}

//MARK: - Cell's animation

private extension VoteStatusViewController {
  
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
