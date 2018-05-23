
import UIKit

class PromiseViewController: UIViewController {
    
    private let agreeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("공약 및 투표하기", for: .normal)
        btn.backgroundColor = .CStabBarColor
        btn.layer.cornerRadius = 18
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleVote), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
    }
    
    func setupViews() {
        title = "공약보기"
        self.view.backgroundColor = .white
        view.addSubview(agreeBtn)
        
        agreeBtn.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        agreeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        agreeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        agreeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func handleVote() {
        navigationController?.pushViewController(EndViewController(), animated: true)
    }
}
