//
//  FlickerImagesResponse.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

// MARK: - FlickerImagesResponse
struct FlickerImagesResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    var url_PosterImage: String {
        "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
