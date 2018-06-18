
import UIKit

class AuthViewController: UIViewController, YALTabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var webView: UIWebView = {
        let wv = UIWebView()
        wv.backgroundColor = UIColor.white
        return wv
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        appDelegate.tabBarController?.tabBarView.backgroundColor = .white
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.tabBarController?.tabBarView.backgroundColor = .CStabBarViewColor
    }
    
    deinit {
        print("AuthViewController deinit")
        
    }
    
    private func setupViews() {
        webView.frame = view.frame
        webView.delegate = self
        
        view.addSubview(webView)
        
        if let url = URL(string: "http://www.sejung.co.kr/cert/phone_request.jsp") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
            appDelegate.isshowActivityIndicatory()
        }
    }
    
    func tabBarDidSelectExtraRightItem(_ tabBar: YALFoldingTabBar) {
        UserDefaults.standard.setIsLoggedIn(value: true)
        let alert = UIAlertController(title: "Information", message: "인증되었습니다", preferredStyle: .alert)
        alert.addTextField() { (tf) in tf.placeholder = "휴대전화번호 입력.." }
        alert.addAction(UIAlertAction(title: "확인.", style: .default) { (_) in
            let phoneNumber = alert.textFields?[0].text // 전화번호
            userInfo.phone = phoneNumber
            UserDefaults.standard.setIsAutu(value: true)
        })
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        tabBarController?.selectedIndex = 2
    }
}

extension AuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        appDelegate.invisibleActivityIndicatory()
        return true
    }
}

