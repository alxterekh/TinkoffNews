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
    
    fileprivate let requestSender: RequestTransmitter = RequestSender()
    
//    init(requestSender: RequestTransmitter) {
//        self.requestSender = requestSender
//    }
    
    func loadNewsHeaderList(completionHandler: @escaping (String?) -> Void) {
        let config = RequestsFactory.NewsHeaderListConfig()
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
}
