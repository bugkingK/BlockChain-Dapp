
import UIKit
import Alamofire

class VoteStatusViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func configure(title: String, date: String, imageURL: String) {
        Alamofire.request(imageURL, method: .get).responseData { response in
            if response.error == nil {
                // Show the downloaded image:
                if let data = response.data {
                    self.image.image = UIImage(data: data)
                }
            }
        }
        
        self.title.text = title
        self.date.text = date
    }
}
