
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
        alert.addAction(UIAlertAction(title: "확인.", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        tabBarController?.selectedIndex = 2
        print("일단은 인증성공합니당.")
    }
}

extension AuthViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print("request : \(request)")
        appDelegate.invisibleActivityIndicatory()
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 직접 구현..
    }
}

