import Foundation

class Repository: NSObject {
    @objc let name: String
    @objc let full_name: String
    @objc let isPrivate: Bool
    @objc let repoDescription: String
    @objc let html_url: String
    @objc let watchers_count: Int
    
    // MARK: - Initializers
    
    init(name: String, full_name: String, isPrivate: Bool, repoDescription: String, html_url: String, watchers_count: Int) {
        self.name = name
        self.full_name = full_name
        self.isPrivate = isPrivate
        self.repoDescription = repoDescription
        self.html_url = html_url
        self.watchers_count = watchers_count
    }
    
}
