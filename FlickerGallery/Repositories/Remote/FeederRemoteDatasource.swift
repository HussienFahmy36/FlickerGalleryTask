//
//  FlickerImagesFeederRemote.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

protocol FeederRemoteDatasource {
    func search(_ keyword: String, page: Int, countPerPage: Int) async throws -> [FeederDataItem]
}
