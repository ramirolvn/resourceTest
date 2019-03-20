import Alertift
import UIKit
import SDWebImage

class ProfilesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    @IBOutlet weak var backGroundController: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var detailViewController: DetailViewController? = nil
    var users = [User]()
    var filteredUsers = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    private func loadMoreUsers(lastId: String){
        self.backGroundController.isHidden = false
        getAllUsers(sinceId: lastId, completion: {
            users, error in
            if let usrs = users{
                for u in usrs{
                    if let uDict = u.dictionaryObject, let login = uDict["login"] as? String, let userID = uDict["id"] as? Int, let node_id = uDict["node_id"] as? String, let avatar_url = uDict["avatar_url"] as? String, let url = uDict["url"] as? String, let html_url = uDict["html_url"] as? String, let followers_url = uDict["followers_url"] as? String, let subscriptions_url = uDict["subscriptions_url"] as? String, let organizations_url = uDict["organizations_url"] as? String, let repos_url = uDict["repos_url"] as? String{
                        self.users.append(User(login: login, userId: userID, node_id: node_id, avatar_url: avatar_url, url: url, html_url: html_url, followers_url: followers_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, bio: nil, name: nil, location: nil))
                    }
                }
            }else if let e = error{
                self.showAlertError(e)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.backGroundController.isHidden = true
            }
        })
    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .black
        self.tableView.backgroundColor = mainColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Procure por login dos usuários"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): mainColor], for: .normal)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
            
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        tableView.tableFooterView = searchFooter
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        if self.users.count == 0{
            self.backGroundController.isHidden = false
            getAllUsers(completion: {users, error in
                var usersArray = [User]()
                if let usrs = users{
                    for u in usrs{
                        if let uDict = u.dictionaryObject, let login = uDict["login"] as? String, let userID = uDict["id"] as? Int, let node_id = uDict["node_id"] as? String, let avatar_url = uDict["avatar_url"] as? String, let url = uDict["url"] as? String, let html_url = uDict["html_url"] as? String, let followers_url = uDict["followers_url"] as? String, let subscriptions_url = uDict["subscriptions_url"] as? String, let organizations_url = uDict["organizations_url"] as? String, let repos_url = uDict["repos_url"] as? String{
                            usersArray.append(User(login: login, userId: userID, node_id: node_id, avatar_url: avatar_url, url: url, html_url: html_url, followers_url: followers_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, bio: nil, name: nil, location: nil))
                        }
                    }
                    self.users = usersArray
                }else if let e = error{
                    self.showAlertError(e)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.backGroundController.isHidden = true
                }
                
            })
        }
        
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredUsers.count, of: users.count)
            return filteredUsers.count
        }
        
        searchFooter.setNotFiltering()
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell{
            let user: User
            if isFiltering() {
                user = filteredUsers[indexPath.row]
            } else {
                user = users[indexPath.row]
            }
            cell.loginUser.text = user.login
            cell.idUser.text = "Id: \(user.userId)"
            if let imageURL = URL(string: user.avatar_url){
                cell.userImage.sd_setShowActivityIndicatorView(true)
                cell.userImage.sd_setIndicatorStyle(.white)
                cell.userImage.sd_setImage(with: imageURL)
            }
            if(self.tableView.numberOfRows(inSection: 0) == indexPath.row+1 && !self.isFiltering()){
                self.loadMoreUsers(lastId: "\(user.userId)")
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.backGroundController.isHidden = false
        var user: User
        if isFiltering() {
            user = filteredUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        getSingleUser(user: user.login, completion: {
            (userInfo,error) in
            if let e = error{
                self.showAlertError(e)
            }else{
                if let name = userInfo?["name"] as? String{
                    user.name = name
                }
                if let bio = userInfo?["bio"] as? String{
                    user.bio = bio
                }
                if let location = userInfo?["location"] as? String{
                    user.location = location
                }
                getUserRepos(user: user.login, completion: {(repos, error) in
                    if let e = error{
                        self.showAlertError(e)
                        self.backGroundController.isHidden = true
                    }else{
                        var repositoriesAux: [Repository]?
                        if let repositories = repos, repositories.count > 0{
                            repositoriesAux = [Repository]()
                            for repo in repositories{
                                if let repoDict = repo.dictionaryObject, let name = repoDict["name"] as? String, let full_name = repoDict["full_name"] as? String, let isPrivate = repoDict["private"] as? Bool, let repoDescription = repoDict["description"] as? String, let html_url = repoDict["html_url"] as? String, let watchers_count = repoDict["watchers_count"] as? Int{
                                    repositoriesAux?.append(Repository(name: name, full_name: full_name, isPrivate: isPrivate, repoDescription: repoDescription, html_url: html_url, watchers_count: watchers_count))
                                }
                            }
                        }
                        self.backGroundController.isHidden = true
                        self.performSegue(withIdentifier: "showDetail", sender: [user,repositoriesAux])
                    }
                    
                })
            }
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = mainColor
    }
    
    private func showAlertError(_ msg: String){
        DispatchQueue.main.async {
            Alertift.alert(title: "Erro", message: msg)
                .action(.default("Ok"))
                .show(on: self)
        }
    }
    
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if  let controller = segue.destination as? ProfileDetailController,let senderArr = sender as? [Any] {
                if  let completeUser = senderArr[0] as? User{
                    controller.detailUser = completeUser
                }
                if let repositories = senderArr[1] as? [Repository]{
                    controller.userRepositories = repositories
                }
            }
        }
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "token")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginCntrl")
        self.present(loginViewController, animated: false, completion: nil)
    }
    
    
    
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter({( user : User) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else {
                return user.login.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ProfilesController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.filteredUsers.count == 0, let user = searchBar.text?.lowercased(){
            self.backGroundController.isHidden = false
            getSingleUser(user: user, completion: {
                (user,error) in
                if let u = user, let login = u["login"] as? String, let userID = u["id"] as? Int, let node_id = u["node_id"] as? String, let avatar_url = u["avatar_url"] as? String, let url = u["url"] as? String, let html_url = u["html_url"] as? String, let followers_url = u["followers_url"] as? String, let subscriptions_url = u["subscriptions_url"] as? String, let organizations_url = u["organizations_url"] as? String, let repos_url = u["repos_url"] as? String{
                    self.filteredUsers = [User(login: login, userId: userID, node_id: node_id, avatar_url: avatar_url, url: url, html_url: html_url, followers_url: followers_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, bio: nil, name: nil, location: nil)]
                    
                }else if let e = error{
                    self.showAlertError(e)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.backGroundController.isHidden = true
                }
                
            })
        }
    }
    
}

extension ProfilesController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
