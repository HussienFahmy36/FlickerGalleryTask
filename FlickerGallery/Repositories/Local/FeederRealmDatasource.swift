//
//  FeederRealmDatasource.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import RealmSwift

@globalActor actor BackgroundActor: GlobalActor {
    static var shared = BackgroundActor()
}
class FeederRealmDatasource: FeederLocalDatasource {
    
    @BackgroundActor
    func search(_ keyword: String) async throws -> [FeederDataItem] {
        let realm = try await Realm(actor: BackgroundActor.shared)
        let objects = realm.objects(FeederRealmItem.self).filter("tagKeyword == %@", keyword)
        return objects.map { FeederDataItem(id: $0.Id, imageURL: $0.imageURL, title: $0.title, itemInPage: $0.itemInPage, tagKeyword: $0.tagKeyword)}
    }
    
    @BackgroundActor
    func cache(items: [FeederDataItem]) async throws {
        let realm = try await Realm(actor: BackgroundActor.shared)
        var realmItems: [FeederRealmItem] = []
        
        for item in items {
            let realmItem = FeederRealmItem()
            realmItem.title = item.title
            realmItem.imageURL = item.imageURL
            realmItem.Id = item.id
            realmItem.tagKeyword = item.tagKeyword
            realmItem.itemInPage = item.itemInPage
            realmItems.append(realmItem)
        }
        
        try await realm.asyncWrite {
            realm.add(realmItems, update: .modified)
        }
    }
    
    @BackgroundActor
    func clearCache() async throws {
        let realm = try await Realm(actor: BackgroundActor.shared)
        try await realm.asyncWrite {
            realm.delete(realm.objects(FeederRealmItem.self))
        }
    }
}
