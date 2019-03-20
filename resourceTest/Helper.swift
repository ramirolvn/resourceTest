import Alamofire
import Foundation
import GithubAPI
import SwiftyJSON



func login(email: String, password: String,completion: @escaping (_ user: UserResponse?, _ token: String?, _ error: String?)->()){
    let authentication = BasicAuthentication(username: email, password: password)
    var header = authentication.value.components(separatedBy: " ")
    let token: String = header[1]
    UserAPI(authentication: authentication).getUser { (response, error) in
        if let response = response, let _ = response.login {
            completion(response, token, nil)
        } else if let response = response, response.login == nil{
            completion(nil, nil, "Erro no login, verifique as credenciais e tente novamente!")
        }else {
            completion(nil, nil, "Erro na requisição, por favor tente novamente!")
        }
    }
}

func getAllUsers(sinceId:String = "0", completion: @escaping (_ user: [JSON]?, _ error: String?)->()){
    let todoEndpoint: String = "https://api.github.com/users?since="+sinceId
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Basic \(token)",
        "Accept": "application/json"
    ]
    Alamofire.request(todoEndpoint, headers: headers).responseJSON { response in
        guard response.result.error == nil else {
            completion(nil, "Erro na requisição, por favor tente novamente!")
            return
        }
        
        if let responseValue = response.result.value{
            let json = JSON(responseValue)
            guard let jsonArr = json.array  else {
                completion(nil,"Erro ao requisitar usuários, por favor tente novamente!")
                return
            }
            completion(jsonArr,nil)
        }
    }
}

func getSingleUser(user: String, completion: @escaping (_ user: [String:Any]?, _ error: String?)->()){
    let todoEndpoint: String = "https://api.github.com/users/"+user
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Basic \(token)",
        "Accept": "application/json"
    ]
    Alamofire.request(todoEndpoint, headers: headers).responseJSON { response in
        guard response.result.error == nil else {
            completion(nil,"Erro na requisição, por favor tente novamente!")
            return
        }
        if let responseValue = response.result.value{
            let json = JSON(responseValue)
            guard let jsonDict = json.dictionaryObject else {
                completion(nil,"Erro ao requisitar usuário, por favor tente novamente!")
                return
            }
            completion(jsonDict,nil)
        }
    }
}

func getUserRepos(user: String, completion: @escaping (_ repositories: [JSON]?, _ error: String?)->()){
    let todoEndpoint: String = "https://api.github.com/users/\(user)/repos"
    let token = UserDefaults.standard.string(forKey: "token") ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Basic \(token)",
        "Accept": "application/json"
    ]
    Alamofire.request(todoEndpoint, headers: headers).responseJSON { response in
        guard response.result.error == nil else {
            completion(nil,"Erro na requisição, por favor tente novamente!")
            return
        }
        
        if let responseValue = response.result.value{
            let json = JSON(responseValue)
            guard let jsonArr = json.array  else {
                completion(nil,"Erro ao requisitar repositórios, por favor tente novamente!")
                return
            }
            completion(jsonArr,nil)
        }
    }
}

