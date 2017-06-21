//
//  NewsLoaderService.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

protocol NewsLoader {
    func loadNewsHeaderList(first: Int, last: Int, completionHandler: @escaping (String?) -> Void)
    func loadNewsContent(newsIdentifier: String, completionHandler: @escaping (String? ,String?) -> Void)
}

class NewsLoaderService : NewsLoader {
    
    fileprivate let requestSender: RequestTransmitter
    
    init(requestSender: RequestTransmitter) {
        self.requestSender = requestSender
    }
    
    func loadNewsHeaderList(first: Int, last: Int, completionHandler: @escaping (String?) -> Void) {
        let config = RequestsFactory.NewsHeaderListConfig(first: first, last: last)
        requestSender.send(config: config) {
            (result: Result<[NewsApiModel]>) in
            
            switch result {
            case .Success(let news):
                self.saveFetchedNews(news, completionHandler: completionHandler)
            case .Fail(let error):
                completionHandler(error)
            }
        }
    }
    
    func loadNewsContent(newsIdentifier: String, completionHandler: @escaping (String? ,String?) -> Void) {
        let config = RequestsFactory.NewsContentConfig(for: newsIdentifier)
        requestSender.send(config: config) {
            (result: Result<NewsContentApiModel>) in
            
            switch result {
            case .Success(let content):
                self.saveFetchedNewsContent(content) {_ in
                    completionHandler(content.content, nil)
                }
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    // MARK: - Cashing recivied data
    
    fileprivate var orderIndex = 0
    
    fileprivate  func saveFetchedNews(_ news: [NewsApiModel],
                         completionHandler: @escaping (String?) -> Void) {
        if let context = ServiceAssembly.coreDataStack.saveContext {
            context.perform {
                for item in news {
                    let news = News.findOrInsertNews(in: context, with: item.identifier)
                    news?.text = item.text
                    self.orderIndex += 1
                    news?.orderIndex = Int64(self.orderIndex)
                }
                
                ServiceAssembly.coreDataStack.performSave(context: context, completionHandler: completionHandler)
            }
        }
    }
    
    fileprivate func saveFetchedNewsContent(_ content: NewsContentApiModel,
                                completionHandler: @escaping (String?) -> Void) {
        if let context = ServiceAssembly.coreDataStack.saveContext,
            let news = News.findOrInsertNews(in: context, with: content.identifier) {
            context.perform {
                news.content = content.content
                ServiceAssembly.coreDataStack.performSave(context: context, completionHandler: completionHandler)
            }
        }
    }
}


