import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var loginUser: UILabel!
    @IBOutlet weak var idUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }
    
}
