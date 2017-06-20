//
//  NewsContentViewController.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit

class NewsContentViewController: UIViewController {
    
    @IBOutlet var newsContent: UIWebView!
    
    fileprivate let newsLoaderService = ServiceAssembly.newsLoaderService
    
    var newsIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewsContent()
    }
    
    fileprivate func fetchNewsContent() {
        guard let identifier = newsIdentifier else {
            print("No news identifier!")
            return
        }
        
        newsLoaderService.loadNewsContent(newsIdentifier: identifier) {
            if let error = $1 {
                print(error)
            }
            else {
               self.newsContent.loadHTMLString($0!, baseURL: nil)
            }
        }
    }
}
