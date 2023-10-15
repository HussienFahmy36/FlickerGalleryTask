//
//  URLSessionHandlerTests.swift
//  FlickerGalleryTests
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import XCTest
@testable import FlickerGallery
final class URLSessionHandlerTests: XCTestCase {
    
    func test_invalidURL() async {
        let sut = URLSessionHandler()
        do {
            _ = try await sut.get(from: "invalid url here")
        } catch {
            let errorURL = error as? URLSessionHandlerErrors
            XCTAssertNotNil(errorURL)
            XCTAssertEqual(errorURL!, .invalidURL)
        }
        
    }
    
    func test_invalidHostname() async {
        let sut = URLSessionHandler()
        do {
            _ = try await sut.get(from: "https://serverResponseInvalid.com")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_ValidResponse() async {
        let sut = URLSessionHandler()
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        do {
            let data = try await sut.get(from: urlString)
            XCTAssertNotNil(data)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
