//
//  CharacterDetailViewModel.swift
//  marvel
//
//  Created by Sarp on 16.05.2020.
//  Copyright © 2020 Sarp. All rights reserved.
//

import Foundation

class CharacterDetailViewModel: AsyncFetchingViewModel {
    typealias Item = Comic
    
    private weak var delegate: PrefetchingViewModelDelegate?
    
    private var currentPage = 1
    
    let pageSize: Int
    
    private var isCurrentlyFetching = false
    
    private(set) var items: [Comic] = []
    
    private let character: MarvelCharacter

    init(delegate: PrefetchingViewModelDelegate, pageSize: Int, character: MarvelCharacter) {
        self.delegate = delegate
        self.pageSize = pageSize
        self.character = character
    }
    
    private(set) var totalFetchableItemCount: Int = 0

    private lazy var newerThanDate: Date = {
        let formatter = DateFormatter.posix
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: "2005/01/01 00:00")!
    }()
    
    func fetchItems() {
        guard !isCurrentlyFetching else { return }
        isCurrentlyFetching = true
        
        let limit = pageSize
        let offset = 0
        let completion: (Result<GetResultsResponse<Comic>, Error>) -> Void = { [weak self] result in
            guard let strSelf = self else { return }
            strSelf.isCurrentlyFetching = false
            switch result {
            case .failure(let err):
                print(limit)
                print(offset)
                strSelf.delegate?.fetchFailed(reason: err.localizedDescription)
            case .success(let response):
                strSelf.currentPage += 1
                strSelf.totalFetchableItemCount = min(response.data.total, strSelf.pageSize)
                strSelf.items.append(contentsOf: response.data.results)
                let fetchType: FetchType = strSelf.currentPage == 2 ? .firstFetch : .nonFirstFetch(indexPathsToReload: strSelf.lastPageIndexPaths)
                strSelf.delegate?.fetchedItems(type: fetchType)
            }
        }
        
        MarvelClient.shared.requestComics(for: character,
                                          newerThan: newerThanDate,
                                          limit: limit,
                                          offset: offset,
                                          completion: completion)
    }
}
