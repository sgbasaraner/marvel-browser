//
//  GetCharactersResponse.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

struct GetCharactersResponse: Codable {
    let data: CharacterDataContainer
}

struct Character: Codable {
    let name, resultDescription: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: ComicList?
    let urls: [URLElement]

    enum CodingKeys: String, CodingKey {
        case resultDescription = "description"
        case name, thumbnail, resourceURI, comics, urls
    }
}

struct CharacterDataContainer: Codable {
    let results: [Character]
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
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}
