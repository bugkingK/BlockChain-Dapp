
import UIKit

class VoteListViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bg")
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 18
        iv.translatesAutoresizingMaskIntoConstraints = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "제목입니당"
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 25)
        lb.textColor = UIColor(red: 113, green: 209, blue: 242, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "가나다라마바사 내용입니다. 가나다라마바사 내용입니다. 가나다라마바사 내용입니다. 가나다라마바사 내용입니다. 가나다라마바사 내용입니다. 가나다라마바사 내용입니다. 가나다라마바사 내용입니다. "
        lb.textAlignment = .center
        lb.numberOfLines = 5
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textColor = UIColor(red: 219, green: 221, blue: 246, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    func setupViews() {
        self.layer.cornerRadius = 15
        //        backgroundColor = .red
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 1.5)
        
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func configure(image: UIImage, title: String, contents: String) {
        self.imageView.image = image
        titleLabel.text = title
        contentLabel.text = contents
    }
}
