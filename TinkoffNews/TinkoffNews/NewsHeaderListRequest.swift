//
//  NewsHeaderListRequest.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class NewsHeaderListRequest : Requestable {
    fileprivate let baseUrl: String = "https://api.tinkoff.ru/v1/news?first=20&last=100"
    
    // MARK: - Initialization
    
    fileprivate var urlString: String {
        return baseUrl
    }
    
    // MARK: -
    
    var urlRequest: URLRequest? { return RequestURLFormatter.formatURLString(urlString) }
}
