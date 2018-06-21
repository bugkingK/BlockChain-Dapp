
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews() {
        title = "공약보기"
        self.view.backgroundColor = .white
        
        webView.delegate = self
        view.addSubview(agreeBtn)
        view.addSubview(webView)
        
        let index = UserDefaults.standard.getSelectedIndex()
        appDelegate.isshowActivityIndicatory()
        
        guard let url = URL(string: candidateInfo[index].pdfURL) else {
            appDelegate.showAlert("pdf를 불러올 수 없습니다.")
            return
        }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: agreeBtn.topAnchor).isActive = true
        
        agreeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        agreeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        agreeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        agreeBtn.heightAnchor.constraint(equalToConstant: view.frame.height / 10).isActive = true
    }
    
    /// 투표하기
    @objc func handleVote() {
        guard let placeid = userInfo.selectPlaceid,
              let candidateid = userInfo.selectCandidateid,
              let phone = userInfo.phone,
              let name = userInfo.name else {
                let alert = UIAlertController(title: nil, message: "다시 인증해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let alert = UIAlertController(title: "투표하시겠습니까?", message: "\(name)이 맞습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "예", style: .default) { (_) in
            
            let apiClient = APIClient()
            apiClient.isAction(token: phone) { isAction in
                print(isAction)
                
                if(isAction){
                    apiClient.setVote(placeid: placeid, candidateid: candidateid, phone: phone) { response in
                        userInfo.transactionAddress = response
                        apiClient.setAuth(token: phone)
                        self.navigationController?.pushViewController(EndViewController(), animated: true)
                    }
                } else {
                    self.appDelegate.showAlert("잘못된 토큰입니다.")
                }
            }
        }
        let noAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension PromiseViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        appDelegate.invisibleActivityIndicatory()
        return true
    }
}
