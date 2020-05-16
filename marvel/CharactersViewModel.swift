//
//  CharactersViewModel.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

enum FetchType {
    case firstFetch
    case nonFirstFetch(indexPathsToReload: [IndexPath])
}

protocol CharactersViewModelDelegate: class {
    func fetchedCharacters(type: FetchType)
    func fetchFailed(reason: String)
}

class CharactersViewModel {
    private weak var delegate: CharactersViewModelDelegate?
    
    private var characters: [Character] = []
    private var currentPage = 1
    
    private let charactersInPage = 30
    
    private var isCurrentlyFetching = false

    init(delegate: CharactersViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCharacterCount: Int {
        characters.count
    }
    
    var totalFetchableCharacterCount: Int = 0
    
    func character(at index: Int) -> Character? {
        characters.nth(index)
    }

    func fetchCharacters() {
        guard !isCurrentlyFetching else { return }
        isCurrentlyFetching = true
        
        let limit = currentPage * charactersInPage
        let offset = (currentPage - 1) * charactersInPage
        let completion: (Result<GetCharactersResponse, Error>) -> Void = { [weak self] result in
            guard let strSelf = self else { return }
            strSelf.isCurrentlyFetching = false
            switch result {
            case .failure(let err):
                strSelf.delegate?.fetchFailed(reason: err.localizedDescription)
            case .success(let response):
                strSelf.currentPage += 1
                strSelf.totalFetchableCharacterCount = response.data.total
                strSelf.characters.append(contentsOf: response.data.results)
                let fetchType: FetchType = strSelf.currentPage == 2 ? .firstFetch : .nonFirstFetch(indexPathsToReload: strSelf.lastPageIndexPaths)
                strSelf.delegate?.fetchedCharacters(type: fetchType)
            }
        }
        
        MarvelClient.shared.requestCharacters(limit: limit, offset: offset, completion: completion)
    }
    
    var lastPageIndexPaths: [IndexPath] {
        let startIndex = characters.count - charactersInPage
        let endIndex = characters.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
