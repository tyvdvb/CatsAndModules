//
//  Networking.swift
//  Networking
//
//  Created by Ira Nazar on 2024-05-28.
//

import Foundation

public class Networking {
    private let catApiKey = "live_rJUyScEtLO1EurBAd7Qcv0Bkfn7ZpKZUAjRazsZwBQHC2ACGgVhIUTyK1E3Oa4qb"
    private let catBaseUrl = "https://api.thecatapi.com/v1/images/search"
    private let dogBaseUrl = "https://api.thedogapi.com/v1/images/search"
    private let dogApiKey = "live_TzkWPUvzBrJKncP9nSpXkyhpFz2iBxizevDx6BVubbJ7h3i66ZziER21LROmKV5O"
    
    public init() {}
    
    public func getAnimals(limit: Int = 100, page: Int = 0, completion: @escaping ([Animal]?) -> Void) {
        let urlString = baseUrlForAnimal() + "?limit=\(limit)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKeyForAnimal(), forHTTPHeaderField: "x-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let requestedAnimals = try decoder.decode([Animal].self, from: data)
                    completion(requestedAnimals)
                } catch {
                    //                    print("Failed to decode JSON: \(error)")
                    completion(nil)
                }
            } else {
                //                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        task.resume()
    }
    
    private func baseUrlForAnimal() -> String {
        if let appType = Bundle.main.object(forInfoDictionaryKey: "App Type") as? String {
            return appType == "CATS" ? catBaseUrl : dogBaseUrl
        } else {
            // Default to cat API
            return dogBaseUrl
        }
    }
    private func apiKeyForAnimal() -> String {
        if let appType = Bundle.main.object(forInfoDictionaryKey: "App Type") as? String {
            print("App Type: \(appType)")
            return appType == "CATS" ? catApiKey : dogApiKey
        } else {
            return dogApiKey
        }
    }
}

public struct Animal: Decodable, Identifiable {
    public let id: String
    public let url: String
}
