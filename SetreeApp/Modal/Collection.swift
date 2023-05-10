//
//  Collection.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.05.2023.
//

import Foundation
struct Collection: Codable {
    let collectionId: Int
    let userId: Int
    let title: String
    let imageUrl: String?
    let status: String
    let isPublic: Bool
    let createdAt, updatedAt :  String?
    let collection : [CollectionItemMinor]?
    
    enum CodingKeys: String, CodingKey {
        case collectionId = "id"
        case userId
        case title
        case imageUrl
        case isPublic,status
        case createdAt, updatedAt
        case collection
    }
}
struct CollectionItemMinor: Codable {
    let collectionItemId: Int
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case collectionItemId = "id"
        case content
    }
    
}
