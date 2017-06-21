//
//  NewsCell.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

protocol IdentifiableNewsCell {
    var identifier: String? { get }
    func configure(with news: News)
    func markAsViewed()
}

class NewsCell : UITableViewCell, UIWebViewDelegate, IdentifiableNewsCell {
    
    @IBOutlet fileprivate weak var newsHeaderLabel: UILabel!
    @IBOutlet fileprivate weak var viewsCountLabel: UILabel!
    
    private(set) var identifier: String?
    fileprivate var news: News?
    
    func configure(with news: News) {
        guard let text = news.text,
        let headerText = HTMLParser.parseHTMLStringToString(text) else {
            print("No news text")
            return
        }
        
        self.news = news
        identifier = news.id
        newsHeaderLabel.text = headerText
        viewsCountLabel.text = "\(news.viewsCount)"
    }
    
    func markAsViewed() {
        if let context = ServiceAssembly.coreDataStack.saveContext,
            let news = news,
            let newsOnSaveContext = context.object(with: news.objectID) as? News {
            context.perform {
                newsOnSaveContext.viewsCount += 1
                ServiceAssembly.coreDataStack.performSave(context: context) {_ in}
            }
            viewsCountLabel.text = "\(news.viewsCount)"
        }
    }
}


