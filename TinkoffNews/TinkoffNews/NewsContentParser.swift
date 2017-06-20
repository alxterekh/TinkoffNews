//
//  NewsContentParser.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NewsContentApiModel {
    let text: String
}

class NewsContentParser : Parser<NewsContentApiModel> {
    fileprivate let payLoadKey = "payload"
    fileprivate let contentKey = "content"
    
    override func parse(data: Data) -> NewsContentApiModel? {
        let json = JSON(data: data)
        guard let content = json[payLoadKey][contentKey].string else {
            print("No payload!")
            return nil
        }
        
        return NewsContentApiModel(text: content)
    }
}




