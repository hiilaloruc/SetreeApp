//
//  UserService.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.04.2023.
//

import Foundation
import Alamofire

struct RegisterResponse<T: Decodable>: Decodable {
    let succeeded: Bool
    let message: String?
    let user: T?
}

struct LoginResponse<T: Decodable>: Decodable {
    let succeeded: Bool
    let user: T?
    let token: String?
}


public class UserService {
    let rootUrl = "\(Environment.getRootUrl())"
    
    internal func registerUser(firstName: String,lastName: String,username: String,email:String,password:String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(rootUrl)/register"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "firstName":firstName,
            "lastName": lastName,
            "username":username,
            "email": email,
            "password": password
        ], encoding: JSONEncoding.default).responseDecodable(of: RegisterResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let user = response.user {
                    completion(.success(user))
                } else {
                    let errorMessage = response.message ?? "Unknown error"
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    internal func loginUser(email:String,password:String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(rootUrl)/login"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "email": email,
            "password": password
        ], encoding: JSONEncoding.default).responseDecodable(of: LoginResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let user = response.user,let token = response.token {
                    completion(.success(user))
                    LocalStorage.setItem("baseTOKEN", value:token)
                } else {
                    let errorMessage = "Error occured while logging in."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
