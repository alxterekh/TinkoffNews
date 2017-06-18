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
    
    init() {
        loadNewsHeaderList()
    }
    
//    init(requestSender: RequestTransmitter) {
//        self.requestSender = requestSender
//    }
    
    func loadNewsHeaderList() {
        let config = RequestsFactory.NewsHeaderListConfig()
        requestSender.send(config: config) {
            (result: Result<[NewsApiModel]>) in
            
//            switch result {
//            case .Success(let images):
//                completionHandler(images, nil)
//            case .Fail(let error):
//                completionHandler(nil, error)
//            }
        }
    }
}
