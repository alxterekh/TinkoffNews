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
    
    fileprivate static var orderIndex = 0
    
    static func saveFetchedNews(_ news: [NewsApiModel],
                                completionHandler: @escaping (String?) -> Void) {
        if let context = ServiceAssembly.coreDataStack.saveContext {
            for item in news {
                let identifier = item.identifier
                let text = item.text
                let news = News.findOrInsertNews(in: context, with: identifier)
                news?.text = text
                news?.orderIndex = Int64(orderIndex)
                orderIndex += 1
            }
            
            ServiceAssembly.coreDataStack.performSave(context: context, completionHandler: completionHandler)
        }
    }
}
