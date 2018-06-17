
import UIKit

class PromiseViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var webView: UIWebView = {
        let wv = UIWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.backgroundColor = UIColor.white
        return wv
    }()
    
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
        tabBarController?.tabBar.isHidden = true
        webView.delegate = self
        view.addSubview(agreeBtn)
        view.addSubview(webView)
        
        if let url = URL(string: "http://yangarch.iptime.org/bvc/candidateimg/comm/1moon.pdf") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
            appDelegate.isshowActivityIndicatory()
        }
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: agreeBtn.topAnchor).isActive = true
        
        agreeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        agreeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        agreeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        agreeBtn.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
    }
    
    @objc func handleVote() {
        /// 투표하기
        let apiClient = APIClient()
        apiClient.setVote(placeid: "1", candidateid: "1", phone: "1")
        
        navigationController?.pushViewController(EndViewController(), animated: true)
    }
}

extension PromiseViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        appDelegate.invisibleActivityIndicatory()
        return true
    }
}
