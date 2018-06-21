
import UIKit
import Alamofire

class CandidateViewCell: UICollectionViewCell {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "page1")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        
        return iv
    }()
    
    private let candidateName: UILabel = {
        let lb = UILabel()
        lb.text = "제목입니당"
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = UIColor(red: 112/255, green: 206/255, blue: 240/255, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let partyName: UILabel = {
        let lb = UILabel()
//        lb.text = "내용 샘플"
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private func setupViews() {
        backgroundColor = UIColor(red: 102/255, green: 100/255, blue: 155/255, alpha: 1)
        addSubview(imageView)
        addSubview(candidateName)
        addSubview(partyName)
        
        let margin = layoutMarginsGuide
        imageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.frame.width / 3).isActive = true
        
        candidateName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        candidateName.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        candidateName.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        candidateName.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
        
        partyName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        partyName.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        partyName.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        partyName.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
    }
    
    func configure(imageURL: String, candidateName: String) {
        Alamofire.request(imageURL, method: .get).responseData { response in
            if response.error == nil {
                // Show the downloaded image:
                if let data = response.data {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        self.candidateName.text = candidateName
    }
}
