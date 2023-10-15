//
//  FeederFlickerAPIDatasource.swift
//  FlickerGalleryTests
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import XCTest
@testable import FlickerGallery

final class FeederFlickerAPIDatasourceTests: XCTestCase {

    let apiFeeder = FeederFlickerApiDatasource(networkHandler: URLSessionHandler())
    
    func test_searchService() async throws {
        let countPerPage = 20
        do
        {
            let items = try await apiFeeder.search("Car", page: 1, countPerPage: countPerPage)
            XCTAssertEqual(items.count, countPerPage)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
