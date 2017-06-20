//
//  NewsCell.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class NewsCell : UITableViewCell {
    
    @IBOutlet fileprivate weak var newsHeader: UIWebView!
    @IBOutlet fileprivate weak var viewsCountLabel: UILabel!
    
    fileprivate var viewsCount = 0
    
    var identifier: String?
    
    func configure(with news: News) {
        guard let text = news.text else {
            print("no text")
            return
        }
        
        newsHeader.loadHTMLString(text, baseURL: nil)
        identifier = news.id
    }
    
    func markAsViewed() {
        viewsCount += 1
        viewsCountLabel.text = "\(viewsCount)"
    }
}

