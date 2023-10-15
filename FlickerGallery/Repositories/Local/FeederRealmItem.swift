//
//  FeederRealmItem.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 14/10/2023.
//

import RealmSwift

class FeederRealmItem: Object {
    @Persisted var Id: Int
    @Persisted var imageURL: String
    @Persisted var title: String
    @Persisted var itemInPage: Int
    @Persisted var tagKeyword: String

    
    override class func primaryKey() -> String? {
        "Id"
    }

}
