//
//  CreatureDataController.swift
//  Life-FormSearch
//
//  Created by Juliana Nielson on 6/8/23.
//

import UIKit

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData, encoding: .utf8) else {
                print("Failed to read JSON Object.")
                return
        }
        print(prettyJSONString)
    }
}

enum CreatureError: Error, LocalizedError {
    case creaturesNotFound
    case imageNotFound
}

class CreatureDataController {
    
    let baseURL = URL(string: "https://eol.org/api/search/1.0.json")!
    
    func fetchCreatures(matching query: [String: String]) async throws -> [CreatureData] {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CreatureError.creaturesNotFound
        }
        
        let jsonDecoder = JSONDecoder()
        let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CreatureError.imageNotFound
        }
        
        guard let image = UIImage(data: data) else {
            throw CreatureError.imageNotFound
        }
        
        return image
    }
}
