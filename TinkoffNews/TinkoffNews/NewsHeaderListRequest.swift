//
//  NewsHeaderListRequest.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class NewsHeaderListRequest : Requestable {
    fileprivate let baseUrl: String = "https://api.tinkoff.ru/v1/news?"
    fileprivate let firstItemIndex: Int
    fileprivate let lastItemIndex: Int
        
    init(first: Int, last: Int) {
        firstItemIndex = first
        lastItemIndex = last
    }
    
    fileprivate var urlString: String {
        return baseUrl + "first=\(firstItemIndex)&last=\(lastItemIndex)"
    }
    
    var urlRequest: URLRequest? { return RequestURLFormatter.formatURLString(urlString) }
}
