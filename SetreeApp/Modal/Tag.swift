//
//  Tag.swift
//  SetreeApp
//
//  Created by HilalOruc on 3.06.2023.
//

import Foundation

struct Tag: Codable {
    
    let tagId: Int
    let title: String
    let collectionIds : [Int]
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case tagId = "id"
        case title
        case collectionIds, createdAt

    }
}
