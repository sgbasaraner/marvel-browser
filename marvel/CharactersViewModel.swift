//
//  CharactersViewModel.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

protocol CharactersViewModelDelegate: class {
    func fetchedCharacters(at indexPaths: [IndexPath])
    func fetchFailed(reason: String)
}

class CharactersViewModel {
    private weak var delegate: CharactersViewModelDelegate?
    
    private var characters: [Character] = []
    private var currentPage = 1

    init(delegate: CharactersViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        characters.count
    }
    
    func character(at index: Int) -> Character {
        characters[index]
    }

    func fetchCharacters() {
        // TODO: call marvel API
    }
}
