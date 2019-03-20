import Alertift
import LoaderButton
import UIKit

class LoginController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: LoaderButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField{
            self.passwordTextField.becomeFirstResponder()
        }else{
            self.login()
        }
        return true
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.login()
    }
    
    private func login(){
        self.view.endEditing(true)
        self.loginBtn.startAnimate(loaderType: .pacman, loaderColor: mainColor, complete: nil)
        if let email = self.emailTextField.text, let password = self.passwordTextField.text{
            resourceTest.login(email: email, password: password, completion: {(user, token, error) in
                if user != nil{
                    getAllUsers(completion: {users, error in
                        var usersArray = [User]()
                        self.loginBtn.stopAnimate(complete: nil)
                        if let usrs = users{
                            for u in usrs{
                                if let uDict = u.dictionaryObject, let login = uDict["login"] as? String, let userID = uDict["id"] as? Int, let node_id = uDict["node_id"] as? String, let avatar_url = uDict["avatar_url"] as? String, let url = uDict["url"] as? String, let html_url = uDict["html_url"] as? String, let followers_url = uDict["followers_url"] as? String, let subscriptions_url = uDict["subscriptions_url"] as? String, let organizations_url = uDict["organizations_url"] as? String, let repos_url = uDict["repos_url"] as? String{
                                    usersArray.append(User(login: login, userId: userID, node_id: node_id, avatar_url: avatar_url, url: url, html_url: html_url, followers_url: followers_url, subscriptions_url: subscriptions_url, organizations_url: organizations_url, repos_url: repos_url, bio: nil, name: nil, location: nil))
                                }
                            }
                            DispatchQueue.main.async {
                                if let t = token{
                                    UserDefaults.standard.set(t, forKey: "token")
                                }
                                self.performSegue(withIdentifier: "mainNavSegue", sender: usersArray)
                            }
                        }else if let e = error{
                            self.showAlertError(e)
                            self.loginBtn.stopAnimate(complete: nil)
                        }
                    })
                }else if let e = error{
                    self.showAlertError(e)
                    self.loginBtn.stopAnimate(complete: nil)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainNavSegue", let mainNav = segue.destination as? UINavigationController ,let profilesCntrl = mainNav.children[0] as? ProfilesController, let users = sender as? [User]{
            profilesCntrl.users = users
        }
    }
    
    private func showAlertError(_ msg: String){
        DispatchQueue.main.async {
            Alertift.alert(title: "Erro", message: msg)
                .action(.default("Ok"))
                .show(on: self)
        }
    }
    
    
    
}
