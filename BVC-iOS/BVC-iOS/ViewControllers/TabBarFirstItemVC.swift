
import UIKit

class TabBarFirstItemVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.tabBarController?.selectedIndex = 2
            self.showHowToVC()
        }
    }
    
    deinit {
        print("TabBarFirstItemVC")
    }
    
    private func showHowToVC() {
        // 앱 사용법을 팝업창으로 실행시킵니다.
        
        // if 처음이라면... 실행
        let howToVC = HowToViewController()
        present(howToVC, animated: true, completion: nil)
    }
    
}
