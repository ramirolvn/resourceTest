import UIKit

class RepositoryCell: UITableViewCell {
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var repositoryDescription: UILabel!
    @IBOutlet weak var repositoryWatchers: UILabel!
    @IBOutlet weak var watcherImg: UIImageView!
    @IBOutlet weak var privateImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
