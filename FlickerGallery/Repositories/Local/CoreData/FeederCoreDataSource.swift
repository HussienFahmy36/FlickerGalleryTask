//
//  FeederCoreDataSource.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import CoreData

class FeederCoreDataSource: FeederLocalDatasource {
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "FlickrCoreDataModel")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    func search(_ keyword: String) async throws -> [FeederDataItem] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FeederCoreDataItem>(entityName: "FeederCoreDataItem")
        fetchRequest.predicate = NSPredicate(format: "tagKeyword == %@", keyword)
        let items = try context.fetch(fetchRequest)
        return items.map {
            FeederDataItem(id: Int($0.iD), imageURL: $0.imageURL ?? "", title: $0.title ?? "", itemInPage: Int($0.itemInPage), tagKeyword: $0.tagKeyword ?? "")
        }
    }
    
    func cache(items: [FeederDataItem]) async throws {
        let context = persistentContainer.viewContext
        for item in items {
            let coreDataItem = FeederCoreDataItem(context: context)
            coreDataItem.iD = Int64(item.id)
            coreDataItem.imageURL = item.imageURL
            coreDataItem.itemInPage = Int64(item.itemInPage)
            coreDataItem.tagKeyword = item.tagKeyword
            coreDataItem.title = item.title
        }
        try context.save()
    }
    
    func clearCache() async throws {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<FeederCoreDataItem>(entityName: "FeederCoreDataItem")
        let items = try context.fetch(fetchRequest)
        
        for item in items {
            context.delete(item)
        }
        try context.save()
    }
    
    
}
