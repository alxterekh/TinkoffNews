//
//  NewsStorage.swift
//  TinkoffNews
//
//  Created by Alexander on 19/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData

class NewsStorage {
    
    static func saveFetchedNews(_ news: [NewsApiModel],
                                completionHandler: @escaping (String?) -> Void) {
        if let context = ServiceAssembly.coreDataStack.saveContext {
            for item in news {
                let identifier = item.identifier
                let text = item.text
                context.perform {
                    let news = News.findOrInsertNews(in: context, with: identifier)
                    news?.text = text
                }
            }
            
            ServiceAssembly.coreDataStack.performSave(context: context, completionHandler: completionHandler)
        }
    }
}
