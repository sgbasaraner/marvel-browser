//
//  MarvelClient.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation
import CryptoKit

class MarvelClient {
    private let apiKey = "8f3255beb1f1ea4386df1bbfbd17977b"
    private let privateKey = "87d6c28bb640adc2b4b43fa7eade29546292933c"
    private let baseUrl = "https://gateway.marvel.com/v1/public/"
    
    private init () { }
    
    static let shared = MarvelClient()
    
    private typealias Params = [String : String]
    
    private func generateParams(limit: Int, offset: Int) -> Params {
        let ts = String(Date().timeIntervalSince1970)
        let hashComponents = ts + privateKey + apiKey
        let digest = Insecure.MD5.hash(data: hashComponents.data(using: .utf8) ?? Data())
        let hash = digest.map { String(format: "%02hhx", $0) }.joined()
        return [
            "hash" : hash,
            "ts" : ts,
            "apikey" : apiKey,
            "limit" : String(limit),
            "offset" : String(offset)
        ]
    }
    
    private func generateUrl(params: Params, urlString: String) -> URL? {
        let queryItems = params.map { (k, v) in URLQueryItem(name: k, value: v) }
        var urlComps = URLComponents(string: urlString)
        urlComps?.queryItems = queryItems
        return urlComps?.url
    }
    
    func requestCharacters(limit: Int, offset: Int, completion: @escaping (Result<GetCharactersResponse, Error>) -> Void) {
        let urlResult = Result.init { generateUrl(params: generateParams(limit: limit, offset: offset), urlString: baseUrl + "characters")! }
        // TODO: add better error handling
        switch urlResult {
        case .success(let url):
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let err = error { return completion(.failure(err)) }
                let dataResult = Result.init { data! }
                switch dataResult {
                case .success(let data):
                    return completion(Result
                        .init { try JSONDecoder()
                            .decode(GetCharactersResponse.self, from: data) })
                case .failure(let err):
                    return completion(.failure(err))
                }
            }.resume()
        case .failure(let err):
            completion(.failure(err))
        }
    }
}
