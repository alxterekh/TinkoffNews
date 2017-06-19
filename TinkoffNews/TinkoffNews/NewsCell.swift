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
    
    @IBOutlet weak var newsHeaderLabel: UILabel!
    @IBOutlet fileprivate weak var viewsCountLabel: UILabel!
    
    func configure(with news: News) {
        newsHeaderLabel.text = news.text
    }
}

