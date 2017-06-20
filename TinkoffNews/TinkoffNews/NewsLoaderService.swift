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

}

class NewsLoaderService {
    
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
                NewsStorage.saveFetchedNews(news, completionHandler: completionHandler)
            case .Fail(let error):
                completionHandler(error)
            }
        }
    }
    
    func loadNewsContent(newsIdentifier: String, completionHandler: @escaping (String? ,String?) -> Void) {
        let config = RequestsFactory.NewsContentConfig(for: newsIdentifier)
        requestSender.send(config: config) {
            (result: Result<NewsContentApiModel>) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let content):
                    completionHandler(content.content, nil)
                case .Fail(let error):
                    completionHandler(nil, error)
                }
            }
        }
    }
}
