
import UIKit

class VoteStatusViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func configure(title: String, date: String) {
        self.title.text = title
        self.date.text = date
    }
}
