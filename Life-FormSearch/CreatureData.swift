//
//  JSONData.swift
//  Life-FormSearch
//
//  Created by Juliana Nielson on 6/8/23.
//

import Foundation

struct CreatureData: Codable {
    var id: Int
    var commonNames: String
    var scientificName: String
    var url: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case commonNames = "content"
        case scientificName = "title"
        case url = "link"
    }
}

struct SearchResponse: Codable {
    let results: [CreatureData]
}
