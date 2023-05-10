//
//  BaseService.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.05.2023.
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
    let error: String?
}

struct GetUserResponse<User: Codable>: Codable {
    let succeeded: Bool
    let user: User?
}
struct GetCollectionsResponse<Collection: Codable>: Codable {
    let succeeded: Bool
    let collections: [Collection]?

}

struct GetCollectionResponse<Collection: Codable>: Codable {
    let succeeded: Bool
    let collection: Collection?

}

struct getCollectionDetailResponse<Collection: Codable>: Codable {
    let succeeded: Bool
    let collections: Collection?
}



let rootUrl = "\(Environment.getRootUrl())"


func headers() -> HTTPHeaders {
     if let token: String = LocalStorage.getItem(key: "baseTOKEN") {
         return  ["Authorization": "Bearer \(token)", "Content-Type" : "application/json"]
     }
     print("NO TOKEN EXISTS..")
     return ["Content-Type" : "application/json"]
     
 }
