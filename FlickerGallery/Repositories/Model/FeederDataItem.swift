//
//  FlickerDataItem.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import Foundation

struct FeederDataItem {
    let id: Int
    var imageURL: String = ""
    var imageData: Data? = nil
    var title: String = ""
    var itemInPage: Int = 1
    var tagKeyword: String = ""
}
