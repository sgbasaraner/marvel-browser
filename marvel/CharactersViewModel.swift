//
//  CharactersViewModel.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

class CharactersViewModel: PrefetchingViewModel {
    typealias Item = Character
    
    // Private API
    private weak var delegate: PrefetchingViewModelDelegate?
    
    private var currentPage = 1
    
    let pageSize: Int
    
    private var isCurrentlyFetching = false
    
    private var lastPageIndexPaths: [IndexPath] {
        let startIndex = items.count - pageSize
        let endIndex = items.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private(set) var items: [Character] = []

    required init(delegate: PrefetchingViewModelDelegate, pageSize: Int) {
        self.delegate = delegate
        self.pageSize = pageSize
    }
    
    private(set) var totalFetchableItemCount: Int = 0

    func fetchItems() {
        guard !isCurrentlyFetching else { return }
        isCurrentlyFetching = true
        
        let limit = currentPage * pageSize
        let offset = (currentPage - 1) * pageSize
        let completion: (Result<GetCharactersResponse, Error>) -> Void = { [weak self] result in
            guard let strSelf = self else { return }
            strSelf.isCurrentlyFetching = false
            switch result {
            case .failure(let err):
                print(limit)
                print(offset)
                strSelf.delegate?.fetchFailed(reason: err.localizedDescription)
            case .success(let response):
                strSelf.currentPage += 1
                strSelf.totalFetchableItemCount = response.data.total
                strSelf.items.append(contentsOf: response.data.results)
                let fetchType: FetchType = strSelf.currentPage == 2 ? .firstFetch : .nonFirstFetch(indexPathsToReload: strSelf.lastPageIndexPaths)
                strSelf.delegate?.fetchedItems(type: fetchType)
            }
        }
        
        MarvelClient.shared.requestCharacters(limit: limit, offset: offset, completion: completion)
    }
    
}
