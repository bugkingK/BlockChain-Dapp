
import UIKit

class WhyViewController: UIViewController {
    
    private let containView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "개인정보 동의서"
        lb.tintColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.text = "test"
        tv.font = UIFont.systemFont(ofSize: 11)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.isScrollEnabled = true
        return tv
    }()
    
    private let agreeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("동의합니다.", for: .normal)
        btn.backgroundColor = .CStabBarColor
        btn.layer.cornerRadius = 18
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleAgree), for: .touchUpInside)
        return btn
    }()
    
    private let rejectionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("동의하지 않음.", for: .normal)
        btn.backgroundColor = .CStabBarColor
        btn.layer.cornerRadius = 18
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
        return btn
    }()
    
    private let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        textView.text = agreement
        view.addSubview(titleLabel)
        view.addSubview(containView)
        view.addSubview(agreeBtn)
        view.addSubview(lineSeparatorView)
        view.addSubview(rejectionBtn)
        containView.addSubview(textView)
        
        let margin = view.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: margin.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        containView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 10).isActive = true
        containView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        containView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        textView.topAnchor.constraint(equalTo: containView.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: containView.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: containView.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: containView.bottomAnchor).isActive = true
        
        rejectionBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        rejectionBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        rejectionBtn.topAnchor.constraint(equalTo: containView.bottomAnchor, constant: 10).isActive = true
        rejectionBtn.widthAnchor.constraint(equalToConstant: view.bounds.width / 2 - 15).isActive = true
        
        agreeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreeBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        agreeBtn.topAnchor.constraint(equalTo: containView.bottomAnchor, constant: 10).isActive = true
        agreeBtn.widthAnchor.constraint(equalToConstant: view.bounds.width / 2 - 15).isActive = true
    }
    
    @objc func handleAgree() {
        dismiss(animated: true, completion: {
            
        })
        print("agree")
        

    }
    
    @objc func handleReject() {
        dismiss(animated: true, completion: nil)
        print("reject")

    }
    
    private let agreement: String = "'OOO'은 (이하 '회사'는) 고객님의 개인정보를 중요시하며, 정보통신망 이용촉진 및 정보보호에 관한 법률을 준수하고 있습니다.\n 회사는 개인정보취급방침을 통하여 고객님께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.\n 회사는 개인정보취급방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다. \n\n ■ 수집하는 개인정보 항목 \n\n 회사는 회원가입, 상담, 서비스 신청 등등을 위해 아래와 같은 개인정보를 수집하고 있습니다. \n ο 수집항목 : 이름 , 생년월일 , 성별 , 로그인ID , 비밀번호 , 비밀번호 질문과 답변 , 자택 전화번호 , 자택 주소 , 휴대전화번호 , 이메일 , 직업 , 회사명 , 부서 , 직책 , 회사전화번호 , 취미 , 결혼여부 , 기념일 , 법정대리인정보 , 주민등록번호 , 서비스 이용기록 , 접속 로그 , 접속 IP 정보 , 결제기록 \n ο 개인정보 수집방법 : 홈페이지(회원가입) , 서면양식 \n\n ■ 개인정보의 수집 및 이용목적\n\n 회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.\n ο 회원 관리\n 회원제 서비스 이용에 따른 본인확인 , 개인 식별 , 연령확인 , 만14세 미만 아동 개인정보 수집 시 법정 대리인 동의여부 확인 , 고지사항 전달 \n\n ο 마케팅 및 광고에 활용\n 접속 빈도 파악 또는 회원의 서비스 이용에 대한 통계\n\n ■ 개인정보의 보유 및 이용기간\n 회사는 개인정보 수집 및 이용목적이 달성된 후에는 예외 없이 해당 정보를 지체 없이 파기합니다.\n\n ■ 개인정보의 파기절차 및 방법 \n 회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.\n ο 파기절차 \n 회원님이 회원가입 등을 위해 입력하신 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기되어집니다.\n 별도 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 보유되어지는 이외의 다른 목적으로 이용되지 않습니다.\n\n ο 파기방법\n\n - 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다. \n ■ 개인정보 제공\n회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.\n - 이용자들이 사전에 동의한 경우 \n - 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우"
    
}
