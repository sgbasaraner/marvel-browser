//
//  GetCharactersResponse.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

struct GetResultsResponse<T: Codable>: Codable {
    let data: ResultDataContainer<T>
}

struct Comic: Codable {
    let title: String
    let thumbnail: Thumbnail
}

struct MarvelCharacter: Codable {
    let id: Int
    let name, resultDescription: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: ComicList?
    let urls: [URLElement]

    enum CodingKeys: String, CodingKey {
        case resultDescription = "description"
        case name, thumbnail, resourceURI, comics, urls, id
    }
}

struct ResultDataContainer<T: Codable>: Codable {
    let results: [T]
    let total: Int
}

struct ComicList: Codable {
    let items: [ComicSummary]
}

struct ComicSummary: Codable {
    let resourceURI: String
    let name: String
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    var urlString: String {
        return path + "." + thumbnailExtension
    }
}

struct URLElement: Codable {
    let type: String
    let url: String
}
