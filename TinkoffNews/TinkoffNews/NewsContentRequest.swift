//
//  NewsContentRequest.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class NewsContentRequest : Requestable {
    
    fileprivate let baseUrl: String = "https://api.tinkoff.ru/v1/news_content?id="
    fileprivate let identifier: String
    
    fileprivate var urlString: String {
        return baseUrl + identifier
    }
    
    init(with identifier: String) {
        self.identifier = identifier
    }
        
    var urlRequest: URLRequest? { return RequestURLFormatter.formatURLString(urlString) }
}
