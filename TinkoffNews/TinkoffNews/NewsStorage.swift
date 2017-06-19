//
//  NewsStorage.swift
//  TinkoffNews
//
//  Created by Alexander on 19/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class NewsStorage {
    
    static fileprivate let coreDataStack = ServiceAssembly.coreDataStack
    
    static func saveFetchedNews(_ news: [NewsApiModel],
                                completionHandler: @escaping (String?) -> Void) {
        for item in news {
            let identifier = item.identifier
            let text = item.text
            NewsStorage.saveNews(with: identifier,
                                 text: text,
                                 completionHandler: completionHandler)
        }
    }

    static fileprivate func saveNews(with identifier: String,
                                     text: String,
                                     completionHandler: @escaping (String?) -> Void) {
        if let context = coreDataStack.saveContext {
            context.perform {
                let news = News.findOrInsertNews(in: context, with: identifier)
                news?.text = text
            }
            
            coreDataStack.performSave(context: context, completionHandler: completionHandler)
        }
    }
}
