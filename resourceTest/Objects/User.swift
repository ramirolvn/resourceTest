import Foundation

class User: NSObject {
    @objc let login: String
    @objc let userId: Int
    @objc let node_id: String
    @objc let avatar_url: String
    @objc let url: String
    @objc let html_url: String
    @objc let followers_url: String
    @objc let subscriptions_url: String
    @objc let organizations_url: String
    @objc let repos_url: String
    @objc var bio: String?
    @objc var name: String?
    @objc var location: String?
    
    // MARK: - Initializers
    
    init(login: String, userId: Int, node_id: String, avatar_url: String, url: String, html_url: String, followers_url: String, subscriptions_url: String, organizations_url: String, repos_url: String, bio: String?, name: String?, location: String?) {
        self.login = login
        self.userId = userId
        self.node_id = node_id
        self.avatar_url = avatar_url
        self.url = url
        self.html_url = html_url
        self.followers_url = followers_url
        self.subscriptions_url = url
        self.organizations_url = organizations_url
        self.repos_url = repos_url
        self.bio = bio
        self.name = name
        self.location = location
    }
    
}
