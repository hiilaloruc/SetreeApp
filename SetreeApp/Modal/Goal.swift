//
//  Goal.swift
//  SetreeApp
//
//  Created by HilalOruc on 15.05.2023.
//

import Foundation

struct Goal: Codable {
    let goalId: Int
    let userId: Int
    let title: String
    let status: String
    let createdAt, updatedAt : String
    let goalItems : [GoalItem]?

    
    enum CodingKeys: String, CodingKey {
        case goalId = "id"
        case userId
        case title, status
        case createdAt, updatedAt
        case goalItems //not sure
    }
}

struct GoalItem: Codable {
    let goalItemId: Int
    let content: String
    let isDone: Bool
    
    enum CodingKeys: String, CodingKey {
        case goalItemId = "id"
        case content, isDone
    }
    
}
