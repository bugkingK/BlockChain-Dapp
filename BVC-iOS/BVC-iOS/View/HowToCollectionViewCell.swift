
import UIKit

class HowToCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "page1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .white
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "제목입니당"
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textColor = UIColor(white: 0.2, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let contentLabel: UILabel = {
        let lb = UILabel()
        lb.text = "내용 샘플"
        lb.textAlignment = .center
        lb.numberOfLines = 5
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor(white: 0.5, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        addSubview(imageView)
        addSubview(lineSeparatorView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        let margin = layoutMarginsGuide
        imageView.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: frame.height / 1.5).isActive = true
        
        lineSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineSeparatorView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        lineSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    func configure(image: UIImage, title: String, contents: String) {
        imageView.image = image
        titleLabel.text = title
        contentLabel.text = contents
    }
}

