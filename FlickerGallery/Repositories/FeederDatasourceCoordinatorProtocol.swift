//
//  FeederDatasourceCoordinatorProtocol.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 15/10/2023.
//

import Foundation
protocol FeederDatasourceCoordinatorProtocol {
    var local: FeederLocalDatasource { get set }
    var remote: FeederRemoteDatasource { get set }
    
    func searchAndSyncCache(_ keyword: String, page: Int, countPerPage: Int) async throws -> [FeederDataItem]
    func getCachedSearchResults(for keyword: String) async throws -> [FeederDataItem]
}
