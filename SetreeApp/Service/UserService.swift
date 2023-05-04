//
//  UserService.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.04.2023.
//

import Foundation
import Alamofire

public class UserService {
    let rootUrl = "\(Environment.getRootUrl())"
internal func registerUser(firstName: String,lastName: String,username: String,email:String,password:String) {
    let url = "\(rootUrl)/register"
    print("url: ",url)

    
    let parameters: [String: Any] = [
        "firstName":firstName,
        "lastName": lastName,
        "username":username,
        "email": email,
        "password": password
    ]
    
    // Alamofire : POST request
    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
        switch response.result {
        case .success(let value):
            if let result = value as? [String: Any] {
                if let succeeded = result["succeeded"] as? Bool {
                    if succeeded {
                        print("User is successfully registered :)")
                        // Perform here the actions to be taken when the user is successfully registered
                        
                        
                    } else {
                        let message = result["message"] as? String ?? "Unknown error"
                        print("The user could not be registered. Error: \(message)")
                        // Kullanıcı kaydedilemediğinde yapılacak işlemleri burada gerçekleştirin
                    }
                }
            }
        case .failure(let error):
            print("The user could not be registered. ERROR: \(error.localizedDescription)")
        }
    }
}

}
