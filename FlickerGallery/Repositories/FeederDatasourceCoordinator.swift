//
//  FeederDatasourceCoordinator.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

class FeederDatasourceCoordinator: FeederDatasourceCoordinatorProtocol  {
    
    var local: FeederLocalDatasource
    var remote: FeederRemoteDatasource
    init(
        local: FeederLocalDatasource,
        remote: FeederRemoteDatasource
    ) {
        self.local = local
        self.remote = remote
    }
    
    func searchAndSyncCache(_ keyword: String, page: Int = 1, countPerPage: Int) async throws -> [FeederDataItem] {
        let dataItems = try await remote.search(keyword, page: page, countPerPage: countPerPage)
        cache(items: dataItems) // called async and we don't depend on it for the search results
        return dataItems
    }
    
    func getCachedSearchResults(for keyword: String) async throws -> [FeederDataItem] {
        return try await self.local.search(keyword)
    }

    
    private func cache(items: [FeederDataItem]) {
        Task {
            try await self.local.cache(items: items)
        }
    }
    
    private func clearCache() {
        Task {
            try await self.local.clearCache()
        }
    }
}
