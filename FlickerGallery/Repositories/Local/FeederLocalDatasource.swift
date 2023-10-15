//
//  FeederLocalDatasource.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

protocol FeederLocalDatasource {
    func search(_ keyword: String) async throws -> [FeederDataItem]
    func cache(items: [FeederDataItem]) async throws
    func clearCache() async throws
}
