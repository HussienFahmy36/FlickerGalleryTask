//
//  FeederFlickerApiDatasource.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

class FeederFlickerApiDatasource: FeederRemoteDatasource {
    private enum FlickerAPIMethods {
        case search(keyword: String)
    }
    
    private struct Constants {
        static let HOSTNAME = "www.flickr.com"
        static let PATH = "/services/rest/"
        static let API_BASE = "https://www.flickr.com"
        static let METHOD = "method"
        static let SEARCH_METHOD = "flickr.photos.search"
        static let FORMAT_KEY = "format"
        static let FORMAT_VALUE = "json"
        static let NO_JSON_CALLBACK = "nojsoncallback"
        static let PAGE = "page"
        static let PER_NUMBER = "per_page"
        static let SEARCH_TEXT = "text"
        static let API_KEY = "api_key"
        static let API_KEY_VALUE = "d17378e37e555ebef55ab86c4180e8dc"
    }
    
    let networkHandler: NetworkHandlerProtocol
    
    init(networkHandler: NetworkHandlerProtocol) {
        self.networkHandler = networkHandler
    }
    
    private func buildURLComponents(for method: FlickerAPIMethods, page: Int, countPerPage: Int) -> URLComponents {
        switch method {
        case .search(let keyword):
            return buildURLComponentsForSearch(keyword: keyword, page: page, countPerPage: countPerPage)
            
        }
        
    }
    private func buildURLComponentsForSearch(keyword: String, page: Int, countPerPage: Int) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Constants.HOSTNAME
        urlComponents.path = Constants.PATH
        urlComponents.queryItems = [
            URLQueryItem(name: Constants.METHOD, value: Constants.SEARCH_METHOD),
            URLQueryItem(name: Constants.FORMAT_KEY, value: Constants.FORMAT_VALUE),
            URLQueryItem(name: Constants.NO_JSON_CALLBACK, value: "1"),
            URLQueryItem(name: Constants.PAGE, value: "\(page)"),
            URLQueryItem(name: Constants.SEARCH_TEXT, value: keyword),
            URLQueryItem(name: Constants.PER_NUMBER, value: "\(countPerPage)"),
            URLQueryItem(name: Constants.API_KEY, value: Constants.API_KEY_VALUE)
        ]
        return urlComponents
    }
    func search(_ keyword: String, page: Int = 1, countPerPage: Int) async throws -> [FeederDataItem] {

        guard !keyword.isEmpty else {
            return []
        }
        guard let urlAbsoluteString = buildURLComponents(for: .search(keyword: keyword), page: page,countPerPage: countPerPage).url?.absoluteString else {
            return []
        }

        guard let data = try await networkHandler.get(from: urlAbsoluteString) else {
            return []
        }
        let items = try JSONDecoder().decode(FlickerImagesResponse.self, from: data)
        return items.photos.photo.map { FeederDataItem(
            id: Int($0.id) ?? 0,
            imageURL: $0.url_PosterImage,
            title: $0.title,
            itemInPage: items.photos.page,
            tagKeyword: keyword)
        }
    }
}
