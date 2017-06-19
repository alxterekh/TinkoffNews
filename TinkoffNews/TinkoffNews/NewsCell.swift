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
    
    @IBOutlet weak var newsHeader: UIWebView!
    @IBOutlet fileprivate weak var viewsCountLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        newsHeader.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
    }
    
}

