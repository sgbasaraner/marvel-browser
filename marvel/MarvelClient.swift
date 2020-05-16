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
    
    private func generateParams(limit: Int, offset: Int, extraParams: Params = [:]) -> Params {
        let ts = String(Date().timeIntervalSince1970)
        let hashComponents = ts + privateKey + apiKey
        let digest = Insecure.MD5.hash(data: hashComponents.data(using: .utf8) ?? Data())
        let hash = digest.map { String(format: "%02hhx", $0) }.joined()
        var dict = [
            "hash" : hash,
            "ts" : ts,
            "apikey" : apiKey,
            "limit" : String(limit),
            "offset" : String(offset)
        ]
        extraParams.forEach { (k, v) in
            dict[k] = v
        }
        return dict
    }
    
    private func generateUrl(params: Params, urlString: String) -> URL? {
        let queryItems = params.map { (k, v) in URLQueryItem(name: k, value: v) }
        var urlComps = URLComponents(string: urlString)
        urlComps?.queryItems = queryItems
        return urlComps?.url
    }
    
    func requestCharacters(limit: Int, offset: Int, completion: @escaping (Result<GetResultsResponse<MarvelCharacter>, Error>) -> Void) {
        let urlResult = Result.init { generateUrl(params: generateParams(limit: limit, offset: offset), urlString: baseUrl + "characters")! }
        switch urlResult {
        case .success(let url):
            marvelRequest(url: url, completion: completion)
        case .failure(let err):
            completion(.failure(err))
        }
    }
    
    func requestComics(for character: MarvelCharacter, newerThan date: Date, limit: Int, offset: Int, completion: @escaping (Result<GetResultsResponse<Comic>, Error>) -> Void) {
        let formatter = DateFormatter.posix
        formatter.dateFormat = "yyyy/MM/dd"
        let oldDateString = formatter.string(from: date)
        let todayString = formatter.string(from: Date())
        
        let additionalParams = [
            "dateRange" : "\(oldDateString),\(todayString)",
            "orderBy" : "-onsaleDate"
        ]
        
        let urlResult = Result.init {
            generateUrl(params: generateParams(limit: limit, offset: offset, extraParams: additionalParams),
                        urlString: baseUrl + "characters/\(character.id)/comics")!
        }
        switch urlResult {
        case .success(let url):
            marvelRequest(url: url, completion: completion)
        case .failure(let err):
            completion(.failure(err))
        }
    }
    
    private func marvelRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error { return completion(.failure(err)) }
            let dataResult = Result.init { data! }
            switch dataResult {
            case .success(let data):
                return completion(Result
                    .init { try JSONDecoder()
                        .decode(T.self, from: data) })
            case .failure(let err):
                return completion(.failure(err))
            }
        }.resume()
    }
}
