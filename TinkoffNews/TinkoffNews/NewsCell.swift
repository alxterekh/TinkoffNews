//
//  NewsCell.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class NewsCell : UITableViewCell, UIWebViewDelegate {
    
    @IBOutlet fileprivate weak var newsHeader: UILabel!
    @IBOutlet fileprivate weak var viewsCountLabel: UILabel!
    @IBOutlet weak var trailingViewsCountLabelToSuperview: NSLayoutConstraint!
    
    var identifier: String?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    fileprivate var news: News?
    
    func configure(with news: News) {
        guard let text = news.text else {
            print("no text")
            return
        }
        
        self.news = news
        let kek = parseHTMLStringToString(news.text!)
        newsHeader.text = kek
        identifier = news.id
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
    
    // encodedString should = a[0]["title"] in your case
    
    fileprivate func parseHTMLStringToString(_ encodedString: String) -> String {
        let encodedData = encodedString.data(using:.utf8)!
        let attributedOptions: [String : Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue)
        ]
        
        let attributedString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)

        let decodedString = attributedString.string
        
        return decodedString
    }
}




