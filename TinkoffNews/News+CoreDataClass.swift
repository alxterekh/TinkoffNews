//
//  News+CoreDataClass.swift
//  TinkoffNews
//
//  Created by Alexander on 19/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData

public class News: NSManagedObject {
    
    fileprivate static func fetchRequestNews(in context: NSManagedObjectContext, identifier: String) -> NSFetchRequest<News>? {
        let templateName = "NewsWithId"
        guard let model = context.persistentStoreCoordinator?.managedObjectModel,
            let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["identifier" : identifier]) as? NSFetchRequest<News> else {
                assert(false, "No template with name \(templateName)")
                
                return nil
        }
        
        return fetchRequest
    }
    
    static func findOrInsertNews(in context: NSManagedObjectContext, with identifier: String) -> News? {
        var news: News?
        guard let fetchRequest = News.fetchRequestNews(in: context, identifier: identifier) else {
            print("No fetch request!")
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundNews = results.first {
                news = foundNews
            }
        }
        catch {
            print("Failed to fetch News!")
        }
        
        if news == nil {
            news = News(context: context)
            news?.id = identifier
        }
        
        return news
    }
}
