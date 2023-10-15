//
//  FlickerImagesListViewModel.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 15/10/2023.
//

import Foundation
protocol FlickerImagesListViewModelDelegate: AnyObject {
    func searchDidComplete()
}

class FlickerImagesListViewModel {
    private let dataCoordinator: FeederDatasourceCoordinatorProtocol
    private let reachability: ReachabilityProtocol

    private var lastSearchedKeyword = ""
    private let countOfItemsPerPage = 5
    private var currentPage = 1 {
        didSet {
            currentPageDidUpdate()
        }
    }
    public weak var delegate: FlickerImagesListViewModelDelegate?
    public var items: [FeederDataItem] = []
    
    init(
        dataCoordinator: FeederDatasourceCoordinatorProtocol,
        reachability: ReachabilityProtocol
    ) {
        self.dataCoordinator = dataCoordinator
        self.reachability = reachability
    }
    
    func searchRemote(_ keyword: String) async throws {
        let searchResult = try await dataCoordinator.searchAndSyncCache(keyword, page: currentPage, countPerPage: countOfItemsPerPage)
        if currentPage > 1 {
            items.append(contentsOf: searchResult)
        } else {
            items = searchResult
        }
    }
    
    func searchLocal(_ keyword: String) async throws {
        items = try await dataCoordinator.getCachedSearchResults(for: keyword)
    }
    
    func search(keyword: String) async throws {
        lastSearchedKeyword = keyword
        // if online, get next page normally
        if reachability.hasNetworkConnection() {
            try await searchRemote(keyword)
        } else {
            // if offline, get all stored items for the keyword
            try await searchLocal(keyword)
        }
        
        delegate?.searchDidComplete()
    }
    
    func clearSearch() {
        items.removeAll()
        lastSearchedKeyword = ""
        currentPage = 1
        delegate?.searchDidComplete()
    }
    
    func currentPageDidUpdate() {
        if !lastSearchedKeyword.isEmpty && currentPage > 1 && reachability.hasNetworkConnection() {
            Task {
                try await search(keyword: lastSearchedKeyword)
            }
        }
    }
    
    func willDisplayCellAt(_ index: Int) {
        if index == (items.count - 1) {
            currentPage += 1
        }
    }
}
