import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
            if let detailDescriptionLabel = detailDescriptionLabel, let userImageView = userImageView {
                detailDescriptionLabel.text = detailUser.login
                userImageView.image = UIImage(named: detailUser.login)
                title = "Id: \(detailUser.userId)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

