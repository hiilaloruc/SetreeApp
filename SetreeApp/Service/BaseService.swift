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

/*struct UpdateUserResponse<User: Codable>: Codable {
    let succeeded: Bool
    let user: User?
}*/

struct UpdateUserResponse<T: Decodable>: Decodable {
    let succeeded: Bool
    let user: T?
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

struct GetFollowingResponse<User: Codable>: Codable {
    let succeeded: Bool
    let followingObjects: [User]?
}

struct GetFollowerResponse<User: Codable>: Codable {
    let succeeded: Bool
    let followerObjects: [User]?
}

struct GetGoalsResponse<Collection: Codable>: Codable {
    let succeeded: Bool
    let goals: [Goal]?
}

struct GetGoalDetailResponse<Collection: Codable>: Codable {
    let succeded: Bool
    let goal: Goal?
}

struct BaseResponseW_2E<T: Decodable>: Decodable {
    let succeeded: Bool
    let message: String?
}

struct baseAnswerWithMessage<T: Decodable>: Decodable {
    let succeded: Bool
    let message: String?
}
struct updateGoalItemResponse<GoalItem: Codable>: Codable {
    let succeded: Bool
    let message: String?
    let goalItem: GoalItem?
}

struct CreateCollectionResponse<Collection: Codable>: Codable {
    let succeded: Bool
    let message: String?
    let collection: Collection?
}

struct ImageResponse: Codable {
    let total: Int
    let totalHits: Int
    let hits: [ImageHit]
}

struct getItemsByCollectionResponse<CollectionItem : Codable>: Codable {
    let succeeded: Bool
    let collectionItems : [CollectionItem]?
}

    
struct ImageHit: Codable {
    let webformatURL: String
}


let rootUrl = "\(Environment.getRootUrl())"


func headers() -> HTTPHeaders {
     if let token: String = LocalStorage.getItem(key: "baseTOKEN") {
         return  ["Authorization": "Bearer \(token)", "Content-Type" : "application/json"]
     }
     print("NO TOKEN EXISTS..")
     return ["Content-Type" : "application/json"]
     
 }



