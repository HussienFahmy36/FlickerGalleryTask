//
//  URLSessionHandler.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

public enum URLSessionHandlerErrors: Error, Equatable {
    case invalidURL
}

class URLSessionHandler: NetworkHandlerProtocol {
    func get(from url: String) async throws -> Data? {
        guard let url = URL(string: url) else {
            throw URLSessionHandlerErrors.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func get(from request: URLRequest) async throws -> Data? {
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
