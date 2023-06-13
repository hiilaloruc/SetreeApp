//
//  UserService.swift
//  SetreeApp
//
//  Created by HilalOruc on 24.04.2023.
//

import Foundation
import Alamofire


public class UserService {
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
                    let errorMessage = response.error
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    internal func getUser(id: Int? = nil, completion: @escaping (Result<User, Error>) -> Void) {
        //let url = "\(rootUrl)/getUser?id=\(id)"
        let url = "\(rootUrl)/getUser" + (id != nil ? "?id=\(id!)" : "")
        print("Request Url: ", url)
        

        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetUserResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let user = response.user {
                    completion(.success(user))
                } else {
                    let errorMessage =  "Error occured while getting user."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func updateUser(firstName: String,lastName: String,username: String,email:String,gender:String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(rootUrl)/updateUser"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "firstName":firstName,
            "lastName": lastName,
            "username":username,
            "email": email,
            "gender": gender
        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: UpdateUserResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let user = response.user {
                    completion(.success(user))
                } else {
                    let errorMessage =  "User couldn't be updated."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func updateProfileImage(newUrl: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(rootUrl)/updateProfileImage"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "newUrl":newUrl,
        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: UpdateUserResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let user = response.user {
                    completion(.success(user))
                } else {
                    let errorMessage =  "User photo couldn't be updated."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func updatePassword(oldPassword: String,newPassword: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/updatePassword"

        // Alamofire : POST request
        AF.request(url, method: .post, parameters: [
            "oldPassword":oldPassword,
            "password":newPassword
        ], encoding: JSONEncoding.default, headers:headers()).responseDecodable(of: BaseResponseW_2E<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let message = response.message {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "User password couldn't be changed"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
}
