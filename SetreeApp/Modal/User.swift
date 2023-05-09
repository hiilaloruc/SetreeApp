//
//  User.swift
//  SetreeApp
//
//  Created by HilalOruc on 9.05.2023.
//

import Foundation

struct User: Codable {
    let userId: Int
    let username, firstName, lastName: String
    let email: String?
    let profilePhotoUrl: String?
    let gender: String?
    let status: String?
    let followers, followings : [Int]?
    let createdAt, updatedAt :  String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case username, firstName, lastName
        case email
        case profilePhotoUrl
        case gender,status
        case followers, followings
        case createdAt, updatedAt,password
    }
}
