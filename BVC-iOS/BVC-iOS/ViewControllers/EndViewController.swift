
import UIKit

class EndViewController: UIViewController {

    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "투표가 완료되었습니다."
        lb.tintColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        view.backgroundColor = UIColor.CSviewBackgroundColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            //self.tabBarController?.selectedIndex = 2
        }
        
        
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
    }

}
