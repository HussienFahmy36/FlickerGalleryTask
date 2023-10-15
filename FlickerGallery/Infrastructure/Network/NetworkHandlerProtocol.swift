//
//  NetworkHandlerProtocol.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

protocol NetworkHandlerProtocol {
    func get(from url: String) async throws -> Data?
    func get(from request: URLRequest) async throws -> Data?
}
