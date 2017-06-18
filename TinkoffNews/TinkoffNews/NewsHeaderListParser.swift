//
//  NewsListParser.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NewsApiModel {
    let identifier: String
    let text: String
}

class NewsHeaderListParser: Parser<[NewsApiModel]> {
    
    fileprivate let payLoadKey = "payload"
    fileprivate let identifierKey = "id"
    fileprivate let textKey = "text"
    
    override func parse(data: Data) -> [NewsApiModel]? {
        let json = JSON(data: data)
        var news = [NewsApiModel]()
        guard let fetchedNews = json[payLoadKey].array else {
            print("No payload!")
            return nil
        }
        
        for item in fetchedNews {
            guard let id = item[identifierKey].string,
                let info =  item[textKey].string else {
                    continue
            }
            
            news.append(NewsApiModel(identifier: id, text: info))
        }

        return news
    }
}
