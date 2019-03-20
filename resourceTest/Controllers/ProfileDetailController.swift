import UIKit
import SafariServices

class ProfileDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var profileUserTable: UITableView!
    var detailUser: User!
    var userRepositories: [Repository]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileUserTable.rowHeight = UITableView.automaticDimension
        profileUserTable.estimatedRowHeight = 100
        self.profileUserTable.delegate = self
        self.profileUserTable.dataSource = self
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = self.userRepositories{
            return 1+repos.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0, let userCell = self.profileUserTable.dequeueReusableCell(withIdentifier: "userProfileCell") as? UserProfileCell{
            userCell.userLogin.text = "@"+detailUser.login
            userCell.userName.text = detailUser.name ?? ""
            userCell.userBio.text = detailUser.bio ?? ""
            userCell.userLocation.text = detailUser.location ?? ""
            if let imageURL = URL(string: detailUser.avatar_url){
                userCell.userImage.sd_setShowActivityIndicatorView(true)
                userCell.userImage.sd_setIndicatorStyle(.white)
                userCell.userImage.sd_setImage(with: imageURL)
            }
            return userCell
        }else if let repoCell = self.profileUserTable.dequeueReusableCell(withIdentifier: "repoCell") as? RepositoryCell, let repos = self.userRepositories{
            let repository = repos[indexPath.row-1]
            
            repoCell.repositoryName.text = repository.name
            repoCell.privateImg.image = repository.isPrivate == true ? UIImage(named: "private") : UIImage(named: "public")
            repoCell.repositoryWatchers.text = "\(repository.watchers_count)"
            repoCell.repositoryDescription.text = repository.repoDescription
            
            return repoCell
        }else {
            self.profileUserTable.separatorInset = UIEdgeInsets(top: 0, left: 1000000, bottom: 0, right: 0)
            return self.profileUserTable.dequeueReusableCell(withIdentifier: "cellNull") ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            debugPrint("Will Edit Profile")
        }else{
            if let repos = self.userRepositories{
                let repository = repos[indexPath.row-1]
                if let url = URL(string: repository.html_url){
                    let safariCntrl = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    self.present(safariCntrl, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            cell.backgroundColor = mainColor
        }
    }
    
}
