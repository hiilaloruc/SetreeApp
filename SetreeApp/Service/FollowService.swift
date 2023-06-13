//
//  FollowService.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.05.2023.
//

import Foundation
import Alamofire

public class FollowService {
    
    internal func getFollowings(id: Int? = nil, completion: @escaping (Result<[User], Error>) -> Void) { // id=nil if user wants to get "her own" followers
        let url = "\(rootUrl)/getFollowings" + (id != nil ? "?id=\(id!)" : "")
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetFollowingResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let followingObjects = response.followingObjects {
                    completion(.success(followingObjects))
                } else {
                    let errorMessage =  "Error occured while getting followings."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func getFollowers(id: Int? = nil, completion: @escaping (Result<[User], Error>) -> Void) { // id=nil if user wants to get "her own" followers
        let url = "\(rootUrl)/getFollowers" + (id != nil ? "?id=\(id!)" : "")
        
        // Alamofire : GET request
        AF.request(url, headers: headers()).responseDecodable(of: GetFollowerResponse<User>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded, let followerObjects = response.followerObjects {
                    completion(.success(followerObjects))
                } else {
                    let errorMessage =  "Error occured while getting followers."
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func follow(userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/follow/\(userId)" // followed userid
        
        // Alamofire : POST request
        AF.request(url, headers: headers()).responseDecodable(of: BaseResponseW_2E<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let message = response.message {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "User couldn't be followed"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    internal func unfollow(userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(rootUrl)/unfollow/\(userId)" // unfollowed userid
        
        // Alamofire : POST request
        AF.request(url, headers: headers()).responseDecodable(of: BaseResponseW_2E<String>.self) { response in
            print("response:", response)
            switch response.result {
            case .success(let response):
                if response.succeeded , let message = response.message {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message ?? "User couldn't be unfollowed"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
