//
//  RequestsFactory.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class RequestsFactory {
    
    static func NewsHeaderListConfig(first: Int, last: Int) -> RequestConfig<[NewsApiModel]> {
        let request = NewsHeaderListRequest(first: first, last: last)
        return RequestConfig<[NewsApiModel]>(request:request, parser: NewsHeaderListParser())
    }
    
    static func NewsContentConfig(for identifier: String) -> RequestConfig<NewsContentApiModel> {
        let request = NewsContentRequest(with: identifier)
        return RequestConfig<NewsContentApiModel>(request:request, parser: NewsContentParser())
    }
}
